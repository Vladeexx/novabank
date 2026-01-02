module "rg" {
  source  = "CloudNationHQ/rg/azure"
  version = "2.7.0"

  groups = {
    core = {
      name     = "rg-${var.project}-${var.env}"
      location = var.location
      tags     = var.tags
    }
  }
}
