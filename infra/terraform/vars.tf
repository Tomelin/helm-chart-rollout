##############################
### Default configurations ###
variable "tags" {
  type        = map(string)
  default     = {}
  description = "List of tags to resource group."
}

variable "name" {
  type        = string
  default     = "tomelin"
  description = "Name of Azure resource"
}

variable "name_id" {
  type        = number
  default     = 00003
  description = "ID to generate a different resources"
}

variable "location" {
  type        = string
  default     = "East US"
  description = "The Azure region to deploy resources"

  validation {
    condition = contains(["East US", "West US", "Brazil South", "Brazil"], var.location)

    error_message = "The location available are: 'East US', 'West US', 'Brazil South', and 'Brazil'"
  }
}

##############################
## Azure Private DNS #########

variable "private_domain" {
  type        = string
  default     = ""
  description = "Name to create a private dns zone"
}

##############################
## Azure Kubernetes Service ##

variable "dns_prefix" {
  type        = string
  default     = "internal"
  description = "DNS prefix to deploy with kubernetes"
}


variable "default_node_pool" {
  type = object({
    name                   = string
    node_count             = number
    enable_host_encryption = optional(string)
    os_disk_size_gb        = optional(string)
    os_disk_type           = optional(string)
    os_sku                 = optional(string)
    ultra_ssd_enabled      = optional(bool)
    vm_size                = optional(string)
    pod_subnet_id          = optional(string)
    zones                  = list(string)
  })
  default = {
    name                   = "dpool"
    node_count             = 1
    enable_host_encryption = false
    zones                  = ["1", "2", "3"]
  }
  description = "AKS default node pool"
}

variable "node_pool" {
  type = list(object({
    name                   = string
    node_count             = number
    enable_host_encryption = optional(string)
    os_disk_size_gb        = optional(string)
    os_disk_type           = optional(string)
    os_sku                 = optional(string)
    ultra_ssd_enabled      = optional(bool)
    vm_size                = optional(string)
    pod_subnet_id          = optional(string)
    zones                  = list(string)
    tags                   = optional(map(string))
  }))
  default = []
  # default = [{
  #   name                   = "dpool"
  #   node_count             = 2
  #   enable_host_encryption = false
  #   zones                  = ["1", "2", "3"]
  # }]
  description = "AKS node pool"
}


variable "scale_down_mode" {
  type        = string
  default     = "Deallocate"
  description = "Specifies the autoscaling behaviour of the Kubernetes Cluster"
}

variable "ultra_ssd_enabled" {
  type        = bool
  default     = false
  description = "Used to specify whether the UltraSSD is enabled in the Default Node Pool."
}

variable "enable_auto_scaling" {
  type        = bool
  default     = false
  description = "Should the Kubernetes Auto Scaler be enabled for this Node Pool"
}

variable "network_profile" {
  type = object({
    load_balancer_sku = optional(string)
    network_plugin    = optional(string)
    network_policy    = optional(string)
    outbound_type     = optional(string)
    pod_cidr          = optional(string)
    service_cidr      = optional(string)
    dns_service_ip    = optional(string)
  })
  default     = {}
  description = "Network profile kubernetes"
}

##############################
## Log analytics workspace ###


variable "retention_in_days" {
  type        = number
  default     = 30
  description = "Number of days to retention the logs"
}

variable "law_sku" {
  type        = string
  default     = "PerGB2018"
  description = "Specifies the SKU of the Log Analytics Workspace"
}

variable "enabled_ingress_controller" {
  type = object({
    name       = string
    repository = string
    chart      = string
    enabled    = bool

  })
  default = {
    name       = "ingress-controller"
    repository = "https://kubernetes.github.io/ingress-nginx"
    chart      = "ingress-nginx"
    enabled    = true
  }
  description = "Enable to install nginx ingress controller"
}

variable "enabled_argocd" {
  type = object({
    name             = optional(string)
    repository       = optional(string)
    chart            = optional(string)
    version          = optional(string)
    namespace        = optional(string)
    installCRDs      = optional(bool)
    enabled          = bool
    create_namespace = optional(bool)

  })
  default = {
    name             = "argocd"
    enabled          = true
    chart            = "argo-cd"
    create_namespace = true
  }
  description = "ArgoCD"
}

##############################
## CLOUDFLARE
variable "cloudflare_account" {
  type        = string
  description = "Account of cloudflare"
  default     = ""
}

variable "cloudflare_domain" {
  type        = string
  default     = "synera.com.br"
  description = "Domain to create a new dns record"
}

variable "cloudflare_dns_token" {
  type        = string
  description = "DNS to authentication in cloudflare"
  default     = ""
  sensitive   = true
}

variable "cloudflare_dns_address" {
  type        = string
  description = "IP address to create a new record"
  default     = "127.0.0.1"
}

variable "cloudflare_dns_enable" {
  type        = bool
  default     = false
  description = "Should the Kubernetes Auto Scaler be enabled for this Node Pool"
}



# variable "enabled_vault" {
#   type = object({
#     name             = optional(string)
#     repository       = optional(string)
#     chart            = optional(string)
#     version          = optional(string)
#     namespace        = optional(string)
#     installCRDs      = optional(bool)
#     enabled          = bool
#     create_namespace = optional(bool)

#   })
#   default = {
#     name             = "vault"
#     enabled          = true
#     chart            = "vault"
#     create_namespace = true
#   }
#   description = "Hashicorp Vault"
# }


# variable "enabled_secrets" {
#   type = object({
#     name             = optional(string)
#     repository       = optional(string)
#     chart            = optional(string)
#     version          = optional(string)
#     namespace        = optional(string)
#     installCRDs      = optional(bool)
#     enabled          = bool
#     create_namespace = optional(bool)

#   })
#   default = {
#     name             = "external-secrets"
#     enabled          = true
#     chart            = "external-secrets-operator "
#     create_namespace = true
#   }
#   description = "External secrets"
# }
