# Purpose

This is an example React application that will be deployed to S3.
Several services will be configured. Example, Route 53...

# Technology Stack
- Amazon API Gateway
- Amazon CloudFront
- Amazon Route 53
- Amazom S3
- Amazon IAM
- Amazom CloudWatch
- AWS CloudTrail
- Aws CloudFormation

# Commands

## Validate the CloudFormation syntax

```sh
aws cloudformation validate-template --template-body file://./react-cors-spa-stack.yaml
```

## Deploy Stack

```sh
aws cloudformation deploy --template-file ./react-cors-spa-stack.yaml --stack-name react-cors-spa-stack
```

Get the list of events in stack
```sh
aws cloudformation describe-stack-events --stack-name react-cors-spa-stack
```

When the stack is in `ROLLBACK_COMPLETE` state, call the following command
```sh
aws cloudformation delete-stack --stack-name react-cors-spa-stack
```

# Deploy to S3