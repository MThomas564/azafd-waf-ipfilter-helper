# azafd-waf-ipfilter-helper
# This script updates Azure Front Door WAF policy IP filter rules based on environment-specific config and data files.

param(
    # Specify the environment: dev, test, or prod
    [Parameter(Mandatory=$true)]
    [ValidateSet("dev", "test", "prod")]
    [string]$Environment
)

# Load the configuration file for the selected environment
$configPath = "./config/$Environment.json"
$config = Get-Content -Raw -Path $configPath | ConvertFrom-Json
Write-Host "Using configuration from $configPath"

# Load the IP address data from the corresponding CSV file
$csvData = Import-Csv -Path "./data/$config.fileName"

Write-Host "Updating WAF policy: $($config.policyName) in resource group: $($config.resourceGroup), with $($csvData.IPAddress.Count) IP addresses."

# Set the Azure subscription context
az account set --subscription $config.subscriptionId

# Add a new match condition to the WAF policy rule for the list of IP addresses
az network front-door waf-policy rule match-condition add `
    --policy-name $config.policyName `
    --resource-group $config.resourceGroup `
    --name $config.ipFilterName `
    --match-variable SocketAddr `
    --operator IPMatch `
    --values $csvData.IPAddress

Write-Host "Rule match conditions added successfully."

# Remove the existing match condition at index 0 (if present)
Write-Host "Removing existing match condition at index 0."
az network front-door waf-policy rule match-condition remove `
    --policy-name $config.policyName `
    --resource-group $config.resourceGroup `
    --name $config.ipFilterName `
    --index 0

Write-Host "Match condition removed successfully."
