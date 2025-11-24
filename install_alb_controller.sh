#!/bin/bash
set -e

# Variables
CLUSTER_NAME="cafe-ci-cd-cluster-second"
REGION="ap-south-1"
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
POLICY_NAME="AWSLoadBalancerControllerIAMPolicy"
SERVICE_ACCOUNT="aws-load-balancer-controller"
NAMESPACE="kube-system"

# IAM policy
curl -o iam_policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json
aws iam create-policy \
    --policy-name $POLICY_NAME \
    --policy-document file://iam_policy.json || echo "Policy exists"

# Service account
eksctl create iamserviceaccount \
  --cluster $CLUSTER_NAME \
  --namespace $NAMESPACE \
  --name $SERVICE_ACCOUNT \
  --attach-policy-arn arn:aws:iam::$ACCOUNT_ID:policy/$POLICY_NAME \
  --approve \
  --override-existing-serviceaccounts

# Install via Helm
helm repo add eks https://aws.github.io/eks-charts
helm repo update
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n $NAMESPACE \
  --set clusterName=$CLUSTER_NAME \
  --set serviceAccount.create=false \
  --set serviceAccount.name=$SERVICE_ACCOUNT \
  --set region=$REGION \
  --set vpcId=$(aws eks describe-cluster --name $CLUSTER_NAME --query "cluster.resourcesVpcConfig.vpcId" --output text)

# Verify
kubectl get deployment -n $NAMESPACE aws-load-balancer-controller
