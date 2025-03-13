resource_group_name = "dailyaffirmations-dev-rg"
location            = "eastus2"
app_name            = "dailyaffirmations"
environment         = "dev"

# Tags
tags = {
  Environment = "Development"
  Project     = "Daily Affirmations"
  Owner       = "DevOps Team"
  ManagedBy   = "Terraform"
}

# PostgreSQL Configuration
postgres_admin_username = "affirmationsadmin"

# Backend Container App Configuration
backend_container_cpu    = 0.5
backend_container_memory = "1Gi"
backend_min_replicas     = 1
backend_max_replicas     = 3

# Frontend Container App Configuration
frontend_container_cpu    = 0.5
frontend_container_memory = "1Gi"
frontend_min_replicas     = 1
frontend_max_replicas     = 3
