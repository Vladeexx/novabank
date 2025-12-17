@description('PostgreSQL Flexible Server (PoC) - minimal, cost-aware, with simple firewall rule for Azure services.')
param name string
param location string
param tags object

@description('PostgreSQL admin username.')
param adminUser string

@secure()
@description('PostgreSQL admin password. Passed securely at deployment time (e.g. from Key Vault via CLI/CI).')
param adminPassword string

@description('Compute SKU (small/cheap for PoC).')
param skuName string = 'Standard_B1ms'

@description('Storage in GB.')
param storageGb int = 32

@description('Backup retention in days (PoC).')
param backupRetentionDays int = 7

@description('PostgreSQL major version.')
param version string = '14'

resource pg 'Microsoft.DBforPostgreSQL/flexibleServers@2023-03-01-preview' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: skuName
    tier: 'Burstable'
  }
  properties: {
    administratorLogin: adminUser
    administratorLoginPassword: adminPassword
    version: version

    storage: {
      storageSizeGB: storageGb
    }

    backup: {
      backupRetentionDays: backupRetentionDays
    }

    // Keep it simple for PoC (no HA yet)
    highAvailability: {
      mode: 'Disabled'
    }
  }
}

// Allow Azure services (App Service etc.) to connect (PoC). Tighten later.
resource allowAzure 'Microsoft.DBforPostgreSQL/flexibleServers/firewallRules@2023-03-01-preview' = {
  parent: pg
  name: 'AllowAzureServices'
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}

output fqdn string = pg.properties.fullyQualifiedDomainName
output serverName string = pg.name
