#!/bin/bash

CONFIG_FILE="config/cloud-config.yaml"
CLOUD=$(grep "^cloud:" $CONFIG_FILE | awk '{print $2}')

echo "Detected cloud provider: $CLOUD"

# Ensure Terraform is installed
if ! command -v terraform &> /dev/null; then
  echo "❌ Terraform is not installed. Please install Terraform first."
  exit 1
fi

# Switch cloud and apply Terraform
case "$CLOUD" in
  aws)
    echo "✅ Using AWS Terraform module"
    cd infra/terraform/aws || { echo "❌ AWS module directory not found"; exit 1; }
    echo "💡 Fetching AWS EKS Kubeconfig..."
    aws eks update-kubeconfig --region us-east-1 --name <your-cluster-name> || { echo "❌ AWS EKS kubeconfig fetch failed"; exit 1; }
    ;;
  gcp)
    echo "✅ Using GCP Terraform module"
    cd infra/terraform/gcp || { echo "❌ GCP module directory not found"; exit 1; }
    echo "💡 Fetching GCP Kubernetes Engine Kubeconfig..."
    gcloud container clusters get-credentials <your-cluster-name> --region us-central1 || { echo "❌ GCP kubeconfig fetch failed"; exit 1; }
    ;;
  azure)
    echo "✅ Using Azure Terraform module"
    cd infra/terraform/azure || { echo "❌ Azure module directory not found"; exit 1; }
    echo "💡 Fetching Azure AKS Kubeconfig..."
    az aks get-credentials --resource-group <your-resource-group> --name <your-cluster-name> || { echo "❌ Azure AKS kubeconfig fetch failed"; exit 1; }
    ;;
  *)
    echo "❌ Unsupported cloud provider: $CLOUD"
    exit 1
    ;;
esac

# Initialize and apply Terraform
echo "🔄 Running Terraform init and apply..."

# Running terraform init and checking if it succeeds
terraform init
if [ $? -ne 0 ]; then
  echo "❌ Terraform init failed."
  exit 1
fi

# Running terraform apply and checking if it succeeds
terraform apply -auto-approve
if [ $? -eq 0 ]; then
  echo "✅ Terraform applied successfully!"
else
  echo "❌ Terraform apply failed."
  exit 1
fi

