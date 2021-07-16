terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
provider "aws" {
  profile = "default"
  region  = "ap-southeast-1"
}

data "archive_file" "init"{
  type  = "zip"
  source_dir = "${path.module}/../dist"
  output_path = "${path.module}/function.zip"
}

## s3 bucket

resource "aws_s3_bucket" "leo-bucket" {
  bucket = "terraform-serverless01"
  acl = "private"
  tags= {
    Name = "terraform-serverless-1"
  }
}

## upload zip to s3 bucket
resource "aws_s3_bucket_object" "object"{
  bucket = aws_s3_bucket.leo-bucket.id
  key = "function.zip"
  source = "${path.module}/function.zip"
}

resource "aws_lambda_function" "leo-sendMail"{
  function_name = "sendMail"
  s3_bucket = aws_s3_bucket.leo-bucket.id
  s3_key = aws_s3_bucket_object.object.key
  role = aws_iam_role.lambda_role.arn
  handler = "functions/sendMail.handler"
  runtime = "nodejs12.x"
}
