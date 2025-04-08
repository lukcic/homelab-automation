resource "docker_image" "certbot" {
  name = "certbot/dns-cloudflare:v3.1.0"
}

resource "docker_container" "certbot" {
  name     = "${var.project_id}-${var.environment}-certbot"
  image    = docker_image.certbot.image_id
  restart  = "no"
  must_run = false
  command = [
    "certonly",
    "--non-interactive",
    "--agree-tos",
    "-m ${var.AUTHENTIK_BOOTSTRAP_EMAIL}",
    "-d auth.${var.domain}",
    "--dns-cloudflare",
    "--dns-cloudflare-credentials=/root/cloudflare.ini",
    "--keep-until-expiring"
  ]
  network_mode = "bridge"

  networks_advanced {
    name = docker_network.authentik.name
  }

  volumes {
    volume_name    = docker_volume.authentik-certs.name
    container_path = "/etc/letsencrypt"
  }

  volumes {
    volume_name    = "/root/cloudflare.ini"
    container_path = "/root/cloudflare.ini"
  }
}
