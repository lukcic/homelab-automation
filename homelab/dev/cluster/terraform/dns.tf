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
