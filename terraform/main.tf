provider "aws" {
  region = "us-east-2"
}

# EC2 Instance

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = [ "amazon" ]
  filter {
    name = "name"
    values = ["al2023-ami-2023*-kernel-6.1-x86_64"]
  }
}

resource "aws_instance" "app_server" {
  ami = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
}

# SNS Topic
resource "aws_sns_topic" "reboot_topic" {
  name = "PacerProTask3"
}

resource "aws_sns_topic_subscription" "email_sub" {
  topic_arn = aws_sns_topic.reboot_topic.arn
  protocol = "email"
  endpoint = "saanvisingh136@gmail.com"
}

# IAM Role
resource "aws_iam_role" "lambda_role" {
  name = "pacerpro_task3_role"
  assume_role_policy = jsonencode({
    Version: "2012-10-17",
    Statement: [
        {
            Effect: "Allow",
            Principal: {
                Service: "lambda.amazonaws.com"
            },
            Action: "sts:AssumeRole"
        }
    ]
})
}

# IAM Policy
resource "aws_iam_role_policy" "task3_policy" {
  role = aws_iam_role.lambda_role.id
  policy = jsonencode({
    Version: "2012-10-17",
    Statement: [
        {
            Effect: "Allow",
            Action: [
                "ec2:RebootInstances",
                "sns:Publish"
            ],
            Resource: [
                "${aws_instance.app_server.arn}",
                "${aws_sns_topic.reboot_topic.arn}"
            ]
        }
    ]
})
}

# Lambda Function
resource "aws_lambda_function" "reboot" {
  filename = "lambda_function.zip"
  function_name = "PacerPro_Task3_Function"
  role = aws_iam_role.lambda_role.arn
  handler = "lambda_function.lambda_handler"
  runtime = "python3.14"
  environment {
    variables = {
      EC2_INSTANCE_ID = aws_instance.app_server.id,
      SNS_ARN = aws_sns_topic.reboot_topic.arn
    }
  }
}
