resource "helm_release" "sonarqube" {
  name       = "sonarqube"
  chart      = "sonarqube"
  repository = "https://SonarSource.github.io/helm-chart-sonarqube"
  version    = "2025.2.0"
  namespace  = kubernetes_namespace.monitoring_namespaces.metadata[0].name

  values = [
    templatefile("${path.module}/charts/sonarqube/values.yaml", {
      RDS_ENDPOINT = local.sonarqube_rds_endpoint
      RDS_USERNAME = local.sonarqube_db_username
      RDS_PASSWORD = local.sonarqube_db_password
      ALB_DNS_NAME = aws_lb.alb.dns_name
    })
  ]

  depends_on = [
    kubernetes_namespace.monitoring_namespaces
  ]
}
