resource "proxmox_vm_qemu" "prox-vm" {

  name        = var.hostname
  target_node = var.target_node


  vmid       = var.vmid
  full_clone = true
  clone      = "debian12-cloud"

  sockets = var.hardware.sockets
  cores   = var.hardware.cores
  memory  = var.hardware.memory
  balloon = var.hardware.balloon

  boot     = "c"
  bootdisk = var.rootfs.bootdisk

  scsihw = "virtio-scsi-pci"

  onboot = var.settings.onboot
  agent  = 0
  #cpu     = "kvm64"
  #numa    = true
  #hotplug = "network,disk,cpu,memory"

  network {
    bridge = var.network.bridge
    tag    = var.network.tag
    model  = var.network.model
  }

  ipconfig0 = "ip=${format("%s/24", var.network.ip)},gw=${var.network.gw}"
  #ipconfig0 = "ip=dhcp"
  nameserver = var.network.dns
  os_type    = "cloud-init"

  connection {
    host        = var.network.ip
    user        = "debian"
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
