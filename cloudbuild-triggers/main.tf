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
      node-push-devops = "Optima-2.0"
  }
  name     = each.key
  github {
    owner = "Optima-soltuions"
    name  = each.value
    push {
      branch = "devops-istio"
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