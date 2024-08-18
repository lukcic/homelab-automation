variable "proxmox_host" {
  type = map(any)
  default = {
    pm_api_url  = "https://192.168.254.33:8006/api2/json"
    pm_user     = "root@pam"
    target_node = "pve2"
    token_id    = "root@pam!root_token"
  }
}

variable "proxmox_password" {
  type = string
}

variable "project_root" {
  type = string
}
