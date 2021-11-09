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
resource "kubectl_manifest" "cors" {
    yaml_body = <<YAML
apiVersion: configuration.konghq.com/v1
config:
  credentials: true
  headers:
  - Accept
  - Accept-Version
  - Content-Length
  - Content-Type
  - x-access-token
  - Access-Control-Allow-Origin
  - userid
  - lastlogintime
  - headers
  - otp
  - accountid
  - emailtype
  - merchantcategorycode
  - transactionid
  methods:
  - GET
  - POST
  - PUT
  origins:
  - https://optimawipro.com
  preflight_continue: false
kind: KongPlugin
metadata:
  annotations:
  name: kong-cors
plugin: cors
YAML
}
resource "kubectl_manifest" "kong_consumer" {
    yaml_body = <<YAML
apiVersion: configuration.konghq.com/v1
kind: KongConsumer
metadata:
  name: jwt-consumer
  annotations:
    kubernetes.io/ingress.class: kong
username: jwt-consumer
credentials:
  - app-admin-jwt
YAML
}
resource "kubectl_manifest" "kong_http-logging" {
    yaml_body = <<YAML
apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  name: http-logging
config:
  path: /dev/stdout
  reopen: false
plugin: file-log
YAML
}
resource "kubectl_manifest" "kong_jwt-plugin" {
    yaml_body = <<YAML
apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  name: jwt-plugin
config:
  key_claim_name: username
  claims_to_verify: 
  - exp
  header_names:
  - x-access-token
plugin: jwt
YAML
}
resource "kubectl_manifest" "kong_rate-limiting" {
    yaml_body = <<YAML
apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  name: rate-limiting
config: 
  minute: 3
  policy: local
  limit_by: ip
plugin: rate-limiting
YAML
}
resource "kubectl_manifest" "kong_secret" {
    yaml_body = <<YAML
apiVersion: v1
kind: Secret
metadata:
  name: app-admin-jwt
type: Opaque
stringData:
  algorithm: HS256
  key: alice
  kongCredType: jwt
  secret: supersecret
YAML
}
