resource "kubectl_manifest" "clusterissuer-nginx" {
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
    - http01:
        ingress:
            class: ingress-gce
YAML
}

resource "kubectl_manifest" "clusterissuer-kong" {
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
    - http01:
        ingress:
          class: kong
YAML
}
