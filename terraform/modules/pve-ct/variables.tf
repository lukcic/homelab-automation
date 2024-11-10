variable "hostname" {
  type = string
}

variable "hardware" {
  type = object({
    cores  = optional(number, 2)
    memory = optional(number, 1024)
    swap   = optional(number, 1024)
  })
  default = {}
}

variable "target_node" {
  default = "pve2"
}

variable "ostemplate" {
  default = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
}

variable "container_password" {
  type      = string
  sensitive = true
}

variable "container_id" {
  type = string
}

variable "network" {
  type = list(object({
    name   = optional(string, "eth0")
    bridge = optional(string, "vmbr254")
    ip     = optional(string, "dhcp")
    gw     = optional(string)
    tag    = optional(string)
    dns    = optional(string)
  }))
}

variable "mountpoint" {
  type = list(object({
    storage = string
    volume  = string
    mp      = string
    size    = string
  }))
  default = []
}

variable "settings" {
  type = object({
    onboot       = optional(bool, true)
    unprivileged = optional(bool, true)
    start        = optional(bool, true)
    protection   = optional(bool, true)
    nesting      = optional(bool, true)
    mount        = optional(string, "")
  })
  default = {}
}

variable "ssh_public_keys" {
  type = string
}

variable "rootfs" {
  type = object({
    storage = string
    size    = string

  })
  default = {
    storage = "local-zfs"
    size    = "10G"
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
