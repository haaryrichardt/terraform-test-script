terraform {
  backend "gcs" {
    bucket      = "optima-devtest-tf-state"
    credentials = "wipro-gcp-kubernetes-poc-3e571acc8905.json"
  }
}