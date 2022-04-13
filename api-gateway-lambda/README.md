# Deploy

# Deploy command

## Cloudformation

```sh
aws cloudformation validate-template --template-body file://api-gateway-lambda.yaml
```

```sh
aws cloudformation deploy --template-file ./api-gateway-lambda.yaml --stack-name api-gateway-lambda --capabilities CAPABILITY_NAMED_IAM
```

Check the reason of the deployment failure
```sh
aws cloudformation describe-stack-events --stack-name api-gateway-lambda | grep \"CREATE_FAILED\" -A 4 -B 2
```

## Invoke lambda

```sh
aws lambda invoke --invocation-type RequestResponse --function-name hello-world response.json
```

## Delete stack

```sh
aws cloudformation delete-stack --stack-name api-gateway-lambda
```