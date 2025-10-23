# Azure Migration – Terraform (Modular, Map-driven, Reusable)

This repository provisions an **Azure App Service**, **Azure SQL (server + DB)**, and **four Storage Accounts** in **two regions**: **WE (West Europe)** and **NS (North Europe)**. It uses:
- **Modules** and a **map**-driven multi-region pattern
- **Remote state** in Azure Blob with versioning/soft delete (via a separate bootstrap step)
- **Key Vault** for secrets (SQL admin password & connection string)
- **Logging**, **validation**, and **least-privilege** guidance
