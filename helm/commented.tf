// Nginx Ingress Controller Helm Chart
# resource "helm_release" "nginx_ingress_controller" {
#   name       = "ingress-nginx"
#   repository = "https://kubernetes.github.io/ingress-nginx"
#   chart      = "ingress-nginx"
#   version    = "4.0.6"

#   namespace        = "nginx-ingress"
#   create_namespace = true

#   set {
#     name  = "controller.service.loadBalancerIP"
#     value = var.frontend_static_ip
#   }
# }

# data "helm_template" "kong_ingress_controller" {
#   name             = "kong"
#   namespace        = "kong"
#   create_namespace = true
#   repository       = "https://charts.konghq.com"

#   chart   = "kong"
#   version = "2.4.0"

#   set {
#     name  = "proxy.loadBalancerIP"
#     value = var.backend_static_ip
#   }
# }

# resource "local_file" "kong_ingress_controller_manifests" {
#   for_each = data.helm_template.kong_ingress_controller.manifests

#   filename = "./${each.key}"
#   content  = each.value
# }

# resource "helm_release" "cert_manager" {
#   name       = "cert-manager"
#   repository = "https://charts.jetstack.io"
#   chart      = "cert-manager"
#   // version    = "v1.5.4"

#   namespace        = "cert-manager"
#   create_namespace = true

#   #   set {
#   #     name  = "installCRDs"
#   #     value = "true"
#   #   }
# }