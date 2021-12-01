resource "kubernetes_secret" "svc-account-secret" {
  metadata {
    name = "clouddns-dns01-solver-svc-acct"
    namespace = "cert-manager"
  }

  data = {
    "wipro-gcp-kubernetes-poc-f67be0dcaaf8.json" = file("wipro-gcp-kubernetes-poc-f67be0dcaaf8.json")
  }
}