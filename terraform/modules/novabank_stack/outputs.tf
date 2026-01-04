
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

