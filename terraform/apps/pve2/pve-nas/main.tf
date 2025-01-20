terraform {
  required_version = ">= 1.1.0"
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = ">= 2.9.5"
    }
  }
}

provider "proxmox" {
  #pm_api_token_id     = var.proxmox_api_token_id
  #pm_api_token_secret = var.proxmox_api_token_secret
  pm_api_url      = var.proxmox_api_url
  pm_user         = var.proxmox_user
  pm_password     = var.proxmox_password
  pm_tls_insecure = true
}

resource "proxmox_lxc" "pve-nas" {
  hostname     = "pve-nas.lukcic.net"
  cores        = 2
  memory       = 1024
  target_node  = var.target_node
  ostemplate   = var.ostemplate
  password     = var.container_password
  vmid         = var.container_id
  ostype       = "debian"
  onboot       = true
  unprivileged = true
  start        = true
  protection   = false

  ssh_public_keys = file("../../../../../files/ssh-keys/ansible-key-ecdsa.pub")

  rootfs {
    storage = "local-zfs"
    size    = "10G"
  }

  mountpoint {
    key     = "0" # mp0
    slot    = 0
    storage = "qnap"
    mp      = "/mnt/shares"
    size    = "10G"
  }

  network {
    name   = var.network.name
    bridge = var.network.bridge
    ip     = format("%s/24", var.network.ip)
    gw     = var.network.gw
    tag    = var.network.tag
  }

  features {
    nesting = true
    mount   = "nfs;cifs"
  }

  connection {
    host        = var.network.ip
    user        = "root"
    private_key = file("~/.ssh/ansible-key-ecdsa.pem")
    agent       = false
    timeout     = "5m"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'deb http://deb.debian.org/debian bookworm-backports main contrib' >> /etc/apt/sources.list",
      "apt update && apt full-upgrade -y",
      "apt install -t bookworm-backports cockpit --no-install-recommends -y",
      "sed -i 's/root/#root/g' /etc/cockpit/disallowed-users",
      "wget https://github.com/45Drives/cockpit-file-sharing/releases/download/v3.3.4/cockpit-file-sharing_3.3.4-1focal_all.deb",
      "wget https://github.com/45Drives/cockpit-navigator/releases/download/v0.5.10/cockpit-navigator_0.5.10-1focal_all.deb",
      "wget https://github.com/45Drives/cockpit-identities/releases/download/v0.1.12/cockpit-identities_0.1.12-1focal_all.deb",
      "apt install ./cockpit*.deb -y",
      "systemctl enable --now cockpit",
    ]
  }
}