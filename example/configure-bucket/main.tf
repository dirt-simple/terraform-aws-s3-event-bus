provider aws {
  region = "us-east-2"
}

data aws_caller_identity current {}


// Create a Test Bucket
resource aws_s3_bucket event_test  {
  bucket = "dirt-simple-s3-event-bus-testing-${data.aws_caller_identity.current.account_id}"
  acl = "private"
}

// Configure Test Bucket to Notify the S3 Event Bus.
// This is done once per bucket that you want to use the event bus.
module event_bus_configure_notifications {
  source = "github.com/dirt-simple/terraform-aws-s3-event-bus/configure-bucket"
  bucket_name = aws_s3_bucket.event_test.bucket
}

// Subscribe to the topic (Email is the easiest) and test!