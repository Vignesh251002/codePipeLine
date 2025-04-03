version: 0.2

phases:
  install:
    runtime-versions:
      python: 3.9
  pre_build:
    commands:
      - echo "Fetching environment variables..."
      - echo "Stage: $STAGE"
      - echo "Project: $PROJECT"
      - echo "Region: $REGION"
      - echo "DynamoDB Table Name: $DYNAMODB_TABLE_NAME"
      - echo "S3 Bucket: $S3_BUCKET"
      - echo "Template File: $TEMPLATE_FILE"
      - echo "Lambda Function Name: $LAMBDA_FUNCTION_NAME"
      - echo "Stack Name: $STACK_NAME"

  build:
    commands:
      - echo "Checking if S3 bucket exists..."
      - if ! aws s3 ls "s3://$S3_BUCKET"; then
          echo "S3 bucket $S3_BUCKET does not exist. Creating...";
          aws s3 mb "s3://$S3_BUCKET" --region $REGION;
        else
          echo "S3 bucket $S3_BUCKET already exists.";
        fi

      - echo "Storing the template to S3."
      - sam package \
          --template-file $TEMPLATE_FILE \
          --s3-bucket $S3_BUCKET \
          --output-template-file packagedDeploy-template.yaml \
          --region $REGION

      - echo "Deploying application"
      - sam deploy \
          --template-file packagedDeploy-template.yaml \
          --stack-name $STACK_NAME \
          --s3-bucket $S3_BUCKET \
          --region $REGION \
          --no-fail-on-empty-changeset \
          --capabilities CAPABILITY_NAMED_IAM CAPABILITY_IAM \
          --parameter-overrides \
              Stage=$STAGE \
              DynamoDBTableName=$DYNAMODB_TABLE_NAME \
              LambdaFunctionName=$LAMBDA_FUNCTION_NAME \
          --tags created_by="vignesh" purpose="learning"

      - echo "Deployment complete!"
