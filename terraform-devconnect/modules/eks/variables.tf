variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.30"
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for EKS and Node Groups"
  type        = list(string)
}

variable "cluster_role_arn" {
  description = "IAM Role ARN for EKS Cluster"
  type        = string
}

variable "node_role_arn" {
  description = "IAM Role ARN for Worker Nodes"
  type        = string
}

variable "cluster_sg_id" {
  description = "Security Group ID for EKS Cluster"
  type        = string
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
  default     = {}
}
