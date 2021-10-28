resource "kubectl_manifest" "clusterissuer-nginx" {
    yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-dev-nginx
spec:
  acme:
    email: mannur.reddy@wipro.com
    privateKeySecretRef:
      name: letsencrypt-dev-nginx
    server: https://acme-v02.api.letsencrypt.org/directory
    solvers:
    - http01:
        ingress:
            class: nginx
YAML
}

resource "kubectl_manifest" "clusterissuer-kong" {
    yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-dev-kong
spec:
  acme:
    email: mannur.reddy@wipro.com
    privateKeySecretRef:
      name: letsencrypt-dev-kong
    server: https://acme-v02.api.letsencrypt.org/directory
    solvers:
    - http01:
        ingress:
          class: kong
YAML
}