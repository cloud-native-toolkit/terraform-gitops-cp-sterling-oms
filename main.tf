locals {
  name          = "ibm-oms-ent-prod"
  bin_dir       = module.setup_clis.bin_dir
  yaml_dir      = "${path.cwd}/.tmp/${local.name}/chart/${local.name}"
  service_url   = "http://${local.name}.${var.namespace}"
  secret_dir         = "${path.cwd}/.tmp/${local.name}/secrets"
  chart_dir          = "${path.module}/chart/ibm-oms-ent-prod"
  global_config    = {    
      license = true
      licenseStoreCallCenter = true
      fullNameOverride = ""
      nameOverride = ""
      image = {    
        repository = "cp.icr.io/cp/ibm-oms-enterprise"
        agentName = "om-agent"
        tag = var.agent_image_tag
        pullPolicy = "Always"
      } 
      appSecret = "ibm-oms-ent-prod-oms-secret"
      database = {    
        serverName = var.db_server
        port = var.db_port
        dbname = var.db_name
        user = var.db_user
        dbvendor = "db2"
        datasourceName =  "jdbc/OMDS"
        systemPool =  true
        schema = var.schema_name
        ssl =  false    
      }
      
      serviceAccountName = "ibm-oms-ent-prod-ibm-oms-ent-prod"  
      customerOverrides = []
      security = {
        ssl = {
          trustStore = {        
            storeLocation = ""
            trustJavaCACerts = false
            trustedCertDir = ""
          }
          keyStore = {        
            storeLocation = ""
          }
        }
      }  
      envs = []
      persistence = {
        claims = {      
          name = "oms-pv"
          accessMode = "ReadWriteMany"
          capacity = 10
          capacityUnit = "Gi"
          storageClassName = "portworx-db2-rwx-sc"
        }
        securityContext = {      
          fsGroup = 0
          supplementalGroup = 0
        }
      }
      mq = {    
        bindingConfigName = ""
        bindingMountPath = "/opt/ssfs/.bindings"
      }
      arch = {
        amd64 = "2 - No preference"
        ppc64le = "2 - No preference"
      }
      log = {
        format = "json"
      }
      resources = {
        requests = {      
          memory = "1024Mi"
          cpu = 0.5
        }
        limits = {      
          memory = "2048Mi"
          cpu = 1
        }
      }  
      customConfigMaps = []
      customSecrets = []
  } 

  appserver_config = {
    deploymentStrategy = {}
      exposeRestService = false
      replicaCount = 1
      image = {    
        tag = var.appserver_image_tag
        pullPolicy = "Always"
        names = [
          {
          name = "om-app"    
          tag = var.appserver_image_tag
          }
          ]
      }   
      config = {    
        vendor =  "websphere"
        vendorFile = "servers.properties"
        serverName = "DefaultAppServer"
        jvm = {      
          xms = "2048m"
          xmx = "2048m"
          params = []
        }
        database = {      
          maxPoolSize = 50
          minPoolSize = 10
        }
        corethreads = 20
        maxthreads = 100
        libertyServerXml = ""
        libertyStartupWrapper = "/opt/ibm/helpers/runtime/docker-server.sh"
      }
      livenessCheckBeginAfterSeconds = 900
      livenessFailRestartAfterMinutes = 10
      terminationGracePeriodSeconds = 60
      service = {
        http = {      
          port = 9080
        }
        https = {      
          port = 9443
        }
        annotations = {}
        labels = {}
      }
      resources = {
        requests = {      
          memory = "2560Mi"
          cpu = 1
        }
        limits = {      
          memory = "3840Mi"
          cpu = 2
        }
      }
      ingress = {    
        host = var.ingress_host
        ssl = {      
          enabled = false
          secretname = ""
        }
        controller = "nginx"
        contextRoots = ["smcfs", "sbc", "sma", "isccs", "wsc", "adminCenter"]
        annotations = {}
        labels = {}
      }
      podLabels = {}
      tolerations = []
      nodeAffinity = {    
        requiredDuringSchedulingIgnoredDuringExecution = {}
        preferredDuringSchedulingIgnoredDuringExecution = []
      }
      podAffinity = {   
        requiredDuringSchedulingIgnoredDuringExecution = []
        preferredDuringSchedulingIgnoredDuringExecution = []
      }
      podAntiAffinity = {    
        requiredDuringSchedulingIgnoredDuringExecution = []
        preferredDuringSchedulingIgnoredDuringExecution = []
        replicaNotOnSameNode = {      
          mode = "prefer"
          weightForPreference = 100
        }
      }
  }

  omserver_config = {
    deploymentStrategy = {}
      image = { 
        name = "om-agent"    
        tag = var.agent_image_tag
        pullPolicy = "Always"
      }
      common = {
        jvmArgs = "-Xms512m -Xmx1024m"
        replicaCount = 1
        resources = {
          requests = {        
            memory = "1024Mi"
            cpu = 0.5
          }
          limits = {        
            memory = "2048Mi"
            cpu = 1
          }
        }
        readinessFailRestartAfterMinutes = 10
        terminationGracePeriodSeconds =  60
        podLabels =  {}
        tolerations =  []
        nodeAffinity = {
          requiredDuringSchedulingIgnoredDuringExecution =  {}
          preferredDuringSchedulingIgnoredDuringExecution =  []
        }
        podAffinity = {
          requiredDuringSchedulingIgnoredDuringExecution =  []
          preferredDuringSchedulingIgnoredDuringExecution =  []
        }
        podAntiAffinity = {
          requiredDuringSchedulingIgnoredDuringExecution =  []
          preferredDuringSchedulingIgnoredDuringExecution =  []
          replicaNotOnSameNode = {        
            mode =  "prefer"
            weightForPreference =  100
          }
        }
      }
      healthMonitor = {  
        deploy = false
        jvmArgs = ""
        replicaCount = 0
        resources = {}
      }
      servers = []

  }

  datasetup_config = {
    loadFactoryData = "donotinstall"
    #loadFactoryData = "install"
      mode = ""
      fixPack = {  
        loadFPFactoryData = ""
        installedFPNo = 0
      }
  }     
  
  values_content = {
    global = local.global_config    
    appserver = local.appserver_config
    omserver = local.omserver_config
    datasetup = local.datasetup_config
  }

  layer = "services"
  type  = "instances"
  application_branch = "main"
  namespace = var.namespace
  layer_config = var.gitops_config[local.layer]
  sa_name       = "ibm-oms-ent-prod-ibm-oms-ent-prod"  
}

module setup_clis {
  source = "github.com/cloud-native-toolkit/terraform-util-clis.git"
}

module pull_secret {
  source = "github.com/cloud-native-toolkit/terraform-gitops-pull-secret"

  gitops_config = var.gitops_config
  git_credentials = var.git_credentials
  server_name = var.server_name
  kubeseal_cert = var.kubeseal_cert
  namespace = var.namespace
  docker_username = "cp"
  docker_password = var.entitlement_key
  docker_server   = "cp.icr.io"
  secret_name     = "ibm-entitlement-key"
  
}

resource null_resource create_yaml {
  provisioner "local-exec" {
    command = "${path.module}/scripts/create-yaml.sh '${local.name}' '${local.yaml_dir}'"

    environment = {
      VALUES_CONTENT = yamlencode(local.values_content)      
    }
  }
}

module "service_account" {
  source = "github.com/cloud-native-toolkit/terraform-gitops-service-account.git"

  gitops_config = var.gitops_config
  git_credentials = var.git_credentials
  namespace = var.namespace
  name = local.sa_name
  sccs = ["anyuid", "privileged"]

  rbac_rules = [{
    apiGroups = [""]
    resources = ["secrets","configmaps"]
    verbs = [ "*" ]
  }]

  rbac_roles = [{
    name = "update"
  }]

  rbac_cluster_scope = true
  server_name = var.server_name
  pull_secrets = ["ibm-entitlement-key"]
}

resource null_resource create_secrets_yaml {
  depends_on = [null_resource.create_yaml]

  provisioner "local-exec" {
    command = "${path.module}/scripts/create-secrets.sh '${var.namespace}' '${local.secret_dir}'"

    environment = {      
      ADMIN_PASSWORD = var.consoleadminpassword
      NON_ADMIN_PASSWORD = var.consolenonadminpassword
      DB_PASSWORD = var.dbpassword
    }
  }
}

module seal_secrets {
  depends_on = [null_resource.create_secrets_yaml]

  source = "github.com/cloud-native-toolkit/terraform-util-seal-secrets.git"

  source_dir    = local.secret_dir
  dest_dir      = "${local.yaml_dir}/templates"
  kubeseal_cert = var.kubeseal_cert
  label         = local.name
}

resource null_resource setup_gitops {  
  depends_on = [null_resource.create_yaml, module.service_account, null_resource.create_secrets_yaml, module.seal_secrets]
  triggers = {
    name = local.name
    namespace = var.namespace
    yaml_dir = local.yaml_dir
    server_name = var.server_name
    layer = local.layer
    type = local.type
    git_credentials = yamlencode(var.git_credentials)
    gitops_config   = yamlencode(var.gitops_config)
    bin_dir = local.bin_dir
  }

  provisioner "local-exec" {
    command = "${self.triggers.bin_dir}/igc gitops-module '${self.triggers.name}' -n '${self.triggers.namespace}' --contentDir '${self.triggers.yaml_dir}' --serverName '${self.triggers.server_name}' -l '${self.triggers.layer}' --type '${self.triggers.type}'"

    environment = {
      GIT_CREDENTIALS = nonsensitive(self.triggers.git_credentials)
      GITOPS_CONFIG   = self.triggers.gitops_config
    }
  }

  provisioner "local-exec" {
    when = destroy
    command = "${self.triggers.bin_dir}/igc gitops-module '${self.triggers.name}' -n '${self.triggers.namespace}' --delete --contentDir '${self.triggers.yaml_dir}' --serverName '${self.triggers.server_name}' -l '${self.triggers.layer}' --type '${self.triggers.type}'"

    environment = {
      GIT_CREDENTIALS = nonsensitive(self.triggers.git_credentials)
      GITOPS_CONFIG   = self.triggers.gitops_config
    }
  }
}
