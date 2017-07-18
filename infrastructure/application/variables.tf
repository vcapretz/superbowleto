variable "stage" {
  type = "string"
}

variable "region" {
  type = "string"
}

variable "account_id" {
  type = "string"
}

variable "dns_base" {
  type = "string"
}

variable "dns_zone_id" {
  type = "string"
}

variable "vpc_id" {
  type = "string"
}

variable "database_subnet_ids" {
  type = "list"
}

variable "lambda_subnet_ids" {
  type = "list"
}

variable "lambda_execution_role_arn" {
  type = "string"
}

variable "lambda_execution_role_name" {
  type = "string"
}
