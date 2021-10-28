// Static IP Address for Frontend
# resource "google_compute_address" "frontend_static_ip" {
#   name = var.frontend_static_ip_name
# }

// Static IP Address for Backend
# resource "google_compute_address" "backend_static_ip" {
#   name = var.backend_static_ip_name
# }
# data "google_container_engine_versions" "default" {
#   location       = var.zone
#   version_prefix = "1.21."
# }

# output "stable_channel_version" {
#   value = data.google_container_engine_versions.default.release_channel_default_version["RAPID"]
# }

// Autopilot
# resource "google_container_cluster" "optima_cluster" {
#   name             = var.cluster_name
#   enable_autopilot = true
#   location         = var.region

#   min_master_version = "1.21.4-gke.1801"

#   private_cluster_config {
#     enable_private_nodes    = true
#     enable_private_endpoint = false
#     master_ipv4_cidr_block  = "10.5.0.0/28"
#   }

#   master_authorized_networks_config {
#     cidr_blocks {
#       cidr_block   = "0.0.0.0/0"
#       display_name = "master_auth_network"
#     }
#   }

#   release_channel {
#     channel = "RAPID"
#   }

#   vertical_pod_autoscaling {
#     enabled = true
#   }
# }