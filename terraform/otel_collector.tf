resource "kubernetes_service_account" "otel_collector" {
  metadata {
    name      = "otel-collector-opentelemetry-collector"
    namespace = kubernetes_namespace.monitoring_namespaces.metadata[0].name
  }
  automount_service_account_token = true
}

# Create ClusterRole with required permissions
resource "kubernetes_cluster_role" "otel_collector" {
  metadata {
    name = "otel-collector-role"
  }

  rule {
    api_groups = [""]
    resources  = ["pods", "namespaces"]
    verbs      = ["get", "watch", "list"]
  }

  rule {
    api_groups = ["apps"]
    resources  = ["replicasets"]
    verbs      = ["get", "watch", "list"]
  }
}

# Bind ClusterRole to ServiceAccount
resource "kubernetes_cluster_role_binding" "otel_collector" {
  metadata {
    name = "otel-collector-role-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.otel_collector.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.otel_collector.metadata[0].name
    namespace = kubernetes_namespace.monitoring_namespaces.metadata[0].name
  }
}

resource "helm_release" "otel_collector" {
  name       = "otel-collector"
  repository = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart      = "opentelemetry-collector"
  version    = "0.95.0"
  namespace  = kubernetes_namespace.monitoring_namespaces.metadata[0].name

  values = [
    templatefile("${path.module}/charts/otel-collector/values.yaml", {
      AWS_REGION            = var.aws_region,
      AWS_ACCESS_KEY_ID     = var.aws_access_key_id
      AWS_SECRET_ACCESS_KEY = var.aws_secret_access_key
      AWS_SESSION_TOKEN     = var.aws_session_token
      SERVICE_ACCOUNT_NAME  = kubernetes_service_account.otel_collector.metadata[0].name
    })
  ]

  timeout = 120

  depends_on = [
    kubernetes_namespace.monitoring_namespaces,
    helm_release.prometheus,
    helm_release.loki,
    helm_release.tempo
  ]
}
