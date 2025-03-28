locals {
  availability_zones           = ["${var.aws_region}a", "${var.aws_region}b"]
  db_secrets                   = jsondecode(data.aws_secretsmanager_secret_version.sonarqube_db_secret_version.secret_string)
  sonarqube_db_username        = local.db_secrets["db_username"]
  sonarqube_db_password        = local.db_secrets["db_password"]
  sonarqube_rds_endpoint       = data.aws_ssm_parameter.sonarqube_rds_endpoint.value
  loki_memcaced_node_endpoints = [for node in data.aws_elasticache_cluster.loki_memcached.cache_nodes : "${node.address}:${node.port}"]
}
