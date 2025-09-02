# azurerm provider setup
provider "azurerm" {
  features {}

  tenant_id       = var.tenant_id
  subscription_id = var.subscriber_id
  client_id       = var.client_id
  client_secret   = var.client_secret
}

resource "azurerm_resource_group" "resource_group" {
  name     = "test_resource_group"
  location = "South India"
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "arulteststorageacct"
  resource_group_name       = azurerm_resource_group.resource_group.name
  location                 = azurerm_resource_group.resource_group.location
  account_tier              = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = true

  tags = {
    environment = "Terraform"
  }
  
}

resource "azurerm_data_factory" "adf" {
  name                = "arultestadf"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  tags = {
    environment = "Terraform"
  }
}

resource "azurerm_resource_group" "rg_dev" {
  name     = "dbx-dev"
  location = "South India"
}


resource "azurerm_databricks_workspace" "dbx1" {
  name                = "kaniniwitharul-dbx1-dev"
  resource_group_name = azurerm_resource_group.rg_dev.name
  location            = azurerm_resource_group.rg_dev.location
  sku                 = "premium"

    tags = {
    environment = "Terraform"
  }
}

resource "azurerm_resource_group" "rg_prod" {
  name     = "dbx-prod"
  location = "South India"
}


resource "azurerm_databricks_workspace" "dbx2" {
  name                = "kaniniwitharul-dbx1-prod"
  resource_group_name = azurerm_resource_group.rg_prod.name
  location            = azurerm_resource_group.rg_prod.location
  sku                 = "premium"

    tags = {
    environment = "Terraform"
  }

  depends_on = [azurerm_databricks_workspace.dbx1]
}




# azuread provider setup
provider "azuread" {
 tenant_id       = var.tenant_id
 client_id       = var.client_id
 client_secret   = var.client_secret
}


# Create an Azure AD application and service principal
# to assign the Storage Blob Data Contributor role
data "azuread_client_config" "current" {}

resource "azuread_application" "ad_app" {
  display_name = "spn6789"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "spn" {
  client_id                    = azuread_application.ad_app.client_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

resource "azurerm_role_assignment" "spn_blob_contributor" {
  scope                = azurerm_resource_group.resource_group.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azuread_service_principal.spn.object_id
}


# Assign the Owner role to a specific user
data "azuread_user" "target_user" {
  user_principal_name = "User-2@arulrajgopaloutlook.onmicrosoft.com"
}


resource "azurerm_role_assignment" "owner_assignment" {
  scope                = "/subscriptions/52414a32-8b98-454a-a605-c388463d2d8e"
  role_definition_name = "Owner"
  principal_id         = data.azuread_user.target_user.object_id
}





