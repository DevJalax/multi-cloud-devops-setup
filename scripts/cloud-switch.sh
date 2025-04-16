#!/bin/bash

CONFIG_FILE="config/cloud-config.yaml"
CLOUD=$(grep "^cloud:" $CONFIG_FILE | awk '{print $2}')

echo "Detected cloud provider: $CLOUD"

case "$CLOUD" in
  aws)
    echo "Using AWS Terraform module"
    cd infra/terraform/aws
    ;;
  gcp)
    echo "Using GCP Terraform module"
    cd infra/terraform/gcp
    ;;
  azure)
    echo "Using Azure Terraform module"
    cd infra/terraform/azure
    ;;
  *)
    echo "Unsupported cloud provider: $CLOUD"
    exit 1
    ;;
esac

terraform init
terraform apply -auto-approve
