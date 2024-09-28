# If not already cloned, clone the remote repository (https://github.com/aws-samples/amazon-bedrock-samples) and change working directory to HR agent shell folder
# cd amazon-bedrock-samples/agents/hr-agent/shell/
# chmod u+x create-hr-resources.sh
# export STACK_NAME=<YOUR-STACK-NAME> # Stack name must be lower case for S3 bucket naming convention
# export SNS_EMAIL=<YOUR-EMPLOYEE-EMAIL> # Email used for SNS notifications
# export AWS_REGION=<YOUR-STACK-REGION> # Stack deployment region
# source ./create-hr-resources.sh

check_query_status() {
#    sleep 5
    query_status=$(aws athena get-query-execution --query-execution-id "$1" --region ${AWS_REGION} --output json)
    if [[ "$query_status" =~ "FAILED" ]]; then
        echo QueryID: "$1", Reason: "$2" Check QueryID for debugging.
        exit 1
    fi
    echo "Query execution succeeded."
}



export ACCOUNT_ID=$(aws sts get-caller-identity --query Account --region ${AWS_REGION} --output text)
export ARTIFACT_BUCKET_NAME=$ACCOUNT_ID-$STACK_NAME-hr-resources

aws s3 mb s3://${ARTIFACT_BUCKET_NAME} --region ${AWS_REGION}
aws s3 cp ../agent/ s3://${ARTIFACT_BUCKET_NAME}/agent/ --region ${AWS_REGION} --recursive --exclude ".DS_Store"



aws cloudformation create-stack \
--stack-name ${STACK_NAME} \
--template-body file://../cfn/hr-resources.yml \
--parameters \
ParameterKey=ArtifactBucket,ParameterValue=${ARTIFACT_BUCKET_NAME} \
ParameterKey=SNSEmail,ParameterValue=$SNS_EMAIL \
--capabilities CAPABILITY_NAMED_IAM \
--region ${AWS_REGION}

aws cloudformation describe-stacks --stack-name $STACK_NAME --region ${AWS_REGION} --query "Stacks[0].StackStatus"
# aws cloudformation wait stack-create-complete --stack-name $STACK_NAME --region ${AWS_REGION}
# aws cloudformation describe-stacks --stack-name $STACK_NAME --region ${AWS_REGION} --query "Stacks[0].StackStatus"
