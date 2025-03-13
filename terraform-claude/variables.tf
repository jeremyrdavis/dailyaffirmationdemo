variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region to deploy resources"
  type        = string
}

variable "app_name" {
  description = "Base name for all resources"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, test, prod)"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# PostgreSQL Configuration
variable "postgres_admin_username" {
  description = "PostgreSQL server admin username"
  type        = string
  sensitive   = true
  default     = "dailyaffirmationsadmin"
}

# Create PostgreSQL Flexible Server
variable "postgres_admin_password" {
    description = "PostgreSQL server admin password"
    type        = string
    sensitive   = true
}


# Backend Container App Configuration
variable "backend_container_cpu" {
  description = "CPU cores allocated to backend container"
  type        = number
}

variable "backend_container_memory" {
  description = "Memory allocated to backend container in GB"
  type        = string
}

variable "backend_min_replicas" {
  description = "Minimum number of backend container replicas"
  type        = number
  default     = 1
}

variable "backend_max_replicas" {
  description = "Maximum number of backend container replicas"
  type        = number
  default     = 10
}

# Frontend Container App Configuration
variable "frontend_container_cpu" {
  description = "CPU cores allocated to frontend container"
  type        = number
}

variable "frontend_container_memory" {
  description = "Memory allocated to frontend container in GB"
  type        = string
}

variable "frontend_min_replicas" {
  description = "Minimum number of frontend container replicas"
  type        = number
  default     = 1
}

variable "frontend_max_replicas" {
  description = "Maximum number of frontend container replicas"
  type        = number
  default     = 10
}
