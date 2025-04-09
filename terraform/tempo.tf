resource "helm_release" "tempo" {
  name       = "tempo"
  chart      = "tempo"
  repository = "https://grafana.github.io/helm-charts"
  version    = "1.6.1"
  # version    = "1.19.0"
  namespace  = kubernetes_namespace.monitoring_namespaces.metadata[0].name

  values = [
    templatefile("${path.module}/charts/tempo/values.yaml", {
      AWS_REGION      = var.aws_region,
      S3_BUCKET_TEMPO = aws_s3_bucket.tempo.id
    })
  ]

  timeout = 180

  depends_on = [
    aws_s3_bucket.tempo,
    helm_release.prometheus,
    kubernetes_secret.aws_credentials,
    kubernetes_namespace.monitoring_namespaces,
  ]
}
