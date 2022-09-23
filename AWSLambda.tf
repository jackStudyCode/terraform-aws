
locals {
    lambda_zip_location = "${path.module}/hello.zip"
}

##Zip the function to be run at function App.

data "archive_file" "init" {
  type        = "zip"
  source_file = "${path.module}/hello.js"
  output_path = "${path.module}/hello.zip"
}

## S3 Bucket
resource "aws_s3_bucket" "function-bucket" {
  bucket = "lambda-function-bucket-zixun"

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

## IAM role for lambda
resource "aws_iam_role" "lambda_role" {
    name = "lambda_role"
    assume_role_policy = file("lambda_assume_role_policy.json")
}

## IAM role-policy for lambda
resource "aws_iam_role_policy" "lambda_policy" {
    name = "lambda_policy"
    role = aws_iam_role.lambda_role.id
    policy = file("lambda_policy.json")
}


##data "aws_s3_bucket_object" "hash" {
  ##bucket = aws_s3_bucket.function-bucket.id
  ##key    = ${"hello.zip"}
##}

## AWS lambda functions
resource "aws_lambda_function" "test_lambda" {
  ##filename      = "${local.lambda_zip_location}"
  function_name = "hello"
  s3_bucket     = aws_s3_bucket.function-bucket.id
  s3_key        = "hello.zip"
  role          = "arn:aws:iam::137312912338:role/service-role/game-server-role"
  handler       = "hello.handler"
  ##source_code_hash = "${filebase64sha256(local.lambda_zip_location)}"
  ##source_code_hash = data.aws_s3_bucket_object.hash.body
  source_code_hash = "${data.archive_file.init.output_base64sha256}"
  runtime       = "nodejs16.x"
}
