#!/bin/bash

# Install Istio https://github.com/knative/docs/blob/master/install/Knative-custom-install.md
kubectl apply -f https://github.com/knative/serving/releases/download/v0.4.0/istio-crds.yaml
kubectl apply -f https://github.com/knative/serving/releases/download/v0.4.0/istio.yaml
kubectl label namespace default istio-injection=enabled
# Check with kubectl get pods --namespace istio-system
kubectl apply -f https://github.com/knative/serving/releases/download/v0.4.0/serving.yaml
kubectl apply -f https://github.com/knative/build/releases/download/v0.4.0/build.yaml
kubectl apply -f https://github.com/knative/eventing/releases/download/v0.4.0/release.yaml
kubectl apply -f https://github.com/knative/eventing-sources/releases/download/v0.4.0/release.yaml
kubectl apply -f https://raw.githubusercontent.com/knative/serving/v0.4.0/third_party/config/build/clusterrole.yaml