variable "proxmox_host" {
  type = map(any)
  default = {
    pm_api_url  = "https://pve2.lukcic.net:8006/api2/json"
    target_node = "pve2"
    token_id    = "terraform@pam!terraform"
  }
}

variable "proxmox_user" {
  type = string
}

variable "proxmox_password" {
  type      = string
  sensitive = true
}

variable "proxmox_token_id" {
  type = string
}

variable "proxmox_token_secret" {
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

variable "rndc_key" {
  type      = string
  sensitive = true
}
