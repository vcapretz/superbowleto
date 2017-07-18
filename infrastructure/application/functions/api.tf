resource "aws_api_gateway_rest_api" "rest_api" {
  name = "${var.stage}-superbowleto"
  description = "superbowleto API"
}

resource "aws_api_gateway_resource" "resource_boleto_root" {
  rest_api_id = "${aws_api_gateway_rest_api.rest_api.id}"
  parent_id = "${aws_api_gateway_rest_api.rest_api.root_resource_id}"
  path_part = "boletos"
}

resource "aws_api_gateway_resource" "resource_boleto_id" {
  rest_api_id = "${aws_api_gateway_rest_api.rest_api.id}"
  parent_id = "${aws_api_gateway_resource.resource_boleto_root.id}"
  path_part = "{id}"
}

resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = "${aws_api_gateway_rest_api.rest_api.id}"
  stage_name = "${var.stage}"

  depends_on = [
    "module.endpoint_create_boleto",
    "module.endpoint_index_boleto",
    "module.endpoint_show_boleto",
    "module.endpoint_update_boleto"
  ]
}

resource "aws_api_gateway_domain_name" "pagarme_domain" {
  domain_name = "${var.stage}-superbowleto.${var.dns_base}"
}

resource "aws_route53_record" "pagarme_domain" {
  zone_id = "${var.dns_zone_id}"

  name = "${aws_api_gateway_domain_name.pagarme_domain.domain_name}"
  type = "A"

  alias {
    name                   = "${aws_api_gateway_domain_name.pagarme_domain.cloudfront_domain_name}"
    zone_id                = "${aws_api_gateway_domain_name.pagarme_domain.cloudfront_zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_api_gateway_base_path_mapping" "test" {
  api_id      = "${aws_api_gateway_rest_api.rest_api.id}"
  stage_name  = "${aws_api_gateway_deployment.api_deployment.stage_name}"
  domain_name = "${aws_api_gateway_domain_name.pagarme_domain.domain_name}"
}

resource "aws_api_gateway_usage_plan" "pagarme" {
  name = "${var.stage}-pagarme"
  description = "Usage plan meant to be used by Pagar.me Services on ${var.stage} environment"

  api_stages {
    api_id = "${aws_api_gateway_rest_api.rest_api.id}"
    stage = "${aws_api_gateway_deployment.api_deployment.stage_name}"
  }
}

resource "aws_api_gateway_api_key" "pagarme" {
  name = "${var.stage}-pagarme"
  description = "API key meant to be used by Pagar.me Services on ${var.stage} environment"
}

resource "aws_api_gateway_usage_plan_key" "pagarme" {
  key_id = "${aws_api_gateway_api_key.pagarme.id}"
  key_type = "API_KEY"
  usage_plan_id = "${aws_api_gateway_usage_plan.pagarme.id}"
}
