# Here we configure the Azure CLI authentication in Terraform:
# This configures Terraform to use the default Subscription defined in the Azure CLI
terraform {
  required_providers {
      azurerm = {
          source ="hashicorp/azurerm"
          version = "=2.46.0"
      }
  }
}

# Here we configure the Microsoft Azure Provider and authenticate using the Azure CLI
provider "azurerm" {
  features {}

  subscription_id = "4c36c606-dceb-478b-933a-2901049e3ab3"
  tenant_id       = "d5070288-ad0f-434d-b5c4-1452a421631f"
}

# Here we define the resource group of the project 
resource "azurerm_resource_group" "webapp_resource_group" {
  name    = var.resource_group_name
  location = var.resource_group_location

  tags = {
    environment = "dev"
  }
}

resource "azurerm_app_service_plan" "webapp_plan" {
  name                          = var.webapp_service_plan_name
  location                      = azurerm_resource_group.webapp_resource_group.location
  resource_group_name           = azurerm_resource_group.webapp_resource_group.name

  # Stock Keeping Unit
  # This is basically the type of Cloud product that we'll use 
  # Source: https://en.wikipedia.org/wiki/Stock_keeping_unit
  # Source: https://docs.microsoft.com/en-us/azure/search/search-sku-tier
  sku{
    tier = "Free"
    size = "S1"
  }

}

# Here we define the MariaDB server resource
# Source: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mariadb_database
resource "azurerm_mariadb_server" "webapp_mariadb_server" {
  name                          = var.sql_server_name
  resource_group_name           = azurerm_resource_group.webapp_resource_group.name
  location                      = azurerm_resource_group.webapp_resource_group.location 

  # This is the name of the DB service that will be added in Azure
  # More details about the naming scheme here: 
  # Source: https://docs.microsoft.com/en-us/rest/api/mariadb/servers/create#sku
  sku_name                      = "B_Gen5_2"

  storage_mb                    = 5120
  backup_retention_days         = 7

  administrator_login           = var.sql_admin_login
  administrator_login_password  = var.sql_admin_password
  version                       = "10.2"
  ssl_enforcement_enabled       = false
}
# Source: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mariadb_database
resource "azurerm_mariadb_database" "webapp_mariadb_db" {
  name                          = var.sql_database_name
  resource_group_name           = azurerm_resource_group.webapp_resource_group.name
  server_name                   = azurerm_mariadb_server.webapp_mariadb_server.name
  charset                       = "utf8"
  collation                     = "utf8_general_ci"
}


resource "azurerm_app_service" "webapp" {
  name                = var.webapp_service_name
  location            = azurerm_resource_group.webapp_resource_group.location
  resource_group_name = azurerm_resource_group.webapp_resource_group.name
  app_service_plan_id = azurerm_app_service_plan.webapp_plan.id

  site_config {
    
  }

  app_settings = {
    "empty-key" = "empty-value"
  }

  # Here we define the MariaDB connection settings within the App 
  connection_string {
    name  = "Database"
    type  = "MySql"
    value = "Server=tcp:azurerm_mariadb_server.webapp_mariadb_server.fully_qualified_domain_name Database=azurerm_mariadb_database.webapp_mariadb_db.name; User ID=azurerm_mariadb_server.webapp_mariadb_server.administrator_login; Password=azurerm_mariadb_server.webapp_mariadb_server.administrator_login_password"
  }

}