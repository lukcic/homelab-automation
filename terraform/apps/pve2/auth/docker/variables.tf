variable "environment" {
  description = "Deployment Environment"
}

variable "project_id" {
  description = "Name of the project"
}

variable "domain" {
  description = "App public address"
}

variable "POSTGRES_DATABASE" {
  type      = string
  sensitive = false
}

variable "POSTGRES_USER" {
  type      = string
  sensitive = false
}

variable "POSTGRES_PASSWORD" {
  type      = string
  sensitive = true
}

variable "AUTHENTIK_SECRET_KEY" {
  type      = string
  sensitive = true
}

variable "AUTHENTIK_BOOTSTRAP_EMAIL" {
  type      = string
  sensitive = true
}

variable "AUTHENTIK_BOOTSTRAP_PASSWORD" {
  type      = string
  sensitive = true
}
