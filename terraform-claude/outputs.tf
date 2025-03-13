output "resource_group_id" {
  description = "ID of the created resource group"
  value       = azurerm_resource_group.rg.id
}

output "container_app_environment_id" {
  description = "ID of the Container App Environment"
  value       = azurerm_container_app_environment.environment.id
}

output "postgres_server_id" {
  description = "ID of the PostgreSQL server"
  value       = azurerm_postgresql_flexible_server.postgres.id
}

output "postgres_connection_string" {
  description = "PostgreSQL connection string"
  value       = "postgresql://${var.postgres_admin_username}@${azurerm_postgresql_flexible_server.postgres.name}.postgres.database.azure.com:5432/${var.app_name}-db"
  sensitive   = true
}

# Output the URLs for the deployed applications
output "backend_url" {
  value = "https://${azurerm_container_app.backend.ingress[0].fqdn}"
}

output "frontend_url" {
  value = "https://${azurerm_container_app.frontend.ingress[0].fqdn}"
}

output "postgres_server_fqdn" {
  value = azurerm_postgresql_flexible_server.postgres.fqdn
}
