#  IBM Sterling OMS gitops module

The Sterling Order Management Software (OMS Plain Vanilla) images are Red Hat container certified and offer a more simple and efficient way to deploy, manage, and scale secure enterprise-grade software across multiple environments. This Module provisions a sterling OMS repo with the resources necessary to deploy on a cluster. In order to deploy Sterling OMS the following steps are performed:

1. Add the Sterling OMS chart to the gitops repo (charts/ibm-oms-ent-prod)

This module requires DB2 installed.

#### Installation time with breakdowns 

- DB2 Dataload with creation 1000+ tables, index etc : 2 hour 30 min
- Plain Vanilla Sterling OMS : 22 min

## Software dependencies

The module depends on the following software components:
- DB2 
- Portworx Storage
  

### DB2 Connection Parameters

##### update the DB2 information in the variables.tf

##### database 
- serverName 
- port 
- dbname 
- user 
- dbvendor = "db2"
- datasourceName =  "jdbc/OMDS"
- systemPool =  true
- schema = 
- ssl =  false    


##### DB2 Data - Load 

⚠️⚠️⚠️⚠️ Recommendations : Refer IBM Sterling OMS data load appraoch which pre-populates the database with the 1200 tables and index 

Load factory setup data for Sterling Store Engagement (Legacy) - https://www.ibm.com/docs/en/order-management-sw/10.0?topic=lfsd-load-factory-setup-data-sterling-store-engagement-legacy

As result, Database will be populated with 1200 tables and indexes.

##### DB2 Data - Dont Load  
- If you dont want to load the Data to DB2, Pls make change

```
datasetup_config = {
  loadFactoryData = "donotinstall"
      mode = ""
      fixPack = {  
        loadFPFactoryData = ""
        installedFPNo = 0
      }
  } 
```

### PVC Creation

- Make sure Portworx got installed on the Openshift and verify the Storage class exist
- storageClassName = "portworx-db2-rwx-sc"

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
## References :

- [OMS Helm Chart implementation](https://github.com/IBM/charts/blob/master/repo/ibm-helm/ibm-oms-ent-prod.md#ssl-configurations-for-securing-external-connections)
