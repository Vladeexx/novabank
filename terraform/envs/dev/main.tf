module "stack" {
  source = "../../modules/novabank_stack"

  project  = "novabank"
  env      = "dev"
  location = "West Europe"
}
