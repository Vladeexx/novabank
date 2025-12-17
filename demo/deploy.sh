#!/usr/bin/env bash
set -euo pipefail

# ------------------------------------------------------------
# Choose environment:
# - ./deploy.sh dev
# - ./deploy.sh prod
# - or interactive selection if not provided
# ------------------------------------------------------------

ENV="${1:-}"

if [[ -z "$ENV" ]]; then
  echo "Select environment to deploy:"
  select choice in "dev" "prod"; do
    case "$choice" in
      dev) ENV="dev"; break ;;
      prod) ENV="prod"; break ;;
      *) echo "Invalid selection. Please choose 1 or 2." ;;
    esac
  done
fi

if [[ ! "$ENV" =~ ^(dev|prod)$ ]]; then
  echo "Usage: $0 dev|prod"
  exit 1
fi

# ------------------------------------------------------------
# Configuration
# ------------------------------------------------------------

LOCATION="${LOCATION:-westeurope}"

RG="rg-novabank-${ENV}-weu"
VAULT="kv-novabank-${ENV}"
DEPLOYMENT_NAME="nb-${ENV}-deploy"

TEMPLATE_FILE="iac/main.bicep"
PARAM_FILE="iac/${ENV}.bicepparam"

# ------------------------------------------------------------
# Pre-flight checks
# ------------------------------------------------------------

if [[ ! -f "$TEMPLATE_FILE" ]]; then
  echo "ERROR: Missing template file: $TEMPLATE_FILE"
  exit 1
fi

if [[ ! -f "$PARAM_FILE" ]]; then
  echo "ERROR: Missing parameter file: $PARAM_FILE"
  exit 1
fi

echo "------------------------------------------------------------"
echo "Deploying NovaBank infrastructure"
echo "Environment      : $ENV"
echo "Location         : $LOCATION"
echo "Resource Group   : $RG"
echo "Key Vault        : $VAULT"
echo "Deployment Name  : $DEPLOYMENT_NAME"
echo "------------------------------------------------------------"

# ------------------------------------------------------------
# Ensure resource group exists (idempotent)
# ------------------------------------------------------------
az group create \
  --name "$RG" \
  --location "$LOCATION" \
  --output none

# ------------------------------------------------------------
# Fetch Postgres admin password from Key Vault
# ------------------------------------------------------------
echo "Fetching Postgres admin password from Key Vault..."

PG_PASS=$(az keyvault secret show \
  --vault-name "$VAULT" \
  --name DbAdminPassword \
  --query value -o tsv)

# ------------------------------------------------------------
# Deploy Bicep template
# ------------------------------------------------------------
az deployment group create \
  --resource-group "$RG" \
  --name "$DEPLOYMENT_NAME" \
  --template-file "$TEMPLATE_FILE" \
  --parameters "$PARAM_FILE" \
  --parameters pgAdminPassword="$PG_PASS" \
  --output table

# ------------------------------------------------------------
# Cleanup sensitive variables
# ------------------------------------------------------------
unset PG_PASS

echo "------------------------------------------------------------"
echo "Deployment completed successfully"
echo "------------------------------------------------------------"
