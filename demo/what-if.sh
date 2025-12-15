#!/usr/bin/env bash
set -euo pipefail

# ------------------------------------------------------------
# Choose environment:
# - If argument is passed: ./what-if.sh dev | ./what-if.sh prod
# - If not passed, user is prompted interactively
# ------------------------------------------------------------

ENV="${1:-}"

if [[ -z "$ENV" ]]; then
  echo "Select environment for WHAT-IF preview:"
  select choice in "dev" "prod"; do
    case "$choice" in
      dev) ENV="dev"; break ;;
      prod) ENV="prod"; break ;;
      *) echo "Invalid selection. Please choose 1 or 2." ;;
    esac
  done
fi

# Validate environment
if [[ ! "$ENV" =~ ^(dev|prod)$ ]]; then
  echo "Usage: $0 dev|prod"
  exit 1
fi

# ------------------------------------------------------------
# Configuration
# ------------------------------------------------------------
LOCATION="${LOCATION:-westeurope}"

RG="rg-novabank-${ENV}-weu"
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
echo "WHAT-IF preview for NovaBank infrastructure"
echo "Environment    : $ENV"
echo "Resource Group : $RG"
echo "------------------------------------------------------------"

# ------------------------------------------------------------
# WHAT-IF preview (no changes applied)
# ------------------------------------------------------------
az deployment group what-if \
  --resource-group "$RG" \
  --template-file "$TEMPLATE_FILE" \
  --parameters "$PARAM_FILE" \
  --result-format ResourceIdOnly

echo "------------------------------------------------------------"
echo "WHAT-IF preview completed (no changes were applied)"
echo "------------------------------------------------------------"
