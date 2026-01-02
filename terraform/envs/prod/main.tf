module "stack" {
  source = "../../modules/novabank_stack"

  project  = "novabank"
  env      = "prod"
  location = "westeurope"
}
