provider "aws" {
  region = "${var.region}"
}

terraform {
  backend "s3" {
    bucket = "terraform-state-superbowleto-infrastructure-lock"
    key = "production/terraform.tfstate"
    region = "us-east-1"
    lock_table = "terraform-state-superbowleto-infrastructure-lock"
  }
}

data "aws_caller_identity" "current" {}

module "management" {
  source = "./management"
}

module "network" {
  source = "./network"

  network_prefix = "10.0"
  az_list = [
    "${var.region}a",
    "${var.region}b",
    "${var.region}c"
  ]
}

module "sandbox_access_control" {
  source = "./access-control"
  stage = "sandbox"

  credstash_secret_reader_policy_arn = "${module.management.credstash_secret_reader_policy_arn}"
}

module "sandbox" {
  source = "./application"
  stage = "sandbox"
  region = "${var.region}"
  account_id = "${data.aws_caller_identity.current.account_id}"

  vpc_id = "${module.network.vpc_id}"
  dns_base = "xxx"
  dns_zone_id = "xxx"

  lambda_execution_role_name = "${module.sandbox_access_control.lambda_execution_role_name}"
  lambda_execution_role_arn = "${module.sandbox_access_control.lambda_execution_role_arn}"
  lambda_subnet_ids = "${module.network.lambda_subnet_ids}"

  database_subnet_ids = "${module.network.database_subnet_ids}"
}
