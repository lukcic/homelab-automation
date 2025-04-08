resource "docker_network" "authentik" {
  name   = "${var.project_id}-${var.environment}-authentik"
  driver = "bridge"
}
