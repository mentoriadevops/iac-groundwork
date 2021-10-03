provider "google" {
  project = var.project
  region  = var.region
}

module "groundwork" {
  source   = "github.com/mentoriaiac/iac-modulo-groundwork.git?ref=v0.1.0"
  project  = var.project
  vpc_name = "groundwork"
  subnetworks = [
    {
      name          = "rede-us-central1"
      ip_cidr_range = "10.0.0.0/16"
      region        = "us-central1"
    },
    {
      name          = "rede-us-west1"
      ip_cidr_range = "10.10.0.0/16"
      region        = "us-west1"
    }
  ]

  firewall_allow = [
    {
      protocol = "tcp"
      port     = [443, 80]
    }
  ]
}

variable "project" {
  description = "Nome do projeto (Default é staging)"
  type        = string
  default     = "direct-link-325016"
}

variable "region" {
  description = "Nome da região"
  type        = string
  default     = "us-central1"
}

output "vpc_id" {
  description = "Retorna o id da VPC criada"
  value       = module.groundwork.vpc_id
}

output "subnets_id" {
  description = "Retorna uma lista de objetos com os atributos das subnets criadas"
  value       = module.groundwork.subnets_id
}