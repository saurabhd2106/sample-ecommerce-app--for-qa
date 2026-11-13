#!/usr/bin/env bash
# Installs Envoy Gateway (and the Gateway API CRDs it bundles) into the current kubectl context.
#
# Usage:
#   ./k8s_solution_ag/install-envoy-gateway.sh
#   kubectl apply -f k8s_solution_ag/00-namespace.yml
#   kubectl apply -f k8s_solution_ag/
#   kubectl -n oakline get gateway oakline-gateway   # ADDRESS column is the public IP
set -euo pipefail

ENVOY_GATEWAY_VERSION="${ENVOY_GATEWAY_VERSION:-v1.10.0}"

helm upgrade --install eg oci://docker.io/envoyproxy/gateway-helm \
  --version "${ENVOY_GATEWAY_VERSION}" \
  --namespace envoy-gateway-system \
  --create-namespace \
  --set deployment.replicas=2

kubectl wait --for=condition=Available deployment/envoy-gateway \
  --namespace envoy-gateway-system \
  --timeout=5m
