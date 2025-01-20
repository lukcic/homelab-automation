variable "proxmox_host" {
  type = map(any)
  default = {
    pm_api_url  = "https://pve2.lukcic.net:8006/api2/json"
    pm_user     = "root@pam"
    target_node = "pve2"
  }
}

variable "proxmox_password" {
  type = string
}

variable "project_root" {
  type = string
}

variable "container_password" {
  type      = string
  sensitive = true
}

variable "domain" {
  type = string
}
