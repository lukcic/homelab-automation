variable "environment" {
  type        = string
  description = "Environment: dev/stg/prod"

  validation {
    condition     = can(regex("^(dev|stg|prod)$", var.environment))
    error_message = "Must be: dev/stg/prod"
  }
}

variable "proxmox_api_url" {
  type = string
}

variable "proxmox_token_id" {
  type = string
}

variable "proxmox_token_secret" {
  type      = string
  sensitive = true
}

variable "proxmox_user" {
  type = string
}

variable "proxmox_password" {
  type      = string
  sensitive = true
}

variable "node_name" {
  type = string
}

variable "project_root" {
  type = string
}

variable "user_name" {
  type        = string
  description = "Admin user name"
}

variable "user_password" {
  type        = string
  sensitive   = true
  description = "Admin user password"
}

variable "user_public_key" {
  type        = string
  sensitive   = true
  description = "Admin user public ssh key"
}

variable "ansible_public_key" {
  type        = string
  sensitive   = true
  description = "Ansible user public ssh key"
}

variable "ansible_private_key_path" {
  type        = string
  sensitive   = true
  description = "Ansible user private ssh key path"
}

variable "rndc_key" {
  type      = string
  sensitive = true
}

variable "master_ip" {
  type = string
}

variable "domain" {
  type = string
}

variable "ptr_domain" {
  type = string
}

variable "k8s_nodes" {
  type = set(object(
    {
      name         = string
      container_id = number
      pve_node     = string
      ip           = string
    }
  ))
}

variable "container_password" {
  type      = string
  sensitive = true
}

