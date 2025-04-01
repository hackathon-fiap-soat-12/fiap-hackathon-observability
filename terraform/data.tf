data "aws_caller_identity" "current" {}

data "aws_iam_role" "lab_role" {
  name = var.iam_role_name
}

data "aws_vpc" "selected_vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnets" "private_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected_vpc.id]
  }

  filter {
    name   = "tag:Environment"
    values = ["private"]
  }
}

data "aws_subnets" "public_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected_vpc.id]
  }

  filter {
    name   = "tag:Environment"
    values = ["public"]
  }
}

data "aws_subnet" "selected_private_subnets" {
  for_each = toset(data.aws_subnets.private_subnets.ids)
  id       = each.value
}

data "aws_subnet" "selected_public_subnets" {
  for_each = toset(data.aws_subnets.public_subnets.ids)
  id       = each.value
}

data "aws_eks_cluster" "eks_cluster" {
  name = var.eks_cluster_name
}

data "aws_eks_cluster_auth" "eks_cluster" {
  name = data.aws_eks_cluster.eks_cluster.name
}

data "aws_instances" "eks_worker_instances" {
  filter {
    name   = "tag:eks:nodegroup-name"
    values = [var.node_group_name]
  }
}

data "aws_ip_ranges" "api_gateway" {
  services = ["API_GATEWAY"]
  regions  = [var.aws_region]
}

data "aws_ssm_parameter" "sonarqube_rds_endpoint" {
  name = "/fiap-hackathon/sonarqube-rds-endpoint"
}

data "aws_secretsmanager_secret_version" "sonarqube_db_secret_version" {
  secret_id = var.sonarqube_db_credentials_secret_name
}

data "aws_ssm_parameter" "loki_elasticache_endpoint" {
  name = "/fiap-hackathon/loki-elasticache-endpoint"
}

data "aws_elasticache_cluster" "loki_memcached" {
  cluster_id = var.loki_memcached_cache
}
