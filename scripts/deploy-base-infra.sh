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


deploy

