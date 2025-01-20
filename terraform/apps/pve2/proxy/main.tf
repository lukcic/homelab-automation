#move it to the pve1 and add second nic in 33 network

locals {
  app-name = "proxy"
  ip       = "192.168.69.69"
}

module "pve-ct" {
  source = "git::ssh://git@github.com/lukcic/terraform-modules.git//proxmox/pve-ct?ref=main"

  container_id       = 6969
  target_node        = "pve2"
  hostname           = "${local.app-name}.lukcic.net"
  container_password = var.container_password

  ostemplate           = "local:vztmpl/debian-12-standard_12.2-1_amd64.tar.zst"
  ssh_public_keys      = "~/.ssh/proxmox-lxc-root.pub"
  ssh_conn_private_key = "~/.ssh/proxmox-lxc-root.pem"

  hardware = {
    memory  = 512
    balloon = 512
    swap    = 0
  }

  rootfs = {
    storage = "local-lvm"
    size    = "10G"
  }

  settings = {
    protection = false
  }

  network = [
    {
      ip     = local.ip
      dns    = "192.168.254.53"
      gw     = "192.168.69.254"
      bridge = "vmbr1"
      tag    = "69"
    }
  ]

  local_provisioner = {
    working_dir = "${var.project_root}/ansible/sites/${local.app-name}.lukcic.net"
    environment = {
      ANSIBLE_INVENTORY  = "${var.project_root}/ansible/sites/${local.app-name}.lukcic.net/inventory-${local.app-name}"
      ANSIBLE_CONFIG     = "${var.project_root}/ansible/ansible.cfg"
      ANSIBLE_ROLES_PATH = "${var.project_root}/ansible/roles"
    }
    command = "ansible-playbook -v main.yml"
  }

  depends_on = [local_file.ansible_inventory]
}

resource "local_file" "ansible_inventory" {
  content = <<EOF
lxc_root ansible_host=${local.ip} ansible_user=root ansible_private_key_file=~/.ssh/proxmox-lxc-root.pem
lxc_ansible ansible_host=${local.ip} ansible_user=ansible ansible_private_key_file=~/.ssh/ansible-key-ecdsa.pem
  EOF

  filename = "${var.project_root}/ansible/sites/${local.app-name}.lukcic.net/inventory-${local.app-name}"
}

resource "dns_a_record_set" "proxy" {
  zone = "lukcic.net."
  name = "proxy"
  addresses = [
    local.ip
  ]
  ttl = 86400

  depends_on = [module.pve-ct]
}

# resource "dns_ptr_record" "proxy" {
#   zone = "254.168.192.in-addr.arpa."
#   name = "70"
#   ptr  = "proxy.lukcic.net."
#   ttl  = 604800

#   depends_on = [module.pve-ct]
#}
