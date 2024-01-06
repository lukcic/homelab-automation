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
}
