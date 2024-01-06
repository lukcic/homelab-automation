variable "hostname" {
  type = string
}

variable "hardware" {
  type = object({
    sockets = optional(number, 1)
    cores   = optional(number, 2)
    memory  = optional(number, 2048)
    balloon = optional(number, 1024)
  })
  default = {}
}

variable "target_node" {
  default = "pve2"
}

variable "vmid" {
  type = string
}

variable "network" {
  type = object({
    model  = optional(string, "virtio")
    bridge = optional(string, "vmbr254")
    dns    = optional(string, "192.168.254.20")
    ip     = optional(string)
    gw     = optional(string)
    tag    = optional(string)
  })
}

variable "settings" {
  type = object({
    onboot     = optional(bool, true)
    protection = optional(bool, true)
  })
  default = {}
}

variable "rootfs" {
  type = object({
    bootdisk = string
    type     = string
    storage  = string
    size     = string

  })
  default = {
    bootdisk = "scsi0"
    type     = "scsi"
    storage  = "local-zfs"
    size     = "32G"
  }
}

variable "ssh_conn_private_key" {
  type = string
}

variable "remote_provisioner_commands" {
  type    = list(string)
  default = ["sleep 30"]
}

variable "local_provisioner" {
  type = object({
    working_dir = optional(string),
    command     = optional(string),
    environment = optional(any)
  })
  default = {}
}
