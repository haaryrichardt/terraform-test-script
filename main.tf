terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~>3.88"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~>1.13"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~>2.3"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.6.1"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.7.2"
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

provider "kubectl" {
  host  = "https://${data.google_container_cluster.default.endpoint}"
  token = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.default.master_auth[0].cluster_ca_certificate,
  )
}

provider "kubernetes" {
  host  = "https://${data.google_container_cluster.default.endpoint}"
  token = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.default.master_auth[0].cluster_ca_certificate,
  )
}

###################### Cloud Router ######################

resource "google_compute_router" "router" {
  name    = "optima-devtest-router"
  region  = local.region
  network = "default"
}

####################### Cloud NAT ########################

resource "google_compute_router_nat" "nat" {
  name                               = "optima-devtest-router-nat"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

module "gke_cluster" {
  source       = "./gke-cluster"
  cluster_name = local.cluster_name
  region       = local.region
  zone         = local.zone
  // frontend_static_ip_name = local.frontend_static_ip_name
  // backend_static_ip_name  = local.backend_static_ip_name
}

module "helm" {
  source = "./helm"
  // frontend_static_ip = module.gke_cluster.frontend_ip
  // backend_static_ip  = module.gke_cluster.backend_ip
  depends_on = [
    google_compute_router_nat.nat
  ]
}

resource "time_sleep" "wait_5_seconds" {
  depends_on = [
    module.helm
  ]
  create_duration = "5s"
}

module "kubernetes" {
  source     = "./kubernetes"
  depends_on = [
    time_sleep.wait_5_seconds
  ]
}

module "k8s" {
  source = "./k8s"
  depends_on = [
    module.kubernetes
  ]
}
