locals {
  cluster_name     = "optima-devtest"
  credentials_file = "wipro-gcp-kubernetes-poc-3e571acc8905.json"
  project          = "wipro-gcp-kubernetes-poc"
  region           = "us-east1"

  zone = "us-east1-b"
  // frontend_static_ip_name = "frontend-static-ip"
  // backend_static_ip_name  = "backend-static-ip"
}
