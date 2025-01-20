terraform {
  required_version = "1.5.5"
  required_providers {
    proxmox = {
      # source  = "telmate/proxmox"
      # version = ">= 2.9.14"
      source  = "MaartendeKruijf/proxmox"
      version = "0.0.1"
    }
  }
  backend "s3" {
    bucket         = "lukcic-homelab-terraform-state"
    key            = "tubearchivist.lukcic.net"
    region         = "eu-north-1"
    dynamodb_table = "lukcic-homelab-terraform-locks"
    encrypt        = true
  }
}

provider "proxmox" {
  pm_tls_insecure = true

  pm_api_url  = var.proxmox_host.pm_api_url
  pm_user     = var.proxmox_host.pm_user
  pm_password = var.proxmox_password

  pm_log_enable = true
  pm_log_file   = "terraform-plugin-proxmox.log"
  pm_debug      = true
  pm_log_levels = {
    _default    = "debug"
    _capturelog = ""
  }
}
