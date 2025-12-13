param location string = resourceGroup().location
param env string
param appName string

var tags = {
  project: 'novabank'
  environment: env
  owner: 'cloudnation-assessment'
}

resource law 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: 'law-${appName}-${env}'
  location: location
  tags: tags
  properties: {
    retentionInDays: 365
    sku: { name: 'PerGB2018' }
  }
}

output logAnalyticsWorkspaceName string = law.name
output logAnalyticsWorkspaceId string = law.id

// App Insights connected to the Log Analytics workspace ---------------------------

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

output appInsightsName string = appi.name
output appInsightsConnectionString string = appi.properties.ConnectionString

