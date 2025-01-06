resource "dns_a_record_set" "k8s_master" {
  zone = "${var.domain}."
  name = "${var.node_name}-${var.environment}"
  addresses = [
    var.master_ip
  ]
  ttl = 300

  depends_on = [proxmox_vm_qemu.master_node]
}

resource "dns_ptr_record" "k8s_master" {
  zone = "${var.ptr_domain}.in-addr.arpa."
  name = "2"
  ptr  = "${var.node_name}-${var.environment}.${var.domain}."
  ttl  = 300

  depends_on = [proxmox_vm_qemu.master_node]
}

resource "dns_a_record_set" "k8s_node" {
  for_each = { for obj in var.k8s_nodes : obj.name => obj }

  zone = "${var.domain}."
  name = "${each.value.name}-${var.environment}"
  addresses = [
    each.value.ip
  ]
  ttl = 300
}

resource "dns_ptr_record" "k8s_node" {
  for_each = { for obj in var.k8s_nodes : obj.name => obj }

  zone = "${var.ptr_domain}.in-addr.arpa."
  name = split(".", each.value.ip)[3]
  ptr  = "${each.value.name}-${var.environment}.${var.domain}."
  ttl  = 300
}
