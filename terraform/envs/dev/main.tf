module "stack" {
  source = "../../modules/novabank_stack"

  project  = "novabank"
  env      = "dev"
  location = "westeurope"
  
  log_analytics_retention_days = 30

  tags = {
    Environment = "dev"
    Workload    = "novabank"
    ManagedBy   = "Terraform"
    Owner       = "Vlad"
  }
}
