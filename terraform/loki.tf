resource "helm_release" "loki" {
  name       = "loki"
  chart      = "loki"
  repository = "https://grafana.github.io/helm-charts"
  version    = "6.28.0"
  namespace  = kubernetes_namespace.monitoring_namespaces.metadata[0].name

  values = [
    templatefile("${path.module}/charts/loki/values.yaml", {
      LOKI_RULER_S3_BUCKET             = aws_s3_bucket.loki_ruler.id
      LOKI_CHUNK_S3_BUCKET             = aws_s3_bucket.loki_chunk.id
      LOKI_MEMCACHED_CHUNK_CACHE_URL   = local.loki_memcaced_node_endpoints[0]
      LOKI_MEMCACHED_RESULTS_CACHE_URL = local.loki_memcaced_node_endpoints[1]
      AWS_REGION                       = var.aws_region,
      AWS_ACCESS_KEY_ID                = var.aws_access_key_id
      AWS_SECRET_ACCESS_KEY            = var.aws_secret_access_key
      AWS_SESSION_TOKEN                = var.aws_session_token
    })
  ]

  timeout = 120

  depends_on = [
    kubernetes_namespace.monitoring_namespaces,
    kubernetes_secret.aws_credentials,
    aws_s3_bucket.loki_ruler,
    aws_s3_bucket.loki_chunk,
  ]
}
