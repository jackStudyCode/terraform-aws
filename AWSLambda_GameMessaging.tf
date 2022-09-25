
locals {
  lambda_game_messaging_zip_location = "${path.module}/game-messaging.zip"
}

##Zip the function to be run at function App.

data "archive_file" "init_game_messaging" {
  type       = "zip"
  source_dir = "${path.module}/Project/GameMessaging"
  #source_file = "${path.module}/Project/GameMessaging/game-messaging.js"
  output_path = "${path.module}/game-messaging.zip"
}


## AWS lambda functions
resource "aws_lambda_function" "game_messaging_lambda" {
  filename      = local.lambda_game_messaging_zip_location
  function_name = "game-messaging"
  ##s3_bucket     = aws_s3_bucket.function-bucket.id
  ##s3_key        = "game-messaging.zip"
  role = "arn:aws:iam::137312912338:role/service-role/game-server-role"
  ##role            = "arn:aws:lambda:us-west-1:137312912338:function:game-messaging"
  handler = "index.handler"
  ##source_code_hash = "${filebase64sha256(local.lambda_join_game_zip_location)}"
  ##source_code_hash = data.aws_s3_bucket_object.hash.body
  source_code_hash = data.archive_file.init_game_messaging.output_base64sha256
  runtime          = "nodejs16.x"
}
