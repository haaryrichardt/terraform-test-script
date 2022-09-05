resource "kubernetes_secret" "svc-account-secret" {
  metadata {
    name = "clouddns-dns01-solver-svc-acct"
    namespace = "cert-manager"
  }

  data = {
    "<enter json file name of service account>" = file("<enter json file name of service account>")
  }
}