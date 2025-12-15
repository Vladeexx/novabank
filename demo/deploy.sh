#!/usr/bin/env bash

# Exit immediately if:
# - a command fails (-e)
# - an undefined variable is used (-u)
# - a pipeline command fails (-o pipefail)
set -euo pipefail

# ------------------------------------------------------------
# Read the first argument passed to the script.
# Example:
#   ./deploy.sh dev
# ENV will be set to "dev"
# ------------------------------------------------------------
ENV="${1:-}"

# ------------------------------------------------------------
# Validate that ENV is either "dev" or "prod".
# If not, print usage instructions and exit.
# This prevents accidental deployments to the wrong environment.
# ------------------------------------------------------------
if [[ ! "$ENV" =~ ^(dev|prod)$ ]]; then
  echo "Usage: $0 dev|prod"
  exit 1
fi

# ------------------------------------------------------------
# Set Azure region.
# Default is "westeurope".
# Can be overridden like this:
#   LOCATION=northeurope ./deploy.sh dev
# ------------------------------------------------------------
LOCATION="${LOCATION:-westeurope}"

# ------------------------------------------------------------
# Build the Azure Resource Group name dynamically
# Examples:
#   rg-novabank-dev-weu
#   rg-novabank-prod-weu
# ------------------------------------------------------------
RG="rg-novabank-${ENV}-weu"

# ------------------------------------------------------------
# Name of the Azure deployment record.
# This is NOT a resource name.
# Azure keeps this for history, auditing and troubleshooting.
# ------------------------------------------------------------
DEPLOYMENT_NAME="nb-${ENV}-observability"

echo "------------------------------------------------------------"
echo "Deploying NovaBank infrastructure"
echo "Environment      : $ENV"
echo "Location         : $LOCATION"
echo "Resource Group   : $RG"
echo "Deployment Name  : $DEPLOYMENT_NAME"
echo "------------------------------------------------------------"

# ------------------------------------------------------------
# Ensure the resource group exists.
# - If it already exists → nothing happens
# - If it doesn't exist → it will be created
# This makes the script idempotent.
# ------------------------------------------------------------
az group create \
  --name "$RG" \
  --location "$LOCATION" \
  --output none

# ------------------------------------------------------------
# Deploy the Bicep template at Resource Group scope.
# - Uses main.bicep as the infrastructure definition
# - Uses dev.bicepparam or prod.bicepparam depending on ENV
# - ARM will create or update resources as needed
# ------------------------------------------------------------
az deployment group create \
  --resource-group "$RG" \
  --name "$DEPLOYMENT_NAME" \
  --template-file iac/main.bicep \
  --parameters "iac/${ENV}.bicepparam" \
  --output table

echo "------------------------------------------------------------"
echo "Deployment completed successfully"
echo "------------------------------------------------------------"

