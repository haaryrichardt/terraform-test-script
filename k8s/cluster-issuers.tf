# resource "kubectl_manifest" "clusterissuer-nginx" {
#     yaml_body = <<YAML
# apiVersion: cert-manager.io/v1
# kind: ClusterIssuer
# metadata:
#   name: letsencrypt-gce
# spec:
#   acme:
#     email: mannur.reddy@wipro.com
#     privateKeySecretRef:
#       name: letsencrypt-gce
#     server: https://acme-v02.api.letsencrypt.org/directory
#     solvers:
#     - http01:
#         ingress:
#             class: ingress-gce
# YAML
# }

# resource "kubectl_manifest" "clusterissuer-kong" {
#     yaml_body = <<YAML
# apiVersion: cert-manager.io/v1
# kind: ClusterIssuer
# metadata:
#   name: letsencrypt-kong
# spec:
#   acme:
#     email: mannur.reddy@wipro.com
#     privateKeySecretRef:
#       name: letsencrypt-kong
#     server: https://acme-v02.api.letsencrypt.org/directory
#     solvers:
#     - http01:
#         ingress:
#           class: kong
# YAML
# }

resource "kubectl_manifest" "clusterissuer-kong-dns" {
    yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-kong
spec:
  acme:
    email: mannur.reddy@wipro.com
    privateKeySecretRef:
      name: letsencrypt-kong
    server: https://acme-v02.api.letsencrypt.org/directory
    solvers:
    - dns01:
        cloudDNS:
          project: wipro-gcp-kubernetes-poc
          serviceAccountSecretRef:
            name: clouddns-dns01-solver-svc-acct
            key: wipro-gcp-kubernetes-poc-f67be0dcaaf8.json
YAML
}

resource "kubectl_manifest" "clusterissuer-nginx-dns" {
    yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-gce
spec:
  acme:
    email: mannur.reddy@wipro.com
    privateKeySecretRef:
      name: letsencrypt-gce
    server: https://acme-v02.api.letsencrypt.org/directory
    solvers:
    - dns01:
        cloudDNS:
          project: wipro-gcp-kubernetes-poc
          serviceAccountSecretRef:
            name: clouddns-dns01-solver-svc-acct
            key: wipro-gcp-kubernetes-poc-f67be0dcaaf8.json
YAML
}