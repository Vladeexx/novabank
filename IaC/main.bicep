param location string = resourceGroup().location
param env string
param appName string
param kvSku string = 'standard'

// Postgres settings
param pgAdminUser string = 'pgadmin'

@secure()
@description('Postgres admin password injected at deployment time (e.g. fetched from Key Vault in CLI/CI).')
param pgAdminPassword string=''

var tags = {
  project: 'novabank'
  environment: env
  owner: 'cloudnation-assessment'
}

// ---------------------------
// Log Analytics (central store)
// ---------------------------
resource law 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: 'law-${appName}-${env}'
  location: location
  tags: tags
  properties: {
    retentionInDays: 365
    sku: { name: 'PerGB2018' }
  }
}

// ---------------------------
// App Insights (workspace-based)
// ---------------------------
resource appi 'Microsoft.Insights/components@2020-02-02' = {
  name: 'appi-${appName}-${env}'
  location: location
  kind: 'web'
  tags: tags
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: law.id
  }
}

// ---------------------------
// Key Vault (RBAC)
// ---------------------------
resource kv 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: 'kv-${appName}-${env}'
  location: location
  tags: tags
  properties: {
    tenantId: subscription().tenantId
    sku: {
      name: kvSku
      family: 'A'
    }
    enableRbacAuthorization: true
    enableSoftDelete: true
    softDeleteRetentionInDays: 90
    enablePurgeProtection: true

    // PoC choice: allow public access for now (lock down later)
    publicNetworkAccess: 'Enabled'
  }
}

// ---------------------------
// PostgreSQL Flexible Server
// ---------------------------
module postgres 'modules/postgres.bicep' = {
  name: 'postgres'
  params: {
    name: 'pg-${appName}-${env}'
    location: location
    tags: tags
    adminUser: pgAdminUser
    adminPassword: pgAdminPassword
  }
}

// ---------------------------
// Outputs
// ---------------------------
output logAnalyticsWorkspaceName string = law.name
output logAnalyticsWorkspaceId string = law.id

output appInsightsName string = appi.name
output appInsightsConnectionString string = appi.properties.ConnectionString

output keyVaultName string = kv.name
output keyVaultUri string = kv.properties.vaultUri

output postgresServerName string = postgres.outputs.serverName
output postgresFqdn string = postgres.outputs.fqdn
