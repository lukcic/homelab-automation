variable "proxmox_api_token_id" {}
variable "proxmox_api_token_secret" {}
variable "proxmox_api_url" {}

variable "target_node" {
  description = "Proxmox node name, ex: pve"
  default     = "pve2"
}

variable "proxmox_user" {
  type = string
}

variable "proxmox_password" {
  type      = string
  sensitive = true
}

variable "container_password" {
  type      = string
  sensitive = true
}

variable "project_root" {
  type = string
}
