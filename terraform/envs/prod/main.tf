module "stack" {
  source = "../../modules/novabank_stack"

  project  = "novabank"
  env      = "prod"
  location = "westeurope"

    log_analytics_retention_days = 365

  tags = {
    Environment = "prod"
    Workload    = "novabank"
    ManagedBy   = "Terraform"
    Owner       = "Vlad"
  }
}
