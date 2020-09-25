import os
import json
import boto3
from botocore.exceptions import ClientError

sns_client = boto3.client('sns')
event_bus_topic_arn = os.environ['S3_EVENT_BUS_TOPIC_ARN']


def handler(event, context):
    for record in event['Records']:
        try:
            key = record['s3']['object']['key']
            filename, ext = os.path.splitext(os.path.basename(key))

            attributes = {
                    'event': {
                        'DataType': 'String',
                        'StringValue': record['eventName']
                    },
                    'bucket': {
                        'DataType': 'String',
                        'StringValue': record['s3']['bucket']['name']
                    },
                    'key': {
                        'DataType': 'String',
                        'StringValue': record['s3']['object']['key']
                    },
                    'size': {
                        'DataType': 'Number',
                        'StringValue': f"{record['s3']['object']['size']}"
                    },
                    'filename': {
                        'DataType': 'String',
                        'StringValue': filename
                    }
                }

            if ext:
                attributes.update({'ext': {'DataType': 'String', 'StringValue': ext}})

            message_id = sns_client.publish(
                TopicArn=event_bus_topic_arn,
                Message=json.dumps(record),
                MessageAttributes=attributes
            )
            print(message_id)

        except ClientError as e:
            raise e