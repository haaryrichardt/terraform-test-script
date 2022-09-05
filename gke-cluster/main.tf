terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~>3.88"
    }
  }
}

# resource to create the test cluster 
# provide cidr block as mentioned 

resource "google_container_cluster" "test_cluster" {
  name             = var.cluster_name
  location         = var.zone
  remove_default_node_pool = true
  initial_node_count = 3

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "10.14.2.0/28"
  }

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = ""
    services_ipv4_cidr_block = ""
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "0.0.0.0/0"
      display_name = "master_auth_network"
    }
  }
}

# resource to create the node-pool used by the cluster 
# machine config, scaling and node count can be dynamically allocated as mentioned below 

resource "google_container_node_pool" "test_nodepool" {
  name       = var.nodepool_name
  location   = var.zone
  cluster    = google_container_cluster.test_cluster.name
  node_count = 3
  autoscaling {
    min_node_count = 3
    max_node_count = 5
  }
  node_config {
    preemptible       = true
    disk_size_gb      = 100
    disk_type         = "pd-standard"
    guest_accelerator = []
    image_type        = "COS"
    labels            = {}
    machine_type      = var.machine_type
    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append"
    ]
  }
}


