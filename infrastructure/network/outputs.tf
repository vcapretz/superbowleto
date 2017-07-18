output "lambda_subnet_ids" {
  value = ["${aws_subnet.lambda.*.id}"]
}

output "database_subnet_ids" {
  value = ["${aws_subnet.database.*.id}"]
}

output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}
