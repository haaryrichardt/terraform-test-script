terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~>3.88"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~>2.3"
    }
  }
}

provider "google" {
  credentials = file(local.credentials_file)
  project     = local.project
  region      = local.region
}

data "google_client_config" "default" {
  depends_on = [module.gke_cluster]
}

data "google_container_cluster" "default" {
  name       = local.cluster_name
  location   = local.zone
  depends_on = [module.gke_cluster]
}

provider "helm" {
  kubernetes {
    host  = "https://${data.google_container_cluster.default.endpoint}"
    token = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(
      data.google_container_cluster.default.master_auth[0].cluster_ca_certificate,
    )
  }
}


###################### Managed Ingress/Load Balancer ######################


  
  
 # TO-DO
  
  

####################### Managed Ingress/Load Balancer ########################


module "gke_cluster" {
  source       = "./gke-cluster"
  cluster_name = local.cluster_name
  region       = local.region
  zone         = local.zone
}

module "helm" {
  source = "./helm"
  depends_on = [
    google_compute_router_nat.nat
  ]
}
  
resource "google_sql_database_instance" "test" {
  name             = "test-instance"
  database_version = "POSTGRES_14"
  region           = "us-central1"

  settings {
    # Second-generation instance tiers are based on the machine
    # type. See argument reference below.
    tier = "db-f1-micro"
  }
}

module "cloudbuild_triggers" {
  source       = "./cloudbuild-triggers"
  cluster_name = local.cluster_name
  zone         = local.zone
}
