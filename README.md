#  Sterling OMS gitops module

The Sterling Order Management Software images are Red Hat container certified and offer a more simple and efficient way to deploy, manage, and scale secure enterprise-grade software across multiple environments. This Module provisions a sterling OMS repo with the resources necessary to deploy on a cluster. In order to deploy Sterling OMS the following steps are performed:

1. Add the Sterling OMS chart to the gitops repo (charts/ibm-oms-ent-prod)

This module requires DB2 installed in the cluster

## Software dependencies

The module depends on the following software components:

### Command-line tools

- terraform - v15
- kubectl

### Terraform providers

- IBM Cloud provider >= 1.5.3
- Helm provider >= 1.1.1 (provided by Terraform)

## Module dependencies

This module makes use of the output from other modules:

- GitOps - github.com/cloud-native-toolkit/terraform-tools-gitops.git
- Namespace - github.com/cloud-native-toolkit/terraform-gitops-namespace.git
- etc

## Example usage

```
module "oms" {
  source = "github.com/cloud-native-toolkit/terraform-gitops-cp-sterling-oms.git"

  gitops_config = module.gitops.gitops_config
  git_credentials = module.gitops.git_credentials
  server_name = module.gitops.server_name
  namespace = module.gitops_namespace.name
  kubeseal_cert = module.gitops.sealed_secrets_cert
  entitlement_key = module.cp_catalogs.entitlement_key  
}
```

