variable bucket_name {
  description = "The bucket to setup for the s3 event bus"
}

data aws_lambda_function s3_event_bus {
  function_name = "dirt-simple-s3-event-bus"
}

resource aws_s3_bucket_notification s3_event_bus {
  bucket = var.bucket_name
  lambda_function {
    id = var.bucket_name
    lambda_function_arn = data.aws_lambda_function.s3_event_bus.arn
    events              = ["s3:ObjectCreated:*", "s3:ObjectRemoved:*"]
  }
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowBucket-${var.bucket_name}"
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.s3_event_bus.arn
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${var.bucket_name}"
}
