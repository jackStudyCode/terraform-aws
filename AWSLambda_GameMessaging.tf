
locals {
  lambda_game_messaging_zip_location = "${path.module}/game-messaging.zip"
}

##Zip the function to be run at function App.
data "archive_file" "init_game_messaging" {
  type        = "zip"
  source_dir  = "${path.module}/Project/GameMessaging"
  output_path = local.lambda_game_messaging_zip_location
}


## AWS lambda functions
resource "aws_lambda_function" "game_messaging_lambda" {
  filename         = local.lambda_game_messaging_zip_location
  function_name    = "game-messaging"
  role             = "arn:aws:iam::137312912338:role/service-role/game-server-role"
  handler          = "index.handler"
  source_code_hash = data.archive_file.init_game_messaging.output_base64sha256
  runtime          = "nodejs16.x"
}
