# Warning, this code is not ready for prime-time. I need to test it.

The S3 Event Bus provides a single event filter configuration for an S3 bucket. All S3 object events get sent to an SNS topic, including the message attributes.

### Wait, doesn't S3 already have a way to write the object events directly to SNS?

Yes, except it doesn't write SNS Message Attributes. It merely writes the object event as the SNS message body. The S3 Event Bus also parses the object's event key/value pairs and copies them to the SNS message attributes. SNS allows one to add as many consumers as they desire, utilizing message attributes to filter the events.

### Nifty, why wouldn't I use the built-in S3 to SNS event with my prefix/suffix pattern and be done?

It is only a matter of time before you step in some S3 dogshit if you use the built-in offering. I think the built-in S3 event notification system has the following weaknesses:
* One cannot trigger multiple events from a single prefix/suffix event filter without coupling downstream systems.
* One cannot have any overlap in prefix/suffix event filters.
* It can be problematic to add new functionality around a particular prefix/suffix event filter if the pattern is already in use.
* One can use the built-in SNS target, but then every subscriber to the topic will get every message. The subscriber has to parse the message to determine interest. The lack of filtering adds costs and likely some bugs in the filtering code.
According to the AWS API documentation, the PutBucketNotificationConfiguration endpoint does the following "This operation replaces the existing notification configuration with the configuration you include in the request body." In other words, you have to have ALL of your event notifications in this one request. It stomps what is there. No joy!

### Great, So how exactly does the S3 Event Bus work?

There are two terraform modules. The first module creates the shared infrastructure for the Event Bus. The second module wires up an existing bucket to send object events to the Event Bus.

Create the S3 Event Bus
```
module s3_event_bus {
  source = "git@gitlab.com:dirt-simple/terraform-aws-s3-event-bus.git"
}
```

Tell your bucket to send events to the bus.
```