module "oms" {
  source = "./module"

  gitops_config = module.gitops.gitops_config
  git_credentials = module.gitops.git_credentials
  server_name = module.gitops.server_name
  namespace = module.gitops_namespace.name
  kubeseal_cert = module.gitops.sealed_secrets_cert
  entitlement_key = module.cp_catalogs.entitlement_key
  consoleadminpassword = "password"
  consolenonadminpassword = "password"
  dbpassword = "BntaPhf3lQ0aTjLg"
}
