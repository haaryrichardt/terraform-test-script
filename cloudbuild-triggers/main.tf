# main tf file to load build triggers into native gcp triggers
# integrate github org details as mentioned below 
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~>3.88"
    }
  }
}

resource "google_cloudbuild_trigger" "devops_push_triggers" {
  for_each = {
      node-push-devops = "<repo-name>"
  }
  name     = each.key
  github {
    owner = "<org name>"
    name  = each.value
    push {
      branch = "<branch name>"
    }
  }
  filename = "cloudbuild.yaml"
  substitutions = {
    _CLOUDSDK_COMPUTE_ZONE = var.zone
    _CLOUDSDK_CONTAINER_CLUSTER = var.cluster_name
    _NAME_SPACE = "default"
    _RELEASE_SUFFIX = "devops"
  }
}