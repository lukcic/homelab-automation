module "pve-ct" {
  for_each = { for obj in var.k8s_nodes : obj.name => obj }
  source   = "git::ssh://git@github.com/lukcic/terraform-modules.git//proxmox/pve-ct?ref=main"

  container_id         = each.value.container_id
  hostname             = each.value.name
  target_node          = each.value.pve_node
  container_password   = var.container_password
  ostemplate           = "/var/lib/vz/template/cache/debian-12-standard_12.7-1_amd64.tar.zst"
  ssh_public_keys      = "~/.ssh/proxmox-lxc-root.pub"
  ssh_conn_private_key = "~/.ssh/proxmox-lxc-root.pem"

  settings = {
    onboot       = false
    start        = false
    protection   = false
    unprivileged = false
    nesting      = true
  }

  hardware = {
    cores  = 2
    memory = 2048
    swap   = 0
  }

  rootfs = {
    storage = "local"
    size    = "10G"
  }

  network = [{
    ip     = each.value.ip
    gw     = "192.168.254.254"
    dns    = "192.168.254.53"
    bridge = "vmbr254"
  }]

  local_provisioner = {
    working_dir = "${var.project_root}/homelab/dev/cluster/ansible"
    environment = {
      ANSIBLE_INVENTORY  = "${var.project_root}/homelab/dev/cluster/ansible/inventory"
      ANSIBLE_CONFIG     = "${var.project_root}/homelab/dev/cluster/ansible/ansible.cfg"
      ANSIBLE_ROLES_PATH = "${var.project_root}/homelab/dev/cluster/ansible/roles"
    }
    command = "sleep 5" #"ansible-playbook -v main.yml"
  }

  #   depends_on = [local_file.ansible_inventory]
}

locals {
  k8s_nodes_list = join("\n", [for node in var.k8s_nodes : "${node.name}-${var.environment}.${var.domain} ansible_user=ansible ansible_private_key_file=~/.ssh/ansible-key-ecdsa.pem"])
}

resource "local_file" "ansible_inventory" {
  filename = "${var.project_root}/homelab/dev/cluster/ansible/inventory"
  content  = <<EOF
[nodes]
${local.k8s_nodes_list}
  EOF
}
