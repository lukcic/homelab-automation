resource "docker_image" "postgres" {
  name = "docker.io/library/postgres:16-alpine3.21"
}

resource "docker_volume" "postgres" {
  name = "${var.project_id}-${var.environment}-postgres"
}

resource "docker_container" "postgres" {
  name         = "${var.project_id}-${var.environment}-postgres"
  image        = docker_image.postgres.image_id
  restart      = "unless-stopped"
  network_mode = "bridge"

  networks_advanced {
    name = docker_network.authentik.name
  }

  volumes {
    volume_name    = docker_volume.postgres.name
    container_path = "/var/lib/postgresql/data"
  }

  env = [
    "POSTGRES_DB=${var.POSTGRES_DATABASE}",
    "POSTGRES_USER=${var.POSTGRES_USER}",
    "POSTGRES_PASSWORD=${var.POSTGRES_PASSWORD}"
  ]

  healthcheck {
    test         = ["CMD-SHELL", "pg_isready -d ${var.POSTGRES_DATABASE} -U ${var.POSTGRES_USER}"]
    start_period = "20s"
    interval     = "30s"
    retries      = 5
    timeout      = "5s"
  }
}
