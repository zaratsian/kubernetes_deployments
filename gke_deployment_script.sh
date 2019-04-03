
#########################################################
#
#   GKE Deployment Script
#
#########################################################


#########################################################
#  Variables
#########################################################

export project_id=$(gcloud info --format='value(config.project)')
export gcp_zone=us-central1-a
export gke_cluster_name=gke-cluster-z1


#########################################################
#  Initialization
#########################################################

gcloud config set compute/zone $gcp_zone


#########################################################
#  Create GKE Cluster
#########################################################

# 4 Types of GKE Clusters
#       1) Zonal Cluster    - Runs in one or more compute zones within a region
#       2) Regional Cluster - Runs three cluster masters across three compute zones
#       3) Private Cluster  - Zonal or Regional cluster which hides its cluster master and nodes from the public
#       4) Alpha Cluster    - Zonal or Regional cluster that runs with alpha Kubernetes features

# Create Zonal Cluster
gcloud container clusters create $gke_cluster_name \
    --zone $gcp_zone \
    --machine-type n1-standard-1 \
    --num-nodes 3

# Authenticate to the Cluster
gcloud container clusters get-credentials $gke_cluster_name


#########################################################
#  Deploy Container to GKE Cluster
#########################################################

# List API Versions with this cmd: kubectl api-versions

echo "apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: 3
  selector:
    matchLabels:
      run: my-app
  template:
    metadata:
      labels:
        run: my-app
    spec:
      containers:
      - name: hello-app
        image: gcr.io/google-samples/hello-app:1.0
" > config.yaml

# Create Deployment
kubectl apply -f config.yaml


#########################################################
#  Get GKE Status
#########################################################

kubectl cluster-info

kubectl get deployments

kubectl get services

kubectl get pods


#########################################################
#  Expose App as Service / LoadBalancer
#########################################################

# There are 5 types of Services:
#       1) ClusterIP (default)
#       2) NodePort             - Expose port to listen on
#       3) LoadBalancer         - Expose external IP as LB
#       4) ExternalName
#       5) Headless

# There are 2 options for exposing services:
#       1) Use a .yaml to specify the configs for the service
#       2) Use the command, kubectl expose deployment ...

kubectl expose deployment my-app \
    --name my-gke-service \
    --type LoadBalancer \
    --protocol TCP \
    --port 80 \
    --target-port 8080



#ZEND
