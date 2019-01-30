
#############################################################################
#
#   GKE Example Deployment
#
#   https://cloud.google.com/kubernetes-engine/docs/quickstart
#   https://kubernetes.io/docs/reference/kubectl/overview/
#   https://cloud.google.com/solutions/best-practices-for-building-containers
#
#############################################################################



#############################################################################
#
#   Variables
#
#############################################################################
gke_cluster_name=gke_cluster_z1
gke_app_name=gke_app_z1
gke_app_image=gcr.io/google-samples/hello-app:1.0


#############################################################################
#
#   Deployment
#
#############################################################################

# Create a GKE Cluster
gcloud container clusters create $gke_cluster_name


# Get authentication credentials for the cluster
# After creating the cluster, you need to get authentication credentials to interact with the cluster
gcloud container clusters get-credentials $gke_cluster_name


# Deploy an application to the cluster
kubectl run $gke_app_name --image $gke_app_image --port 8080


# Exposing the Deployment
# After deploying the application, you need to expose it so that users can access it.
# You can expose your application by creating a Service, a Kubernetes resource that exposes your application to external traffic.
# --port initializes public port 80 to the Internet and
# --target-port routes the traffic to port 8080 of the application
kubectl expose deployment $gke_app_name --type LoadBalancer --port 80 --target-port 8080


#############################################################################
#
#   Status and Diagnosis
#
#############################################################################

# Inspect the app
kubectl get service $gke_app_name


#############################################################################
#
#   Cleanup
#
#############################################################################

# Delete a service
#kubectl delete service $gke_app_name


# Delete a service
#gcloud container clusters delete $gke_cluster_name



#ZEND
