/**
 * # Main title
 *
 * Group of module to deploy any resource in Azure to support Kubernetes Servuce
 *
 * OBS.: Em ambiente produtivo, alteraria o source para a url do git.  Não fiz para otimizar o tempo
 * 
 *  O objectivo aqui, foi criar um cluster AKS que já saia com o ArgoCD, Ingress, Vault e tudo mais instalado.  Claro, ficou pendentes algumas configs desses serviços.  Onde poderiamos fazer de forma do helm_release aplicandos os set, ou aplicar através de um arquivo.
 *  Outra alternativa, seria criar o cluster e deploy com o ArgoCD fazer o deploy dos demais recursos. 
 */

locals {
  created_at     = formatdate("YYYY-MM-DD", timestamp())
  managed_by     = { "managed_by" : "terraform" }
  tags           = merge({ "created_at" : "${local.created_at}", "managed_by" : "terraform" }, var.tags)
  private_domain = var.private_domain == "" ? "private.${local.name}.com" : var.private_domain
  name_id        = format("%05d", var.name_id)
  name           = "${var.name}${local.name_id}"
  environment    = "development"

  kube = module.aks[0].raw
}

module "resource_group" {
  source   = "./modules/rsg"
  tags     = local.tags
  name     = local.name
  location = var.location
}

module "identity" {
  source         = "./modules/idm"
  tags           = local.tags
  name           = local.name
  location       = var.location
  resource_group = module.resource_group.name
}


module "private_dns" {
  source         = "./modules/private_dns"
  tags           = local.tags
  name           = local.private_domain
  resource_group = module.resource_group.name
}

module "log_analytics" {
  source         = "./modules/law"
  tags           = local.tags
  name           = local.name
  resource_group = module.resource_group.name
  identity = {
    type         = "UserAssigned"
    identity_ids = [module.identity.id]
  }
  sku               = var.law_sku
  retention_in_days = var.retention_in_days
}

module "aks" {
  source = "./modules/aks"
  count  = 1
  name   = "${var.name}${format("%05d", local.name_id + count.index)}"
  tags   = local.tags

  identity = {
    type         = "UserAssigned"
    identity_ids = [module.identity.id]
  }

  resource_group = module.resource_group.name

  default_node_pool = {
    name                   = var.default_node_pool.name
    node_count             = var.default_node_pool.node_count
    enable_host_encryption = var.default_node_pool.enable_host_encryption
    os_disk_size_gb        = var.default_node_pool.os_disk_size_gb
    os_disk_type           = var.default_node_pool.os_disk_type
    os_sku                 = var.default_node_pool.os_sku
    pod_subnet_id          = var.default_node_pool.pod_subnet_id
    ultra_ssd_enabled      = var.default_node_pool.ultra_ssd_enabled
    vm_size                = var.default_node_pool.vm_size
    zones                  = var.default_node_pool.zones
  }

  node_pool = var.node_pool

  oms_agent = {
    log_analytics_workspace_id = module.log_analytics.id
  }

  scale_down_mode     = var.scale_down_mode
  dns_prefix          = var.dns_prefix
  ultra_ssd_enabled   = var.ultra_ssd_enabled
  enable_auto_scaling = var.enable_auto_scaling
  network_profile     = var.network_profile
}

resource "cloudflare_record" "www" {
  domain  = "${var.cloudflare_domain}"
  name    = "gitops"
  value   = "203.0.113.10"
  type    = "A"
  proxied = false
}

# module "ingress" {
#   count      = var.enabled_ingress_controller.enabled == true ? 1 : 0
#   source     = "./modules/ingress"
#   name       = var.enabled_ingress_controller.name
#   repository = var.enabled_ingress_controller.repository
#   chart      = var.enabled_ingress_controller.chart
# }

# module "argocd" {
#   source     = "./modules/argoproj/argocd"
#   count      = var.enabled_argocd.enabled == true ? 1 : 0
#   name       = var.enabled_argocd.name
#   repository = var.enabled_argocd.repository
#   chart      = var.enabled_argocd.chart
#   # version     = var.enabled_argocd.version
#   namespace        = var.enabled_argocd.namespace
#   installCRDs      = var.enabled_argocd.installCRDs
#   create_namespace = var.enabled_argocd.create_namespace
# }

# module "vault" {
#   source           = "./modules/vault"
#   count            = var.enabled_vault.enabled == true ? 1 : 0
#   name             = var.enabled_vault.name
#   repository       = var.enabled_vault.repository
#   chart            = var.enabled_vault.chart
#   namespace        = var.enabled_vault.namespace
#   installCRDs      = var.enabled_vault.installCRDs
#   create_namespace = var.enabled_vault.create_namespace
# }

# module "secrets" {
#   source           = "./modules/external-secrets"
#   count            = var.enabled_secrets.enabled == true ? 1 : 0
#   name             = var.enabled_secrets.name
#   repository       = var.enabled_secrets.repository
#   chart            = var.enabled_secrets.chart
#   namespace        = var.enabled_secrets.namespace
#   installCRDs      = var.enabled_secrets.installCRDs
#   create_namespace = var.enabled_secrets.create_namespace
# }
