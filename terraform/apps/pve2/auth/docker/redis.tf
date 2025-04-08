resource "docker_image" "redis" {
  name = "docker.io/library/redis:7.4.1-alpine"
}

resource "docker_volume" "redis" {
  name = "${var.project_id}-${var.environment}-redis"
}

resource "docker_container" "redis" {
  name         = "${var.project_id}-${var.environment}-redis"
  image        = docker_image.redis.image_id
  restart      = "unless-stopped"
  command      = ["--save 60 1", "--loglevel warning"]
  network_mode = "bridge"

  networks_advanced {
    name = docker_network.authentik.name
  }

  volumes {
    volume_name    = docker_volume.redis.name
    container_path = "/data"
  }

  healthcheck {
    test         = ["CMD-SHELL", "redis-cli ping | grep PONG"]
    start_period = "20s"
    interval     = "30s"
    retries      = 5
    timeout      = "3s"
  }
}
