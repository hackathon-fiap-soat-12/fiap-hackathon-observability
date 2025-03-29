resource "helm_release" "fluent_bit" {
  name       = "fluent-bit"
  repository = "https://fluent.github.io/helm-charts"
  chart      = "fluent-bit"
  namespace  = kubernetes_namespace.monitoring_namespaces.metadata[0].name
  version    = "0.48.9"

  values = [
    file("${path.module}/charts/fluentbit/values.yaml")
  ]

  timeout = 120

  depends_on = [
    kubernetes_namespace.monitoring_namespaces,
    helm_release.otel_collector
  ]
}