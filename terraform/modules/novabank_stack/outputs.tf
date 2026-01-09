
output "resource_group_name" {
  value = "rg-${var.project}-${var.env}"
}
output "log_analytics_workspace_id" {
  value = module.law.workspace.id
}

output "log_analytics_workspace_name" {
  value = module.law.workspace.name
}

output "application_insights_id" {
  value = module.appi.config.id
}

output "application_insights_connection_string" {
  value     = module.appi.config.connection_string
  sensitive = true
}

output "app_service_plan_id" {
  value = module.plan.plans.app.id
}

output "key_vault_id" {
  value = data.azurerm_key_vault.kv.id
}

output "app_identity_principal_id" {
  value = data.azurerm_linux_web_app.app.identity[0].principal_id
}

output "app_service_id" {
  value = data.azurerm_linux_web_app.app.id
}

output "psql_fqdn" {
  description = "PostgreSQL server FQDN"
  value       = module.psql.server.fqdn
}




