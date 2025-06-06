provider "azurerm" {
  features {}
  

  tenant_id       = ""
  subscription_id = ""
  client_id       = ""
  client_secret   = ""
}

resource "azurerm_resource_group" "example" {
  name     = "test_resource_group"
  location = "South India"
}

resource "azurerm_storage_account" "example" {
  name                     = "arulrajgopal5245"    
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = true

  tags = {
    environment = "Terraform"
  }
}
