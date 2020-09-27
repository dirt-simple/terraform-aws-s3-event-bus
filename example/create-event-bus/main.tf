provider aws {
  region = "us-east-2"
}

// This is done once and is a shared resource. The event bus can be used across multiple buckets.
module event_bus {
  source = "github.com/dirt-simple/terraform-aws-s3-event-bus/create-event-bus"
}

output s3_event_bus_topic_name {
  value = module.event_bus.s3_event_bus_topic_name
}

output s3_event_bus_topic_arn {
  value = module.event_bus.s3_event_bus_topic_arn
}
