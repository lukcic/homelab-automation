locals {
  app-name = "auth"
  ip       = "192.168.254.30"
}

resource "proxmox_lxc" "authentik" {

  hostname     = local.app-name
  cores        = 2
  memory       = 1024
  target_node  = "pve2"
  ostemplate   = "local:vztmpl/debian-12-standard_12.7-1_amd64.tar.zst"
  password     = var.container_password
  vmid         = 25430
  ostype       = "debian"
  onboot       = true
  unprivileged = false
  start        = true
  protection   = false

  ssh_public_keys = file("~/.ssh/proxmox-lxc-root.pub")
  nameserver      = "192.168.254.53"

  rootfs {
    storage = "local-zfs"
    size    = "10G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = local.ip
    gw     = "192.168.254.254"
    tag    = "254"
  }

  connection {
    host        = local.ip
    user        = "root"
    private_key = file("~/.ssh/proxmox-lxc-root.pem")
    agent       = false
    timeout     = "5m"
  }

  provisioner "remote-exec" {
    inline = [
      "curl -fsSL https://get.docker.com -o get-docker.sh",
      "sh get-docker.sh"
    ]
  }

}
