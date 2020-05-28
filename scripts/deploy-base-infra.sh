STACK_NAME="Deploy-${stage}-base-infra"
RED='\033[0;31m'
NC='\033[0m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'

function fail(){
    echo -e "${RED}Failure: $* ${NC}"
    exit 1
}

function info() {
    echo -e "${BLUE} $* ${NC}"
}

function success() {
    echo -e "${GREEN} $* ${NC}"
}

function navigate_to_correct_directory() {
    cd "${0%/*}" # Directory where script lives
    cd ../
}
function deploy() {
    info "deploying stack ${STACK_NAME}..."
    aws cloudformation deploy  --template-file ./resources/create-s3.yml --stack-name $STACK_NAME 
}

function check_aws() {
    info "checking aws cli configuration..."
    
    if ! [ -f ~/.aws/config ]; then
        if ! [ -f ~/.aws/credentials ]; then
            fail "AWS config not found or CLI not installed. Please run \"aws configure\"."
        fi
    fi
    
    success "aws cli is configured"
}

function check_jq() {
    info "checking if jq is installed..."
    
    if ! [ -x "$(command -v jq)" ]; then
        fail "jq is not installed."
        info "installing jq"
        apt update -y
        apt install jq -y
    fi
    
    success "jq is installed"
}

function check_stack() {
    info "checking if $STACK_NAME exists..."
    
    summaries=$(aws cloudformation list-stacks | jq --arg STACK_NAME "$STACK_NAME" '.StackSummaries |
    .[] | select((.StackName ==
    $STACK_NAME) and ((.StackStatus == "CREATE_COMPLETE") or (.StackStatus == "UPDATE_COMPLETE")))')
    if [ -z "$summaries" ]
    then
        fail "The StackStatus of '$STACK_NAME' is not CREATE_COMPLETE or UPDATE_COMPLETE"
    fi
    
    success "$STACK_NAME exists"
}

check_aws
check_jq
check_stack
deploy

