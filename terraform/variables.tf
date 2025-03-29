variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS Account region"
}

variable "iam_role_name" {
  type        = string
  default     = "LabRole"
  description = "IAM Role Name"
}

variable "aws_access_key_id" {
  description = "AWS Access Key ID"
  sensitive   = true
}

variable "aws_secret_access_key" {
  description = "AWS Secret Access Key"
  sensitive   = true
}

variable "aws_session_token" {
  description = "AWS Session Token"
  sensitive   = true
}

variable "vpc_name" {
  type        = string
  default     = "fiap-hackathon-vpc"
  description = "Custom VPC name"
}

variable "eks_cluster_name" {
  type        = string
  default     = "fiap-hackathon-eks-cluster"
  description = "EKS Cluster name"
}

variable "node_group_name" {
  type        = string
  default     = "fiap-hackathon-node-group"
  description = "EKS Cluster name"
}

variable "alb_name" {
  type        = string
  default     = "fiap-hackathon-alb"
  description = "Application Load Balancer name"
}

variable "nlb_name" {
  type        = string
  default     = "fiap-hackathon-nlb"
  description = "Network Load Balancer name"
}

variable "sonarqube_db_credentials_secret_name" {
  type        = string
  default     = "fiap-hackathon-sonarqube-db-credentials"
  description = "AWS Secrets Manager secret name"
}

variable "loki_memcached_cache" {
  type        = string
  default     = "loki-memcached"
  description = "AWS Elasticache memcached cache name"
}

