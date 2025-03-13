terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.75.0"
    }
  }
  # Using local backend initially - can be changed to azurerm after storage is provisioned
  # backend "azurerm" {
  #   resource_group_name  = "terraform-state-rg"
  #   storage_account_name = "terraformstate"
  #   container_name       = "tfstate"
  #   key                  = "dailyaffirmations.terraform.tfstate"
  # }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

# Create Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Create Log Analytics Workspace for Container Apps
resource "azurerm_log_analytics_workspace" "workspace" {
  name                = "${var.app_name}-workspace"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

# Create Container App Environment
resource "azurerm_container_app_environment" "environment" {
  name                       = "${var.app_name}-environment"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.workspace.id
  tags                       = var.tags
}

resource "azurerm_postgresql_flexible_server" "postgres" {
  name                   = "${var.app_name}-psqldb"
  resource_group_name    = azurerm_resource_group.rg.name
  location               = azurerm_resource_group.rg.location
  version                = "14"
  administrator_login    = var.postgres_admin_username
  administrator_password = var.postgres_admin_password
  storage_mb             = 32768
  backup_retention_days  = 7
  zone                   = "1"
  tags                   = {
    environment = var.app_name
  }

  sku_name = "B_Standard_B1ms"
  
  maintenance_window {
    day_of_week  = 0
    start_hour   = 0
    start_minute = 0
  }
  
  depends_on = [azurerm_resource_group.rg]
}

# Create PostgreSQL Database
resource "azurerm_postgresql_flexible_server_database" "database" {
  name      = "${var.app_name}-db"
  server_id = azurerm_postgresql_flexible_server.postgres.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}

# Allow access from Azure services
resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_azure_services" {
  name             = "AllowAzureServices"
  server_id        = azurerm_postgresql_flexible_server.postgres.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

# Backend API Container App
resource "azurerm_container_app" "backend" {
  name                         = "${var.app_name}-api"
  container_app_environment_id = azurerm_container_app_environment.environment.id
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = "Single"
  tags                         = var.tags

  template {
    container {
      name   = "dailyaffirmations-api"
      image  = "jeremydavis/dailyaffirmations:1.4"
      cpu    = var.backend_container_cpu
      memory = var.backend_container_memory

      env {
        name  = "DB_HOST"
        value = azurerm_postgresql_flexible_server.postgres.fqdn
      }
      env {
        name  = "DB_NAME"
        value = "${var.app_name}-db"
      }
      env {
        name  = "DB_USER"
        value = var.postgres_admin_username
      }
      env {
        name  = "DB_PASSWORD"
        value = var.postgres_admin_password
      }
      env {
        name  = "DB_URL"
        value = "jdbc:postgresql://${azurerm_postgresql_flexible_server.postgres.fqdn}/${var.app_name}-db"
      }
      env {
        name  = "DB_VERSION"
        value = "14"
      }
    }

    min_replicas = var.backend_min_replicas
    max_replicas = var.backend_max_replicas
  }

  ingress {
    external_enabled = true
    target_port      = 8080
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
}

# Frontend UI Container App
resource "azurerm_container_app" "frontend" {
  name                         = "${var.app_name}-ui"
  container_app_environment_id = azurerm_container_app_environment.environment.id
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = "Single"
  tags                         = var.tags

  template {
    container {
      name   = "dailyaffirmations-ui"
      image  = "jeremydavis/dailyaffirmations-ui:1.3"
      cpu    = var.frontend_container_cpu
      memory = var.frontend_container_memory

      env {
        name  = "API_URL"
        value = "https://${azurerm_container_app.backend.ingress[0].fqdn}"
      }
      env {
        name  = "NODE_ENV"
        value = var.environment
      }
    }

    min_replicas = var.frontend_min_replicas
    max_replicas = var.frontend_max_replicas
  }

  ingress {
    external_enabled = true
    target_port      = 8080  # Assuming the UI container exposes port 80
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  depends_on = [azurerm_container_app.backend]
}

