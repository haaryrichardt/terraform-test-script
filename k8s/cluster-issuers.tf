resource "kubectl_manifest" "clusterissuer-kong-dns" {
    yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-kong
spec:
  acme:
    email: <enter your email id>
    privateKeySecretRef:
      name: letsencrypt-kong
    server: https://acme-v02.api.letsencrypt.org/directory
    solvers:
    - dns01:
        cloudDNS:
          project: <GCP project name >
          serviceAccountSecretRef:
            name: clouddns-dns01-solver-svc-acct
            key: <enter json file name of service account>
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
    email:  <enter your email id>
    privateKeySecretRef:
      name: letsencrypt-gce
    server: https://acme-v02.api.letsencrypt.org/directory
    solvers:
    - dns01:
        cloudDNS:
          project: <GCP project name >
          serviceAccountSecretRef:
            name: clouddns-dns01-solver-svc-acct
            key: <enter json file name of service account>
YAML
}