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
    key            = "proxy.lukcic.net"
    region         = "eu-north-1"
    dynamodb_table = "lukcic-homelab-terrafrom-lock-proxy"
    encrypt        = true
  }
}

provider "proxmox" {
  pm_tls_insecure = true

  pm_api_url  = var.proxmox_host.pm_api_url
  pm_user     = var.proxmox_host.pm_user
  pm_password = var.proxmox_password
}

provider "dns" {
  update {
    server        = "192.168.254.53"
    key_name      = "tsig-key."
    key_algorithm = "hmac-sha256"
    key_secret    = var.rndc_key
  }
}
