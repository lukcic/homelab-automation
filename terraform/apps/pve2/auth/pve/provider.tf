terraform {
  required_version = "1.5.5"
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = ">= 2.9.5"
    }
  }
  backend "s3" {
    bucket         = "lukcic-homelab-terraform-state"
    key            = "dev-cluster"
    region         = "eu-north-1"
    dynamodb_table = "lukcic-homelab-terraform-locks"
    encrypt        = true
  }
}

provider "proxmox" {
  pm_api_url      = var.proxmox_api_url
  pm_user         = var.proxmox_user
  pm_password     = var.proxmox_password
  pm_tls_insecure = true
}
