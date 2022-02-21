#!/usr/bin/env bash

NAMESPACE="$1"
DEST_DIR="$2"

echo "in create-secrets"
echo "${NAMESPACE}"
echo "${DEST_DIR}"

mkdir -p "${DEST_DIR}"

if [[ -z "${ADMIN_PASSWORD}" ]] || [[ -z "${NON_ADMIN_PASSWORD}" ]] || [[ -z "${DB_PASSWORD}" ]]; then
  echo "DB_USER, DB_PASSWORD, GRAFANA_USER, and GRAFANA_PASSWORD must be provided as environment variables"
  exit 1
fi

kubectl create secret generic ibm-oms-ent-prod-oms-secret \
  --from-literal="consoleadminpassword=${ADMIN_PASSWORD}" \
  --from-literal="consolenonadminpassword=${NON_ADMIN_PASSWORD}" \
  --from-literal="dbpassword=${DB_PASSWORD}" \
  -n "${NAMESPACE}" \
  --dry-run=client \
  --output=yaml > "${DEST_DIR}/ibm-oms-ent-prod-oms-secret.yaml"

echo "secret ibm-oms-ent-prod-oms-secret created"

kubectl adm policy add-scc-to-user anyuid system:serviceaccount:${NAMESPACE}:ibm-oms-ent-prod-ibm-oms-ent-prod

kubectl policy add-role-to-user edit system:serviceaccount:${NAMESPACE}:ibm-oms-ent-prod-ibm-oms-ent-prod

kubectl secrets link ibm-oms-ent-prod-ibm-oms-ent-prod  ibm-registry --for=pull


