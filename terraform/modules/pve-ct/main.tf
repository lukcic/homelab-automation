resource "proxmox_lxc" "container" {
  hostname     = var.hostname
  cores        = var.hardware.cores
  memory       = var.hardware.memory
  target_node  = var.target_node
  ostemplate   = var.ostemplate
  password     = var.container_password
  vmid         = var.container_id
  onboot       = var.settings.onboot
  unprivileged = var.settings.unprivileged
  start        = var.settings.start
  protection   = var.settings.protection

  ssh_public_keys = file(var.ssh_public_keys)

  rootfs {
    storage = var.rootfs.storage
    size    = var.rootfs.size
  }

  nameserver = var.network.dns

  network {
    name   = var.network.name
    bridge = var.network.bridge
    ip     = format("%s/24", var.network.ip)
    gw     = var.network.gw
    tag    = var.network.tag
  }

  features {
    nesting = var.settings.nesting
  }

  connection {
    host        = var.network.ip
    user        = "root"
    private_key = file(var.ssh_conn_private_key)
    agent       = false
    timeout     = "5m"
  }

  provisioner "remote-exec" {
    inline = var.remote_provisioner_commands
  }

  provisioner "local-exec" {
    working_dir = var.local_provisioner.working_dir
    command     = var.local_provisioner.command
    environment = var.local_provisioner.environment
  }
}
