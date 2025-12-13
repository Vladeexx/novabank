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
