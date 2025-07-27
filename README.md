# azafd-waf-ipfilter-helper

A PowerShell script to help manage Azure Front Door WAF policy IP filter rules using environment-specific configuration and data files.

## Features
- Adds or updates IP match conditions for a WAF policy rule
- Supports multiple environments (dev, test, prod)
- Reads configuration and IP data from JSON and CSV files

## Prerequisites
- PowerShell 7+
- Azure CLI installed and logged in (`az login`)
- Sufficient permissions to manage Azure Front Door WAF policies

## Usage

1. Place your environment config files in the `config/` folder (e.g., `dev.json`, `test.json`, `prod.json`).
2. Place your IP address CSV files in the `data/` folder (e.g., `devWafRules.csv`).
3. Run the script with the desired environment:

```powershell
./azafd-waf-ipfilter-helper.ps1 -Environment dev
```

## Example Config
See `config/example.json` and `data/example.csv` for sample files.

## What it does
- Loads the config and IP list for the specified environment
- Sets the Azure subscription context
- Adds a new IP match condition to the specified WAF policy rule
- Optionally removes the existing match condition at index 0

## License
MIT
