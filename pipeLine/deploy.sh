#!/bin/bash

# Accept the environment argument
arg=$1
echo $arg

# Source the environment variables from the given file
source ./$arg.sh

echo "Environment Variable successfully Imported"

# Deploy CloudFormation stack using AWS SAM
echo "Deploying AWS CloudFormation Pipeline..."

sam deploy \
    -t "${TemplateFile}" \
    --stack-name "${Environment}-${ResourcePrefix}-$" \
    --region "${REGION}" \
    --no-fail-on-empty-changeset \
    --capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND \
    --parameter-overrides \
        "PipelineName=${pipeLine}" \
        "codeBuildName=${codeBuild}" \
        "StackName=${Environment}-${ResourcePrefix}-${stack}" \
        "ArtifactBucketName=${ArtifactBucket}" \
        "GitHubConnectionName=${connection}" \
        "GitHubProviderType=${GitHubProviderType}" \
        "GitHubRepo=${GitrepositoryName}" \
        "ResourcePrefix=${ResourcePrefix}" \
        "Environment=${Environment}" \
        "GitHubBranch=${GitBranch}" \
        "GitHubOwner=${GitHubOwner}" \
        "Region=${REGION}" \
        "Tags=${Tags}" \
 
   
echo "All deployments were successful!"
