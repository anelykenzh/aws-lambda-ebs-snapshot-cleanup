# AWS Lambda EBS Snapshot Cleanup

Design and implementation of an AWS Lambda function (running inside a VPC) that deletes EBS snapshots older than 1 year.

## Components
•⁠  ⁠Terraform IaC (VPC + subnets + NAT + IAM + Lambda + EventBridge schedule)
•⁠  ⁠Python Lambda function (boto3)
•⁠  ⁠CloudWatch Logs for monitoring

## How to deploy
1.⁠ ⁠Configure AWS credentials
2.⁠ ⁠Deploy with Terraform:
   ```bash
   cd infra/terraform
   terraform init
   terraform apply
