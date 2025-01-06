locals {
  vm_name      = "${var.node_name}-${var.environment}.${var.domain}"
  pve_node     = "pve10"
  storage_pool = "local"
}

resource "proxmox_cloud_init_disk" "ci" {
  name     = "cloudinitdisk"
  pve_node = local.pve_node
  storage  = local.storage_pool

  meta_data = yamlencode({
    instance_id    = sha1(local.vm_name)
    local-hostname = local.vm_name
  })

  user_data = <<-EOT
  #cloud-config
  package_update: true
  package_upgrade: true
  packages:
    - htop
    - acl
    - pip
    - git
    - vim
    - curl
    - gnupg2
    - software-properties-common
    - apt-transport-https
    - ca-certificates
  users:
    - name: ${var.user_name}
      gecos: ${var.user_name}
      primary_group: ${var.user_name}
      groups: users,admin,wheel
      sudo: ALL=(ALL) NOPASSWD:ALL
      lock_passwd: false
      shell: /bin/bash
      plain_text_passwd: ${var.user_password}
      ssh_authorized_keys:
        - ${var.user_public_key}
    - name: ansible
      gecos: Ansible User
      groups: users,admin,wheel
      sudo: ALL=(ALL) NOPASSWD:ALL
      shell: /bin/bash
      lock_passwd: true
      ssh_authorized_keys:
        - ${var.ansible_public_key}
  EOT

  network_config = yamlencode({
    version = 1
    config = [{
      type = "physical"
      name = "ens18"
      subnets = [{
        type    = "static"
        address = "${var.master_ip}/24"
        gateway = "192.168.254.254"
        dns_nameservers = [
          "192.168.254.53",
          "1.1.1.1"
        ]
      }]
    }]
  })
}

resource "proxmox_vm_qemu" "master_node" {
  name        = local.vm_name
  target_node = local.pve_node
  clone       = "debian12-cloud"
  full_clone  = true
  agent       = 0

  os_type  = "cloud-init"
  cores    = 2
  sockets  = 1
  vcpus    = 0
  cpu_type = "host"
  memory   = 2048
  scsihw   = "lsi"

  disks {
    ide {
      ide2 {
        cdrom {
          iso = proxmox_cloud_init_disk.ci.id
        }
      }
    }
    scsi {
      scsi0 {
        disk {
          size    = 12
          storage = "local"
        }
      }
    }
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr254"
  }

  serial {
    id = 0
  }

  connection {
    host        = var.master_ip
    user        = "ansible"
    private_key = file(var.ansible_private_key_path)
    agent       = false
    timeout     = "5m"
  }

  provisioner "remote-exec" {
    inline = ["sleep 30"]
  }
}

resource "ansible_host" "master_host" {
  name       = "${var.node_name}-${var.environment}.${var.domain}"
  groups     = ["master"]
  depends_on = [proxmox_vm_qemu.master_node]
  variables = {
    host_type = "vm"
  }
}

resource "terraform_data" "install_roles" {
  provisioner "local-exec" {
    command     = "ansible-galaxy install -r requirements.yml -p roles/"
    working_dir = "../ansible"
  }
}
resource "ansible_playbook" "playbook" {
  depends_on = [ansible_host.master_host, terraform_data.install_roles]

  playbook   = "../ansible/main.yml"
  name       = "${var.node_name}-${var.environment}.${var.domain}"
  replayable = false
  verbosity  = 0
  groups     = ["master"]

  extra_vars = {
    host_type = "vm"
    # ansible_host             = "${var.node_name}-${var.environment}.${var.domain}"
    ansible_user             = "ansible"
    ansible_private_key_file = "~/.ssh/ansible-key-ecdsa.pem"
    ansible_ssh_common_args  = "-F /dev/null -o StrictHostKeyChecking=no"
    ansible_config_file      = "${var.project_root}/homelab/dev/cluster/ansible/ansible.cfg"
    ansible_roles_path       = "${var.project_root}/homelab/dev/cluster/ansible/roles"
  }
}

output "ansible_std_out" {
  value = ansible_playbook.playbook.ansible_playbook_stdout
}

output "ansible_std_err" {
  value = ansible_playbook.playbook.ansible_playbook_stderr
}
