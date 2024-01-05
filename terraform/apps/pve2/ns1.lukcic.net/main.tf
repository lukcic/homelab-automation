module "pve-ct" {
  source = "../../../modules/pve-ct"

  hostname             = "ns1.lukcic.net"
  ostemplate           = "local:vztmpl/debian-12-standard_12.2-1_amd64.tar.zst"
  container_id         = "25453"
  ssh_public_keys      = "~/.ssh/proxmox-lxc-root.pub"
  ssh_conn_private_key = "~/.ssh/proxmox-lxc-root.pem"
  container_password   = var.container_password

  settings = {
    protection = false
  }

  network = {
    ip  = "192.168.254.53"
    gw  = "192.168.254.254"
    dns = "1.1.1.1"
    tag = "254"
  }
  local_provisioner = {
    working_dir = "${path.root}/../../../../ansible/sites/ns1.lukcic.net"
    command     = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory main.yml"
  }
  depends_on = [local_file.ansible_inventory]
}
#ANSIBLE_FORCE_COLOR=1 

resource "local_file" "ansible_inventory" {
  content = <<EOF
lxc_root ansible_host=192.168.254.53 ansible_user=root ansible_private_key_file=~/.ssh/proxmox-lxc-root.pem
lxc_ansible ansible_host=192.168.254.53 ansible_user=ansible ansible_private_key_file=~/.ssh/ansible-key-ecdsa.pem
  EOF

  filename = "${path.root}/../../../../ansible/sites/ns1.lukcic.net/inventory"
}

