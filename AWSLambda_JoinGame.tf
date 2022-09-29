
locals {
  lambda_join_game_zip_location = "${path.module}/join-game-1.zip"
}

##Zip the function to be run at function App.
data "archive_file" "init_join_game" {
  type        = "zip"
  source_dir  = "${path.module}/Project/JoinGame"
  output_path = local.lambda_join_game_zip_location
}


## AWS lambda functions
resource "aws_lambda_function" "join_game_lambda" {
  filename         = local.lambda_join_game_zip_location
  function_name    = "join-game-1"
  role             = "arn:aws:iam::137312912338:role/service-role/game-server-role"
  handler          = "index.handler"
  source_code_hash = data.archive_file.init_join_game.output_base64sha256
  runtime          = "nodejs16.x"
}
