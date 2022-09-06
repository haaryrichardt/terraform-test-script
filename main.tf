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


###################### GKE Ingress ######################

# Static IPv4 address for Ingress Load Balancing
resource "google_compute_global_address" "ingress-ipv4" {
  name       = "${var.cluster_name}-ingress-ipv4"
  ip_version = "IPV4"
}
  
# Forward IPv4 TCP traffic to the HTTP proxy load balancer
resource "google_compute_global_forwarding_rule" "ingress-http-ipv4" {
  name        = "${var.cluster_name}-ingress-http-ipv4"
  ip_address  = google_compute_global_address.ingress-ipv4.address
  ip_protocol = "TCP"
  port_range  = "80"
  target      = google_compute_target_http_proxy.ingress-http.self_link
}

###################### Cloud Router ######################

resource "google_compute_router" "router" {
  name    = "test-devops-router"
  region  = local.region
  network = "default"
}

####################### Cloud NAT ########################

resource "google_compute_router_nat" "nat" {
  name                               = "test-devops-router-nat"
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
}

module "helm" {
  source = "./helm"
  depends_on = [
    google_compute_router_nat.nat
  ]
}

# sleep time to make sure terraform gets enough time to install helm before going to kubernetes installatiom stage

resource "time_sleep" "wait_5_seconds" {
  depends_on = [
    module.helm
  ]
  create_duration = "5s"
}

module "cloudbuild_triggers" {
  source       = "./cloudbuild-triggers"
  cluster_name = local.cluster_name
  zone         = local.zone
}
