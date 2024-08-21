/**
 * # Main title
 *
 * Kong Ingress Controller
 *
 * Module to deploy install in Kubernetes the Kong Ingress Controller
 */

resource "helm_release" "kong" {
  name             = var.name
  repository       = var.repository
  chart            = var.chart
  create_namespace = var.create_namespace
  namespace        = var.namespace

  set {
    name  = "service.type"
    value = "ClusterIP"
  }
}
