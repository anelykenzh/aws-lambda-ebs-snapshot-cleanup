# AWS Lambda EBS Snapshot Cleanup

This project implements an AWS Lambda function (running inside a VPC) that automatically deletes Amazon EBS snapshots older than a defined retention period.

The solution is fully provisioned using Terraform and follows infrastructure-as-code and least-privilege best practices.

---

## Architecture Overview

•⁠  ⁠An EventBridge scheduled rule triggers the Lambda function (daily by default)
•⁠  ⁠The Lambda function runs inside a private subnet within a VPC
•⁠  ⁠A NAT Gateway provides outbound internet access for AWS API calls
•⁠  ⁠The Lambda function:
  - Lists EBS snapshots owned by the AWS account
  - Identifies snapshots older than the retention threshold
  - Deletes eligible snapshots
•⁠  ⁠Logs are sent to CloudWatch Logs

---

## Components

•⁠  ⁠Terraform IaC
  - VPC
  - Private subnet
  - NAT Gateway
  - IAM role and policies
  - Lambda function
  - EventBridge schedule
•⁠  ⁠Python Lambda function (boto3)
•⁠  ⁠CloudWatch Logs for monitoring

---

## Repository Structure
aws-lambda-ebs-snapshot-cleanup/
├── infra/
│   └── terraform/
│       ├── providers.tf
│       ├── variables.tf
│       ├── vpc.tf
│       ├── iam.tf
│       ├── lambda.tf
│       └── outputs.tf
├── lambda/
│   └── handler.py
├── docs/
│   └── architecture.md
└── README.md
---

## Lambda Configuration

### Environment Variables

| Variable         | Description                                   | Default |
|------------------|-----------------------------------------------|---------|
| RETENTION_DAYS   | Snapshot retention period in days             | 365     |
| DRY_RUN          | If true, snapshots are not deleted            | true    |

DRY_RUN is enabled by default to prevent accidental deletions.

---

## Deployment

### Prerequisites

•⁠  ⁠AWS account
•⁠  ⁠AWS CLI configured
•⁠  ⁠Terraform v1.3 or newer

### Deploy with Terraform

```bash
cd infra/terraform
terraform init
terraform apply
Monitoring
	•	Lambda execution logs are available in CloudWatch Logs
	•	Errors during snapshot deletion are logged
	•	Execution metrics are available in CloudWatch Metrics

⸻

Security Considerations
	•	IAM role follows least-privilege principles
	•	Lambda runs inside a private subnet
	•	Outbound access is restricted via NAT Gateway
	•	No credentials are hardcoded
###Cleanup

To destroy all created resources:

terraform destroy
