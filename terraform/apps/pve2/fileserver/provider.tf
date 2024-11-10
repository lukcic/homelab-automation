terraform {
  required_version = "1.5.5"
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = ">= 2.9.5"
    }
    dns = {
      source  = "hashicorp/dns"
      version = "3.2.3"
    }
  }
  backend "s3" {
    bucket         = "lukcic-homelab-terrafrom-state"
    key            = "fileserver.lukcic.net"
    region         = "eu-north-1"
    dynamodb_table = "lukcic-homelab-terrafrom-lock-fileserver"
    encrypt        = true
  }
}

provider "proxmox" {
  pm_tls_insecure = true
  pm_api_url      = var.proxmox_host.pm_api_url
  # pm_api_token_id     = var.proxmox_token_id
  # pm_api_token_secret = var.proxmox_token_secret
  pm_user     = var.proxmox_user
  pm_password = var.proxmox_password
}
