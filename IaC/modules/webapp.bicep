@description('App Service Plan + Web App (Linux) for the NovaBank PoC.')
param name string
param location string
param tags object


@description('App Service Plan name')
param planName string

@description('SKU name, e.g. B1 (cheap) or F1 (free if available in region/subscription).')
param skuName string = 'B1'

@description('Application Insights connection string')
param appInsightsConnectionString string

@description('Postgres host/FQDN (e.g. pg-xxx.postgres.database.azure.com)')
param pgHost string

@description('Postgres database name')
param pgDbName string = 'postgres'

@description('Postgres username')
param pgUser string

@secure()
@description('Postgres password injected at deployment time (same value used to create server).')
param pgPassword string

resource plan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: planName
  location: location
  tags: tags
  sku: {
    name: skuName
    tier: 'Basic'
  }
  properties: {
    reserved: true // Linux
  }
}

resource web 'Microsoft.Web/sites@2022-09-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    serverFarmId: plan.id
    httpsOnly: true
    siteConfig: {
      linuxFxVersion: 'NODE|18-lts'
      appSettings: [
        // Observability
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: appInsightsConnectionString
        }
        {
          name: 'ApplicationInsightsAgent_EXTENSION_VERSION'
          value: '~3'
        }

        // Basic app placeholder setting
        {
          name: 'ENV'
          value: tags.environment
        }

        // DB settings (pattern demonstration)
        {
          name: 'DB_HOST'
          value: pgHost
        }
        {
          name: 'DB_NAME'
          value: pgDbName
        }
        {
          name: 'DB_USER'
          value: pgUser
        }
        {
          name: 'DB_PASSWORD'
          value: pgPassword
        }
        {
          name: 'DB_SSLMODE'
          value: 'require'
        }
      ]
    }
  }
}


output defaultHostName string = web.properties.defaultHostName
