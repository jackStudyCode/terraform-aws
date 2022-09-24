
locals {
    lambda_disconnect_game_zip_location = "${path.module}/disconnect-game-1.zip"
}

##Zip the function to be run at function App.
data "archive_file" "init_disconnect_game" {
  type        = "zip"
  source_dir = "${path.module}/Project/DisconnectGame"
  output_path = "${path.module}/disconnect-game-1.zip"
}

## AWS lambda functions
resource "aws_lambda_function" "disconnect_game_lambda" {
  filename      = "${local.lambda_disconnect_game_zip_location}"
  function_name = "disconnect-game-1"
  role          = "arn:aws:iam::137312912338:role/service-role/game-server-role"
  ##role            = "arn:aws:lambda:us-west-1:137312912338:function:disconnect-game-1"
  handler       = "index.handler"
  source_code_hash = "${data.archive_file.init_disconnect_game.output_base64sha256}"
  runtime       = "nodejs16.x"
}
