provider aws {
  region = "us-east-2"
}

// This is done once and is a shared resource. The event bus can be used across multiple buckets.
module event_bus {
  source = "github.com/dirt-simple/terraform-aws-s3-event-bus/create-event-bus"
}

