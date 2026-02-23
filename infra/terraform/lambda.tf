data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../../lambda"
  output_path = "${path.module}/build/lambda.zip"
}

resource "aws_lambda_function" "snapshot_cleaner" {
  function_name = var.project_name
  role          = aws_iam_role.lambda.arn
  handler       = "handler.handler"
  runtime       = "python3.12"
  timeout       = 60
  memory_size   = 256

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  vpc_config {
    subnet_ids         = [aws_subnet.private.id]
    security_group_ids = [aws_security_group.lambda.id]
  }

  environment {
    variables = {
      RETENTION_DAYS = tostring(var.retention_days)
      DRY_RUN        = var.dry_run ? "true" : "false"
    }
  }

  depends_on = [aws_iam_role_policy_attachment.lambda_vpc]
}

resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${aws_lambda_function.snapshot_cleaner.function_name}"
  retention_in_days = 14
}

resource "aws_cloudwatch_event_rule" "schedule" {
  name                = "${var.project_name}-schedule"
  schedule_expression = var.schedule_expression
}

resource "aws_cloudwatch_event_target" "target" {
  rule      = aws_cloudwatch_event_rule.schedule.name
  target_id = "${var.project_name}-lambda"
  arn       = aws_lambda_function.snapshot_cleaner.arn
}

resource "aws_lambda_permission" "allow_events" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.snapshot_cleaner.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.schedule.arn
}
