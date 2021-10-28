terraform {
  backend "gcs" {
    bucket      = "optima-devops-tf-state"
    credentials = "wipro-gcp-kubernetes-poc-3e571acc8905.json"
  }
}