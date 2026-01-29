
# Monitoring and Automation Solution

This project automates the detection and remediation of API performance issues using Sumo Logic and AWS.

**Link to Demo: https://youtu.be/hIWeNT2rKmg**


## Overview
* **Detection**: A Sumo Logic Monitor tracks logs for the /api/data endpoint. It triggers when more than 5 requests exceed a 3000ms response time within 10 minutes. The query was written and tested on https://www.sumologic.com/
* **Remediation**: An AWS Lambda function reboots the affected EC2 instance and sends an SNS email notification.
* **Infrastructure**: All resources are managed using Terraform.

## Technical Details
* **Python Lambda**: The script uses the Boto3 SDK and retrieves the Instance ID and SNS ARN from environment variables.
* **Terraform**: The code automatically finds the latest Amazon Linux 2023 AMI for the us-east-2 region.
* **Security**: IAM roles follow the principle of least privilege, restricting the Lambda to specific resources i.e. publishing to SNS and rebooting the EC2 instance

## Project Structure
* **terraform/**: Contains main.tf for infrastructure deployment.
* **lambda_function/**: Contains the Python script for the remediation logic.
* **README.md**: Project documentation.

## Decisions and Assumptions
* **Region**: Resources are deployed in us-east-2 (Ohio).
* **Instance Type**: Used t3.micro to stay within the AWS Free Tier for this region.
* **Testing**: The Lambda was tested using manual invocation in the AWS Console to verify the reboot and notification flow.