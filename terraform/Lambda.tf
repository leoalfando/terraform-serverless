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
  output_dir = "${path.module}/../dist/function.zip"
}

## s3 bucket

resource "aws_s3_bucket" "leoBucket" {
  bucket = "terraformServerless01"
  acl = "private"
  tags= {
    Name = "terraformServerless-1"
  }
}

## upload zip to s3 bucket
resource "aws_s3_bucket_object" "object"{
  bucket = "aws_s3_bucket.leoBucket.id"
  key = "function.zip"
  source = "${path.module}/function.zip"
}

## IAM role for lambda
resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"
  assume_role_policy = file("/lambda_assume_role_policy.json")
}

## IAM role-policy for lambda
resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_policy"
  role = aws_iam_role.lambda_role.id
  policy= file("/lambda_policy.json")
}

resource "aws_lambda_function" "leo-sendMail"{
  filename = "sendMail"
  s3_bucket = aws_s3_bucket.leoBucket.id
  s3_key = aws_s3_bucket_object.object.key
  role = aws_iam_role.lambda_role.arn
  handler = "functions/sendMail.handler"
  runtime = "nodejs12.x"
}
