terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~>2.3"
    }
  }
}

// Nginx Ingress Controller Helm Chart
# resource "helm_release" "nginx_ingress_controller" {
#   provider = helm
#   name       = "ingress-nginx"
#   repository = "https://kubernetes.github.io/ingress-nginx"
#   chart      = "ingress-nginx"
#   version    = "3.34.0"

#   namespace        = "nginx-ingress"
#   create_namespace = true
# }

// Kong Ingress Controller Helm Chart
resource "helm_release" "kong_ingress_controller" {
  provider = helm
  name       = "kong"
  repository = "https://charts.konghq.com"
  chart      = "kong"
  version    = "2.4.0"

  namespace        = "kong"
  create_namespace = true

  # depends_on = [
  #   helm_release.nginx_ingress_controller
  # ]
}

// Cert Manager Helm Chart
resource "helm_release" "cert_manager" {
  provider = helm
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.5.4"

  namespace        = "cert-manager"
  create_namespace = true

  set {
    name  = "installCRDs"
    value = "true"
  }
  
  depends_on = [
    helm_release.kong_ingress_controller
  ]
}