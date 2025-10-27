# Module Walkthrough

## Root (`main.tf`)
- Iterates over `local.regions` (a map) to deploy to **WE** and **NS**.
- For each region: creates a Resource Group, VNet/Subnet with SQL service endpoint, SQL server+DB, App Service Plan + Web App, and 4 Storage Accounts.

## `modules/rg`
- Creates the Resource Group.

## `modules/network`
- Creates a VNet and a subnet. The subnet has **service endpoints** for **Microsoft.Sql**.
- Outputs the subnet ID used for App Service VNet integration.

## `modules/sql`
- Creates an Azure SQL Server and Database.
- Reads admin password from Key Vault (data source).
- Optionally adds a minimal firewall rule for Azure services (can be disabled).

## `modules/appservice`
- Creates an App Service Plan and Windows Web App.
- Integrates the Web App with the subnet (VNet integration) using the subnet id.
- Sets a connection string on the Web App from Key Vault (data source).

## `modules/storage`
- Creates **N** Storage Accounts (default **4**) per region using **count** and a random suffix for uniqueness.

