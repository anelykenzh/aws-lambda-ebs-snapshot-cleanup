# Architecture

•⁠  ⁠EventBridge scheduled rule triggers the Lambda (daily by default).
•⁠  ⁠Lambda runs inside a VPC (private subnet).
•⁠  ⁠NAT Gateway provides egress for Lambda to reach AWS EC2 API.
•⁠  ⁠Lambda lists EBS snapshots owned by the account and deletes those older than the retention period.
•⁠  ⁠Logs are sent to CloudWatch Logs.
