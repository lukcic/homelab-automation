environment = "dev"
node_name   = "k8s-master"
master_ip   = "192.168.254.2"
domain      = "lukcic.net"
ptr_domain  = "254.168.192"

k8s_nodes = [
  {
    name         = "k8s-node01"
    container_id = 25403,
    pve_node     = "pve10",
    ip           = "192.168.254.3"
  },
  {
    name         = "k8s-node02"
    container_id = 25404,
    pve_node     = "pve20",
    ip           = "192.168.254.4"
  },
  {
    name         = "k8s-node03"
    container_id = 25405,
    pve_node     = "pve30",
    ip           = "192.168.254.5"
  },
]
