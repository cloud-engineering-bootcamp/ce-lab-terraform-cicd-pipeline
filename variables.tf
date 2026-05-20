variable "project_name" {
  description = "Nombre identificador del proyecto"
  type        = string
  default     = "anderson-cicd"
}

variable "environment" {
  description = "Entorno de despliegue"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "Región de AWS donde se desplegará todo"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "Rango de IPs de la VPC"
  type        = string
  default     = "10.1.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Rangos de IP para las subnets públicas"
  type        = list(string)
  default     = ["10.1.1.0/24", "10.1.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Rangos de IP para las subnets privadas"
  type        = list(string)
  default     = ["10.1.11.0/24", "10.1.12.0/24"]
}