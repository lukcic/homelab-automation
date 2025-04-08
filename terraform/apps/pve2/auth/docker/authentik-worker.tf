resource "docker_volume" "authentik-worker-media" {
  name = "${var.project_id}-${var.environment}-worker-media"
}

resource "docker_volume" "authentik-worker-templates" {
  name = "${var.project_id}-${var.environment}-worker-templates"
}

resource "docker_volume" "authentik-certs" {
  name = "${var.project_id}-${var.environment}-certs"
}

resource "docker_container" "authentik-worker" {
  name    = "${var.project_id}-${var.environment}-worker"
  image   = docker_image.authentik.image_id
  restart = "unless-stopped"
  command = ["worker"]
  user    = "root"

  network_mode = "bridge"

  networks_advanced {
    name = docker_network.authentik.name
  }

  volumes {
    volume_name    = docker_volume.authentik-worker-media.name
    container_path = "/media"
  }

  volumes {
    volume_name    = docker_volume.authentik-worker-templates.name
    container_path = "/templates"
  }

  volumes {
    volume_name    = docker_volume.authentik-certs.name
    container_path = "/certs"
  }

  env = [
    "AUTHENTIK_DISABLE_STARTUP_ANALYTICS=true",
    "AUTHENTIK_ERROR_REPORTING__ENABLED=false",
    "AUTHENTIK_SECRET_KEY=${var.AUTHENTIK_SECRET_KEY}",
    "AUTHENTIK_REDIS__HOST=${var.project_id}-${var.environment}-redis",
    "AUTHENTIK_POSTGRESQL__HOST=${var.project_id}-${var.environment}-postgres",
    "AUTHENTIK_POSTGRESQL__NAME=${var.POSTGRES_DATABASE}",
    "AUTHENTIK_POSTGRESQL__USER=${var.POSTGRES_USER}",
    "AUTHENTIK_POSTGRESQL__PASSWORD=${var.POSTGRES_PASSWORD}",
    "AUTHENTIK_BOOTSTRAP_EMAIL=${var.AUTHENTIK_BOOTSTRAP_EMAIL}",
    "AUTHENTIK_BOOTSTRAP_PASSWORD=${var.AUTHENTIK_BOOTSTRAP_PASSWORD}",
    "AUTHENTIK_LOG_LEVEL=warning"
  ]

  depends_on = [
    docker_container.authentik-server
  ]
}
