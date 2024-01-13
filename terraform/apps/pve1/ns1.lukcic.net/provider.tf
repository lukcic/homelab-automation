terraform {
  required_version = "1.5.5"
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = ">= 2.9.5"
    }
  }
  backend "s3" {
    bucket         = "lukcic-homelab-terrafrom-state"
    key            = "ns1.lukcic.net"
    region         = "eu-north-1"
    dynamodb_table = "lukcic-homelab-terrafrom-lock-ns1"
    encrypt        = true
  }
}

provider "proxmox" {
  pm_tls_insecure = true

  pm_api_url  = var.proxmox_host.pm_api_url
  pm_user     = var.proxmox_host.pm_user
  pm_password = var.proxmox_password
}
