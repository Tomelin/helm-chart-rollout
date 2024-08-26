#!/bin/bash




kubernetes_host="$(kubectl exec hashicorp-vault-0 -n vault -- printenv | grep KUBERNETES_PORT_443_TCP_ADDR | cut -f 2- -d "=" | tr -d " ")"
echo "kubernetes_host ${kubernetes_host}"

kubernetes_port="443"
echo "kubernetes_port ${kubernetes_port}"

kubernetes_cert="$(kubectl config view --raw --minify --flatten -o jsonpath='{.clusters[].cluster.certificate-authority-data}' | base64 --decode)"
echo "kubernetes_cert ${kubernetes_cert}"

account_token="$(kubectl get secret -n vault vault-token -o jsonpath='{.data.token} {"\n"}' | base64 -d)"
echo "account_token ${account_token}"