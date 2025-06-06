provider "azurerm" {
  features {}
  

  tenant_id       = "0f46c550-7a7d-4630-b67d-3cb63948aa0a"
  subscription_id = "52414a32-8b98-454a-a605-c388463d2d8e"
  client_id       = "30cf39c9-8cec-435d-950b-c46c83b762ea"
  client_secret   = "kcV8Q~HTxilRdrBOXtsZcLqZDRkmLz9agMZZbcMZ"
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

resource "azurerm_databricks_workspace" "example" {
  name                = "arulrajgopal-dbx"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku                 = "premium"  

  tags = {
    environment = "Terraform"
  }
}
