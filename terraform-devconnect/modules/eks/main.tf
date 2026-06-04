resource "aws_eks_cluster" "main" {
  name     = "${var.project_name}-cluster"
  role_arn = var.cluster_role_arn
  version  = var.cluster_version

  vpc_config {
    subnet_ids             = var.private_subnet_ids
    security_group_ids     = [var.cluster_sg_id]
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-cluster"
    }
  )
}

resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.project_name}-node-group"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.private_subnet_ids

  scaling_config {
    desired_size = 2
    max_size     = 4
    min_size     = 1
  }

  instance_types = ["t3.medium"]
  ami_type       = "AL2_x86_64"
  capacity_type  = "ON_DEMAND"

  update_config {
    max_unavailable = 1
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-node-group"
    }
  )

  depends_on = [
    aws_eks_cluster.main
  ]
}

resource "aws_eks_addon" "ebs_csi" {
  cluster_name = aws_eks_cluster.main.name
  addon_name   = "aws-ebs-csi-driver"

  # Depends on the node group being ready so pods for the CSI driver can be scheduled
  depends_on = [
    aws_eks_node_group.main
  ]
}
