locals {
  cluster_name     = "test-devops"
  credentials_file = "<enter json file name of service account>"
  project          = "<enter gcp project name >"
  region           = "us-east4"

  zone = "us-east4-b"
  // frontend_static_ip_name = "frontend-static-ip"
  // backend_static_ip_name  = "backend-static-ip"
}
