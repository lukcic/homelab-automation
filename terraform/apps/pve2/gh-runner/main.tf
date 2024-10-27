#move it to the pve1 and add second nic in 33 network

locals {
  app-name = "gh-runner"
  ip       = "192.168.254.55"
}

module "pve-ct" {
  source = "../../../modules/pve-ct"

  container_id       = 25455
  target_node        = "pve2"
  hostname           = "${local.app-name}.lukcic.net"
  container_password = var.container_password

  ostemplate           = "local:vztmpl/debian-12-standard_12.2-1_amd64.tar.zst"
  ssh_public_keys      = "~/.ssh/proxmox-lxc-root.pub"
  ssh_conn_private_key = "~/.ssh/proxmox-lxc-root.pem"

  settings = {
    protection = false
  }

  network = [
    {
      ip     = local.ip
      dns    = "192.168.254.20"
      gw     = "192.168.254.254"
      tag    = "254"
      bridge = "vmbr0"
    }
  ]

  local_provisioner = {
    working_dir = "${var.project_root}/ansible/sites/${local.app-name}"
    environment = {
      ANSIBLE_INVENTORY  = "${var.project_root}/ansible/sites/${local.app-name}/inventory-${local.app-name}"
      ANSIBLE_CONFIG     = "${var.project_root}/ansible/ansible.cfg"
      ANSIBLE_ROLES_PATH = "${var.project_root}/ansible/roles"
    }
    command = "ansible-playbook -v main.yml"
  }

  depends_on = [local_file.ansible_inventory]
}

resource "local_file" "ansible_inventory" {
  content = <<EOF
lxc_root ansible_host=${local.ip} ansible_user=root ansible_private_key_file=~/.ssh/proxmox-lxc-root.pem ansible_ssh_common_args='-F /dev/null'
lxc_ansible ansible_host=${local.ip} ansible_user=ansible ansible_private_key_file=~/.ssh/ansible-key-ecdsa.pem ansible_ssh_common_args='-F /dev/null'
  EOF

  filename = "${var.project_root}/ansible/sites/${local.app-name}/inventory-${local.app-name}"
}

