locals {
  app-name = "docker01"
  ip       = "192.168.254.80"
}

module "pve-ct" {
  source = "../../../modules/pve-ct"

  hostname             = "${local.app-name}.lukcic.net"
  ostemplate           = "local:vztmpl/debian-12-standard_12.2-1_amd64.tar.zst"
  container_id         = "25480"
  ssh_public_keys      = "~/.ssh/proxmox-lxc-root.pub"
  ssh_conn_private_key = "~/.ssh/proxmox-lxc-root.pem"
  container_password   = var.container_password

  settings = {
    protection = false
  }

  network = {
    ip  = local.ip
    gw  = "192.168.254.254"
    dns = "192.168.254.20"
    tag = "254"
  }

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
