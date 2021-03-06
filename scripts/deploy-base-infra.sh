STACK_NAME="Deploy-${stage}-base-infra"

RED='\033[0;31m'
MESSAGE='\033[0m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'

function fail(){
    echo -e "${RED}Failure: $* ${MESSAGE}"
    exit 1
}

function info() {
    echo -e "${BLUE} $* ${MESSAGE}"
}

function success() {
    echo -e "${GREEN} $* ${MESSAGE}"
}

function deploy() {
    info "Deploying stack ${STACK_NAME}..."
    ip_range="102."
    aws cloudformation deploy  --template-file ./resources/base-infra.yml --stack-name $STACK_NAME  --parameter-overrides BastionKeyName="sample-${stage}-kp" sampleenvironment="${stage}" IpRange=${ip_range} BastionKeyName="AWS-CloudFormation"
    success "Deployement Success on ${STACK_NAME}..."
}

deploy

