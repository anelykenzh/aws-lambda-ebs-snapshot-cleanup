output "lambda_name" {
  value = aws_lambda_function.snapshot_cleaner.function_name
}

output "vpc_id" {
  value = aws_vpc.this.id
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}
