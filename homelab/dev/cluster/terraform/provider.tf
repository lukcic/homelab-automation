
terraform {
  required_version = "1.5.5"
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc6"
    }
    dns = {
      source  = "hashicorp/dns"
      version = "3.4.2"
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
  pm_tls_insecure     = true
  pm_api_url          = var.proxmox_api_url
  pm_api_token_id     = var.proxmox_token_id
  pm_api_token_secret = var.proxmox_token_secret
}

provider "dns" {
  update {
    server        = "192.168.254.53"
    key_name      = "tsig-key."
    key_algorithm = "hmac-sha256"
    key_secret    = var.rndc_key
  }
}
