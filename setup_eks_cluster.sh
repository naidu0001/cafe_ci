#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Variables
CLUSTER_NAME="cafe-ci-cd-cluster-second"
REGION="ap-south-1"
NODEGROUP_NAME="cafe-ci-node-group-second"
NODE_TYPE="t3.medium"
NODES=2
NODES_MIN=2
NODES_MAX=4
K8S_VERSION="1.29"

# Step 1: Create EKS Cluster with Managed Node Group
echo "Creating EKS cluster: $CLUSTER_NAME in region: $REGION"
eksctl create cluster \
  --name $CLUSTER_NAME \
  --region $REGION \
  --version $K8S_VERSION \
  --nodegroup-name $NODEGROUP_NAME \
  --node-type $NODE_TYPE \
  --nodes $NODES \
  --nodes-min $NODES_MIN \
  --nodes-max $NODES_MAX \
  --managed

# Step 2: Update kubeconfig for kubectl
echo "Updating kubeconfig for cluster: $CLUSTER_NAME"
aws eks update-kubeconfig --name $CLUSTER_NAME --region $REGION

# Step 3: Verify cluster and nodes
echo "Verifying EKS cluster and nodes"
kubectl get svc
kubectl get nodes
