#! /bin/bash

# Accept the environment argument
arg=$1
echo $arg

# Source the environment variables from the given file
source ../env/$arg.sh

echo "==========================================="
echo "Environment Variables Successfully Imported!"
echo "==========================================="
echo "Environment: ${Environment}"
echo "ResourcePrefix: ${ResourcePrefix}"
echo "Region: ${REGION}"
echo "GitHub Repository: ${GitrepositoryName}"
echo "GitHub Branch: ${GitBranch}"
echo "GitHub Owner: ${GitHubOwner}"
echo "GitHub Provider Type: ${GitHubProviderType}"
echo "GitHub Connection Name: ${connection}"
echo "Pipeline Name: ${pipeLine}"
echo "CodeBuild Name: ${codeBuild}"
echo "CodePipeline S3 Bucket: ${codePipeLineS3Bucket}"
echo "CloudFormation S3 Bucket: ${cloudformationS3Bucket}"
echo "CodePipeline Template File: ${codePipelineTemplateFile}"
echo "CloudFormation Template File: ${cloudformationTemplateFile}"
echo "CodePipeline Stack Name: ${codePileLineStackName}"
echo "CloudFormation Stack Name: ${cloudformationStackName}"
echo "DynamoDB Table Name: ${DynamoDBTableName}"
echo "Lambda Function Name: ${LambdaFunctionName}"
echo "Tags: ${Tags}"
echo "==========================================="


# Deploy CloudFormation stack using AWS SAM
echo "Deploying AWS CloudFormation Pipeline..."

sam deploy \
    -t "${codePipelineTemplateFile}" \
    --stack-name "${Environment}-${ResourcePrefix}-${codePileLineStackName}" \
    --region "${REGION}" \
    --no-fail-on-empty-changeset \
    --capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND \
    --parameter-overrides \
        "PipelineName=${pipeLine}" \
        "codeBuildName=${codeBuild}" \
        "codePileLineStackName=${codePileLineStackName}" \
        "ArtifactBucketName=${codePipeLineS3Bucket}" \
        "GitHubConnectionName=${connection}" \
        "GitHubProviderType=${GitHubProviderType}" \
        "GitHubRepo=${GitrepositoryName}" \
        "ResourcePrefix=${ResourcePrefix}" \
        "Environment=${Environment}" \
        "GitHubBranch=${GitBranch}" \
        "GitHubOwner=${GitHubOwner}" \
        "Region=${REGION}" \
        "Tags=${tags}" \
        "Stage=${Environment}" \
        "DynamoDBTableName=${DynamoDBTableName}" \
        "CloudFormationS3Bucket=${cloudformationS3Bucket}" \
        "TemplateFile=${cloudformationTemplateFile}" \
        "LambdaFunctionName=${LambdaFunctionName}" \
        "CloudFormationStackName=${cloudformationStackName}"


echo "All deployments were successful!"
