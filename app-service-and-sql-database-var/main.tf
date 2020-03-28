
provider "azurerm" {
  version = "=2.3.0"
  features {}
}
resource "azurerm_resource_group" "test" {
  name     = "SPRG02"
  location = "West Europe"
}

resource "azurerm_app_service_plan" "test" {
  name                = "example-appserviceplan-2020"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "test" {
  name                = "terraform-app-service-2020"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  app_service_plan_id = azurerm_app_service_plan.test.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }

  app_settings = {
    "SOME_KEY" = "some-value"
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=tcp:azurerm_sql_server.test.fully_qualified_domain_name Database=azurerm_sql_database.test.name;User ID=azurerm_sql_server.test.administrator_login;Password=azurerm_sql_server.test.administrator_login_password;Trusted_Connection=False;Encrypt=True"
  }
}

resource "azurerm_sql_server" "test" {
  name                         = "terraform-sqlserver-2020"
  resource_group_name          = azurerm_resource_group.test.name
  location                     = azurerm_resource_group.test.location
  version                      = "12.0"
  administrator_login          = "houssem"
  administrator_login_password = "4-v3ry-53cr37-p455w0rd"
}

resource "azurerm_sql_database" "test" {
  name                = "terraform-sqldatabase-2020"
  resource_group_name = azurerm_resource_group.test.name
  location            = azurerm_resource_group.test.location
  server_name         = azurerm_sql_server.test.name

  tags = {
    environment = "production"
  }
}