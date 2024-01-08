terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
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

provider "docker" {
  host     = "ssh://ansible@docker01.lukcic.net:22"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null", "-i", "~/.ssh/ansible-key-ecdsa.pem"]
}
