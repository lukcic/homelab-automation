terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }

  backend "s3" {
    bucket         = "lukcic-homelab-terraform-state"
    key            = "authentik-prod-docker.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "lukcic-homelab-terraform-locks"
    profile        = "lukcic_priv"
    encrypt        = true
  }
}

provider "docker" {
  host = "ssh://root@auth.lukcic.net"
  ssh_opts = [
    "-o",
    "StrictHostKeyChecking=no",
    "-o",
    "UserKnownHostsFile=/dev/null"
  ]
}
