resource "aws_sqs_queue" "terraform_serverless_queue" {
  name                      = "terraform-example-queue"
  delay_seconds             = 30
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.terraform_serverless_queue_deadletter.arn
    maxReceiveCount     = 4
  })

  tags = {
    Environment = "development"
  }
}

resource "aws_sqs_queue" "terraform_serverless_queue_deadletter" {
  name                      = "terraform-example-queue-deadletter"
  delay_seconds             = 30
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10

  tags = {
    Environment = "development"
  }
}

