locals {
  app-name = "tubearchivist"
  ip       = "192.168.254.90"
}

module "pve-ct" {
  source = "../../../modules/pve-vm"

  hostname = local.app-name
  vmid     = 25490

  hardware = {
    memory  = 4096
    balloon = 2048
  }


  ssh_conn_private_key = "~/.ssh/proxmox-lxc-root.pem"

  network = {
    ip  = local.ip
    gw  = "192.168.254.254"
    tag = "254"
  }

  local_provisioner = {
    working_dir = "${var.project_root}/ansible/sites/${local.app-name}.lukcic.net"
    environment = {
      ANSIBLE_INVENTORY  = "${var.project_root}/ansible/sites/${local.app-name}.lukcic.net/inventory-${local.app-name}"
      ANSIBLE_CONFIG     = "${var.project_root}/ansible/ansible.cfg"
      ANSIBLE_ROLES_PATH = "${var.project_root}/ansible/roles"
    }
    command = "ansible-playbook main.yml"
  }

  depends_on = [local_file.ansible_inventory]
}

resource "local_file" "ansible_inventory" {
  content = <<EOF
lxc_root ansible_host=${local.ip} ansible_user=debian ansible_private_key_file=~/.ssh/proxmox-lxc-root.pem
lxc_ansible ansible_host=${local.ip} ansible_user=ansible ansible_private_key_file=~/.ssh/ansible-key-ecdsa.pem
  EOF

  filename = "${var.project_root}/ansible/sites/${local.app-name}.lukcic.net/inventory-${local.app-name}"
}
