#! /bin/bash

# Accept the environment argument
arg=$1
echo $arg

# Source the environment variables from the given file
source ./env/$arg.sh

echo "Environment Variables Successfully Imported!"
echo "==========================================="
echo "TemplateFile: ${TemplateFile}"
echo "StackName: ${Environment}-${ResourcePrefix}-${stack}"
echo "PipelineName: ${pipeLine}"
echo "CodeBuildName: ${codeBuild}"
echo "ArtifactBucketName: ${ArtifactBucket}"
echo "GitHubConnectionName: ${connection}"
echo "GitHubProviderType: ${GitHubProviderType}"
echo "GitHubRepo: ${GitrepositoryName}"
echo "GitHubBranch: ${GitBranch}"
echo "GitHubOwner: ${GitHubOwner}"
echo "Region: ${REGION}"
echo "Tags: ${Tags}"
echo "==========================================="

# Deploy CloudFormation stack using AWS SAM
echo "Deploying AWS CloudFormation Pipeline..."

sam deploy \
    -t "${TemplateFile}" \
    --stack-name "${Environment}-${ResourcePrefix}" \
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
