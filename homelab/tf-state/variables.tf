variable "apps" {
  type        = list(string)
  description = "List of virtual machine/container names used for DynamoDB tables creation (terraform lock)"
}