# Purpose
- Create Standard SNS
- Create FIFO SNS and FIFO Queue SQS

# Run

Deploy SNS
```bash
aws cloudformation deploy --template-file sns.yaml --stack-name sns-hello-world

# Get information of cloudformation stack
aws cloudformation describe-stack-events --stack-name sns-hello-world
```

Check if SNS is existing
```bash
aws sns list-topics

# {
#     "Topics": [
#         {
#             "TopicArn": # "arn:aws:sns:us-west-2:xxxxxx:CodeStarNotifications-slack-config-for-# aws-beta-040b33ebf7f1460795c807b1ae4a5886e6469c8e"
#         },
#         {
#             "TopicArn": "arn:aws:sns:us-west-2:xxxxx:hello-world"
#         }
#     ]
# }
```

Delete SNS
```bash
aws cloudformation delete-stack --stack-name sns-hello-world
```

Check if SQS is existing
```bash
aws sqs list-queues

# {
#     "QueueUrls": [
#         "https://sqs.us-east-1.amazonaws.com/475910951137/hello-world.fifo"
#     ]
# }
```

# Step
- Create a topic
- Create a subscription to the topic
- Publish a message to the topic
- Delete the subscription and topic

# Learn
- For SNS FIFO, a SQS must be created for subscription