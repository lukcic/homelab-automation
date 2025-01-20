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
  pm_api_url      = var.proxmox_api_url
  pm_user         = var.proxmox_user
  pm_password     = var.proxmox_password
  pm_tls_insecure = true
}

resource "proxmox_lxc" "unifi" {
  hostname     = "unifi.lukcic.net"
  cores        = 2
  memory       = 512
  target_node  = var.target_node
  ostemplate   = var.ostemplate
  password     = var.container_password
  vmid         = var.container_id
  onboot       = true
  unprivileged = true
  start        = true
  protection   = false

  ssh_public_keys = file("../../../../../files/ssh-keys/ansible-key-ecdsa.pub")

  rootfs {
    storage = "local-lvm"
    size    = "8G"
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
      "sudo apt update && sudo apt upgrade -y",
      "sudo apt install gnupg curl -y",
      "sudo curl -fsSL https://pgp.mongodb.com/server-4.4.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-4.4.gpg --dearmor",
      "sudo echo \"deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-4.4.gpg ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse\" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list",
      "sudo echo \"deb http://security.ubuntu.com/ubuntu focal-security main\" | sudo tee /etc/apt/sources.list.d/focal-security.list",
      "sudo apt update",
      "sudo apt install libssl1.1 mongodb-org -y",
      "sudo systemctl enable --now mongod",
      "sudo wget https://dl.ui.com/unifi/${var.unifi_ver}/unifi_sysvinit_all.deb",
      "sudo apt install ./unifi_sysvinit_all.deb -y",
    ]
  }
}