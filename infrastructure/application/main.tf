module "sqs" {
  source = "./sqs"
  stage = "${var.stage}"
  region = "${var.region}"
  account_id = "${var.account_id}"

  lambda_execution_role_name = "${var.lambda_execution_role_name}"
}

module "database" {
  source = "./database"
  stage = "${var.stage}"
  region = "${var.region}"

  database_subnet_ids = "${var.database_subnet_ids}"
  database_security_group_id = "${aws_security_group.database.id}"
}

module "functions" {
  source = "./functions"
  stage = "${var.stage}"
  region = "${var.region}"
  account_id = "${var.account_id}"
  dns_base = "${var.dns_base}"
  dns_zone_id = "${var.dns_zone_id}"

  lambda_execution_role_arn = "${var.lambda_execution_role_arn}"
  lambda_subnet_ids = "${var.lambda_subnet_ids}"
  lambda_security_group_id = "${aws_security_group.lambda.id}"

  boletos_to_register_queue_url = "${module.sqs.boletos_to_register_queue_url}"
  database_endpoint = "${module.database.endpoint}"
  database_username = "${module.database.username}"
  database_name = "${module.database.name}"
}
