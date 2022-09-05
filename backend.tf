terraform {
  backend "gcs" {
    bucket      = "test-devops-tf-state"
    credentials = "<enter json file name of service account>"
  }
}