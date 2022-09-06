terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~>2.3"
    }
  }
}


# Use either NGINX or Kong ingress

# // Nginx Ingress Controller Helm Chart
# resource "helm_release" "nginx_ingress_controller" {
#   provider = helm
#   name       = "ingress-nginx"
#   repository = "https://kubernetes.github.io/ingress-nginx"
#   chart      = "ingress-nginx"
#   version    = "3.34.0"

#   namespace        = "nginx-ingress"
#   create_namespace = true
# }
