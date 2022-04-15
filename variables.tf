
variable "gitops_config" {
  type        = object({
    boostrap = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
    })
    infrastructure = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
      payload = object({
        repo = string
        url = string
        path = string
      })
    })
    services = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
      payload = object({
        repo = string
        url = string
        path = string
      })
    })
    applications = object({
      argocd-config = object({
        project = string
        repo = string
        url = string
        path = string
      })
      payload = object({
        repo = string
        url = string
        path = string
      })
    })
  })
  description = "Config information regarding the gitops repo structure"
}

variable "git_credentials" {
  type = list(object({
    repo = string
    url = string
    username = string
    token = string
  }))
  description = "The credentials for the gitops repo(s)"
  sensitive   = true
}

variable "namespace" {
  type        = string
  description = "The namespace where the application should be deployed"
}

variable "kubeseal_cert" {
  type        = string
  description = "The certificate/public key used to encrypt the sealed secrets"
  default     = ""
}

variable "server_name" {
  type        = string
  description = "The name of the server"
  default     = "default"
}

variable "consoleadminpassword" {
  type        = string
  description = "The grafana user"
  sensitive   = true
  default     = "password"
}

variable "consolenonadminpassword" {
  type        = string
  description = "The grafana password"
  sensitive   = true
  default     = "password"
}

variable "entitlement_key" {
  type        = string
  description = "The entitlement key required to access Cloud Pak images"
  sensitive   = true
}

variable "agent_image_tag" {
  type        = string
  description = "The tag of the agent image"
  default     = "10.0.0.26-amd64"
}

variable "appserver_image_tag" {
  type        = string
  description = "The tag of the agent image"
  default     = "10.0.0.26-amd64"
}

variable "db_server" {
  type        = string
  description = "Host IP of DB"
  default     = "db2w-nvirjaw.us-east.db2w.cloud.ibm.com"
}

variable "db_port" {
  type        = number
  description = "Port for DB Server"
  default     = 50001
}

variable "db_name" {
  type        = string
  description = "Database name"
  default     = "BLUDB"
}

variable "schema_name" {
  type        = string
  description = "Schema name for OMS database"
  default     = "OMDB"
}

variable "db_user" {
  type        = string
  description = "User name for DB"
  default     = "bluadmin"
}
variable "dbpassword" {
  type        = string
  description = "The DB2 password"
  sensitive   = true
  default     = "fbZw3MaEf2V7J8i28Km@F3qqPluvq"
}

variable "ingress_host" {
  type        = string
  description = "Ingress host name"
  default     = "toolkit-dev-ocp48-gitops2-2ab66b053c14936810608de9a1deac9c-0000.us-east.containers.appdomain.cloud"
}









      
