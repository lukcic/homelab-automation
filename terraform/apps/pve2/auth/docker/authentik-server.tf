resource "docker_image" "authentik" {
  name         = "ghcr.io/goauthentik/server:2024.12.2"
  force_remove = true
}

resource "docker_volume" "authentik-server-media" {
  name = "${var.project_id}-${var.environment}-server-media"
}

resource "docker_volume" "authentik-server-templates" {
  name = "${var.project_id}-${var.environment}-server-templates"
}

resource "docker_container" "authentik-server" {
  name    = "${var.project_id}-${var.environment}-server"
  image   = docker_image.authentik.image_id
  restart = "unless-stopped"
  command = ["server"]

  network_mode = "bridge"
  networks_advanced {
    name = docker_network.authentik.name
  }

  volumes {
    volume_name    = docker_volume.authentik-server-media.name
    container_path = "/media"
  }

  volumes {
    volume_name    = docker_volume.authentik-server-templates.name
    container_path = "/templates"
  }

  ports {
    internal = "9000"
    external = "80"
  }

  ports {
    internal = "9443"
    external = "443"
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
    docker_container.postgres,
    docker_container.redis
  ]
}
