  ///////////////////////////////////////// #### RG module

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

  //////////////////////////////////////// ####  Log Analytic module ###

  module "law" {
    source  = "CloudNationHQ/law/azure"
    version = "3.2.0"

    tags = var.tags

    workspace = {
      name                = "law-${var.project}-${var.env}"
      location            = var.location
      resource_group_name = "rg-${var.project}-${var.env}"
      retention           = var.log_analytics_retention_days
    }
  }


  //////////////////////////////////////// ###   Application Insights

  module "appi" {
    source  = "CloudNationHQ/appi/azure"
    version = "3.0.1"

    config = {
      name                = "appi-${var.project}-${var.env}"
      location            = var.location
      resource_group_name = "rg-${var.project}-${var.env}"

      application_type = "web"

      # workspace-based mode:
      workspace_id = module.law.workspace.id

      tags = var.tags
    }
  }

  /////////////////////////////////////// ## Key Vault

  data "azurerm_client_config" "current" {}

  module "kv" {
    source  = "CloudNationHQ/kv/azure"
    version = "4.3.0"

    vault = {
      name                = "kv-${var.project}-${var.env}-01"
      location            = var.location
      resource_group_name = "rg-${var.project}-${var.env}"
      tenant_id           = data.azurerm_client_config.current.tenant_id

      rbac_authorization_enabled = true

      admins = [
        data.azurerm_client_config.current.object_id
      ]

      tags = var.tags
    }
  }

  ///////////////////////////////////////////// App Service Plan

  module "plan" {
    source  = "CloudNationHQ/plan/azure"
    version = "3.0.0"

    plans = {
      app = {
        name                = "plan-${var.project}-${var.env}"
        os_type             = "Linux"
        sku_name            = "B1"
        resource_group_name = "rg-${var.project}-${var.env}"
        location            = var.location
        tags                = var.tags
      }
    }
  }


  ///////////////////////////////////////////// App Service


module "app" {
  source  = "CloudNationHQ/app/azure"
  version = "5.0.0"

  instance = {
    name                = "app-${var.project}-${var.env}"
    type                = "linux"
    location            = var.location
    resource_group_name = "rg-${var.project}-${var.env}"

    service_plan_id = module.plan.plans.app.id

    identity = {
      type = "SystemAssigned"
    }

    app_settings = {
      # Application Insights
      "APPLICATIONINSIGHTS_CONNECTION_STRING" = module.appi.config.connection_string

      # Database configuration via Key Vault (resolved at runtime)
      "DB_HOST"     = "@Microsoft.KeyVault(SecretUri=https://kv-${var.project}-${var.env}-01.vault.azure.net/secrets/db-host/)"
      "DB_NAME"     = "@Microsoft.KeyVault(SecretUri=https://kv-${var.project}-${var.env}-01.vault.azure.net/secrets/db-name/)"
      "DB_USER"     = "@Microsoft.KeyVault(SecretUri=https://kv-${var.project}-${var.env}-01.vault.azure.net/secrets/db-user/)"
      "DB_PASSWORD" = "@Microsoft.KeyVault(SecretUri=https://kv-${var.project}-${var.env}-01.vault.azure.net/secrets/db-password/)"
    }

    site_config = {
      always_on           = true
      ftps_state          = "Disabled"
      minimum_tls_version = "1.2"

      application_stack = {
        node_version = "20-lts"
      }
    }

    tags = var.tags
  }
}



  ///////////////////////////////////////////// Data block


  data "azurerm_key_vault" "kv" {
    name                = "kv-${var.project}-${var.env}-01"
    resource_group_name = "rg-${var.project}-${var.env}"
    depends_on          = [module.kv]
  }

  data "azurerm_linux_web_app" "app" {
    name                = "app-${var.project}-${var.env}"
    resource_group_name = "rg-${var.project}-${var.env}"
    depends_on          = [module.app]
  }


  /////////////////////////////////////////////  RBAC


  resource "azurerm_role_assignment" "app_to_kv_secrets_user" {
    scope              = data.azurerm_key_vault.kv.id
    role_definition_id = "/subscriptions/4f8cfe93-e6dd-4f13-a6bd-311131073c9a/providers/Microsoft.Authorization/roleDefinitions/4633458b-17de-408a-b874-0445c86b69e6"
    principal_id       = data.azurerm_linux_web_app.app.identity[0].principal_id
  }


//////////////////////////////////////////// Postgresql Flexible Server

module "psql" {
  source  = "CloudNationHQ/psql/azure"
  version = "4.1.0"

  instance = {
    name                = "psql-${var.project}-${var.env}"
    resource_group_name = "rg-${var.project}-${var.env}"
    location            = var.location

    version  = 16
    sku_name = "B_Standard_B1ms"

    storage_mb                    = 32768
    public_network_access_enabled = true
    backup_retention_days         = 7
    geo_redundant_backup_enabled  = false
    auto_grow_enabled             = false
    backup_retention_days         = 7

    administrator_login    = var.psql_admin_login
    administrator_password = var.psql_admin_password

    authentication = {
      password_auth_enabled         = true
      active_directory_auth_enabled = false
    }

    databases = {
      app = { name = "novabank" }
    }

    tags = var.tags
  }
}

# Lookup the created server to attach firewall rules (module output doesn't expose id)
data "azurerm_postgresql_flexible_server" "psql" {
  name                = "psql-${var.project}-${var.env}"
  resource_group_name = "rg-${var.project}-${var.env}"
  depends_on          = [module.psql]
}

//////////////////////////////////////////// Firewall (PoC simple)

# Allow Azure services/platform traffic (broad, acceptable for PoC; tighten in Phase-2)
resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_azure_services" {
  name      = "allow-azure-services"
  server_id = data.azurerm_postgresql_flexible_server.psql.id

  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}







  









