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

# Deployment
- [Deploy the AWS CloudFormation Template](#deploy-stack)
- Get the value of `APIEndpoint` and `Bucket`
- Copy the value of `APIEndpoint` to `src/App.js`
- Build the application package: `yarn build`
- Upload the content of the `build` folder into the S3 bucket identified by `Bucket`
    - Command: `aws s3 cp --recursive build s3://react-cors-spa-4gxqbwo4b0`

# Clean up
- Delete the S3 bucket contents
- Delete the AWS CloudFormation stack

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
