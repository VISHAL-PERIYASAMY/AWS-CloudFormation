STACK_NAME="Deploy-${stage}-base-infra"

function deploy() {
    info "deploying stack ${STACK_NAME}..."
    ip_range = 102
    pwd
    aws cloudformation deploy  --template-file ./resources/create-s3.yml --stack-name $STACK_NAME \
     --parameter-overrides stage=${stage} IpRange=${ip_range}  
}

deploy
