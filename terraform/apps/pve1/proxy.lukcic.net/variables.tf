variable "proxmox_host" {
  type = map(any)
  default = {
    pm_api_url  = "https://pve1.lukcic.net:8006/api2/json"
    pm_user     = "root@pam"
    target_node = "pve1"
    token_id    = "root@pam!root_token"
  }
}

variable "proxmox_password" {
  type = string
}

variable "container_password" {
  type      = string
  sensitive = true
}

variable "project_root" {
  type = string
}

variable "rndc_key" {
  type      = string
  sensitive = true
}
