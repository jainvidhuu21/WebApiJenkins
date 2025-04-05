variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "jenkins-vidhi1-rg"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "app_service_plan_name" {
  description = "App Service Plan name"
  type        = string
  default     = "jenkins-vidhi-plan"
}

variable "app_service_name" {
  description = "App Service (Web App) name"
  type        = string
  default     = "jenkins-vidhi-app21"
}
