##Zip the function to be run at function App.

data "archive_file" "init" {
  type        = "zip"
  source_file = "${path.module}/hello.js"
  output_path = "${path.module}/hello.zip"
}

## S3 Bucket
resource "aws_s3_bucket" "function-bucket" {
  bucket            = "lambda-function-bucket"

  tags = {
    Name = "function-bucket-1"
  }
}

## Upload zip file to s3 bucket
resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.function-bucket.id
  key = "hello.zip"
  source = "${path.module}/hello.zip"
}

## AWS lambda functions
resource "aws_lambda_function" "test_lambda" {
  function_name = "hello"
  s3_bucket     = aws_s3_bucket.function-bucket.id
  s3_key        = "hello.zip"
  role          = "arn:aws:iam::137312912338:role/service-role/game-server-role"
  handler       = "hello.handler"
  runtime       = "nodejs16.x"
}
