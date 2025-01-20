locals {
  app-name = "fileserver"
  ip       = "192.168.254.200"
  ip2      = "192.168.33.200"
}

module "pve-ct" {
  source = "git::ssh://git@github.com/lukcic/terraform-modules.git//proxmox/pve-ct?ref=main"

  container_id       = 33200
  hostname           = local.app-name
  container_password = var.container_password

  ostemplate           = "local:vztmpl/debian-12-standard_12.7-1_amd64.tar.zst"
  ssh_public_keys      = "~/.ssh/proxmox-lxc-root.pub"
  ssh_conn_private_key = "~/.ssh/proxmox-lxc-root.pem"

  settings = {
    unprivileged = false
    protection   = false
    nesting      = true
    mount        = "nfs;cifs"
  }

  network = [{
    ip     = local.ip
    gw     = "192.168.254.254"
    dns    = "192.168.254.20"
    tag    = "254"
    bridge = "vmbr0"
    },
    {
      ip     = local.ip2
      name   = "eth1"
      tag    = "33"
      bridge = "vmbr1"
  }]

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
lxc_root ansible_host=${local.ip} ansible_user=root ansible_private_key_file=~/.ssh/proxmox-lxc-root.pem
lxc_ansible ansible_host=${local.ip} ansible_user=ansible ansible_private_key_file=~/.ssh/ansible-key-ecdsa.pem
  EOF

  filename = "${var.project_root}/ansible/sites/${local.app-name}/inventory-${local.app-name}"
}
