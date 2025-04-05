resource "helm_release" "grafana" {
  name       = "grafana"
  chart      = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  version    = "8.5.1"
  namespace  = kubernetes_namespace.monitoring_namespaces.metadata[0].name

  values = [
    templatefile("${path.module}/charts/grafana/values.yaml", {
      ALB_DNS_NAME = aws_lb.alb.dns_name
      AWS_REGION = var.aws_region
    })
  ]

  timeout = 120

  depends_on = [
    helm_release.loki,
    helm_release.tempo,
    helm_release.prometheus,
    kubernetes_namespace.monitoring_namespaces
  ]
}
