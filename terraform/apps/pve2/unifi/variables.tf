variable "proxmox_api_url" {}
variable "proxmox_user" {}
variable "proxmox_password" {}

variable "target_node" {
  description = "Proxmox node name, ex: pve"
  default     = "pve2"
}

variable "ostemplate" {
  default     = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  description = "The volume identifier that points to the OS template or backup file (full path)"
}

variable "hostname" {
  type = string
}

variable "unifi_ver" {
  type = string
}

variable "container_id" {
  type = string
}

variable "container_password" {
  type      = string
  sensitive = true
}

variable "network" {
  type = object({
    name   = optional(string, "eth0")
    bridge = optional(string, "vmbr254")
    ip     = optional(string, "dhcp")
    gw     = optional(string)
    tag    = optional(string)
  })
}