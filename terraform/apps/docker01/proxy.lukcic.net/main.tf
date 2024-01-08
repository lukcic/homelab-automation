resource "docker_image" "nginx-proxy-manager" {
  name = "jc21/nginx-proxy-manager:2.10.3"
}

resource "docker_image" "maria-db" {
  name = "jc21/mariadb-aria:10.4.15"
}

resource "docker_volume" "nginxproxymanager-data" {
  name = "nginxproxymanager-data"
}

resource "docker_volume" "nginxproxymanager-ssl" {
  name = "nginxproxymanager-ssl"
}

resource "docker_volume" "nginxproxymanager-db" {
  name = "nginxproxymanager-db"
}


resource "docker_container" "nginx-proxy-manager" {

  name  = "nginx-proxy-manager"
  image = docker_image.nginx-proxy-manager.image_id

  ports {
    internal = 80
    external = 80
  }

  ports {
    internal = 81
    external = 81
  }

  ports {
    internal = 443
    external = 443
  }

  env = [
    "DB_MYSQL_HOST=maria-db",
    "DB_MYSQL_PORT=3306",
    "DB_MYSQL_USER=npm",
    "DB_MYSQL_PASSWORD=npm",
    "DB_MYSQL_NAME=npm"
  ]

  volumes {
    container_path = "/data"
    volume_name    = docker_volume.nginxproxymanager-data.name
  }

  volumes {
    container_path = "/etc/letsencrypt"
    volume_name    = docker_volume.nginxproxymanager-ssl.name
  }

  restart = "unless-stopped"
  networks_advanced { name = docker_network.nginx-proxy.id }

  depends_on = [
    docker_container.maria-db
  ]
}

resource "docker_container" "maria-db" {
  name    = "maria-db"
  image   = docker_image.maria-db.image_id
  restart = "unless-stopped"

  env = [
    "MYSQL_ROOT_PASSWORD=npm",
    "MYSQL_DATABASE=npm",
    "MYSQL_USER=npm",
    "MYSQL_PASSWORD=npm"
  ]

  volumes {
    container_path = "/var/lib/mysql"
    volume_name    = docker_volume.nginxproxymanager-db.name
  }

  networks_advanced {
    name = docker_network.nginx-proxy.id
  }
}

resource "docker_network" "nginx-proxy" {
  name = "nginx_proxy_network"
}
