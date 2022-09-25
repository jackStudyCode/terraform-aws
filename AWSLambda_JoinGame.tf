
locals {
  lambda_join_game_zip_location = "${path.module}/join-game-1.zip"
}

##Zip the function to be run at function App.

data "archive_file" "init_join_game" {
  type       = "zip"
  source_dir = "${path.module}/Project/JoinGame"
  #source_file = "${path.module}/Project/JoinGame/join-game-1.js"
  output_path = "${path.module}/join-game-1.zip"
}


## AWS lambda functions
resource "aws_lambda_function" "join_game_lambda" {
  filename      = local.lambda_join_game_zip_location
  function_name = "join-game-1"
  ##s3_bucket     = aws_s3_bucket.function-bucket.id
  ##s3_key        = "join-game-1.zip"
  role = "arn:aws:iam::137312912338:role/service-role/game-server-role"
  ##role            = "arn:aws:lambda:us-west-1:137312912338:function:join-game-1"
  handler = "index.handler"
  ##source_code_hash = "${filebase64sha256(local.lambda_join_game_zip_location)}"
  ##source_code_hash = data.aws_s3_bucket_object.hash.body
  source_code_hash = data.archive_file.init_join_game.output_base64sha256
  runtime          = "nodejs16.x"
}
