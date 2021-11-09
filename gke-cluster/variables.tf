variable "cluster_name" {
  type = string
}

variable "region" {
  type = string
}

variable "zone" {
  type = string
}

variable "nodepool_name" {
  type = string
  default = "optima-nodepool"
}

variable "machine_type" {
  type = string
  default = "n1-standard-1"
}

# variable "frontend_static_ip_name" {
#   type = string
# }

# variable "backend_static_ip_name" {
#   type = string
# }
