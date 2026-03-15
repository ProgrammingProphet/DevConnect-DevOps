module "vpc" {
  source             = "./modules/vpc"
  project_name       = var.project_name
  vpc_cidr           = var.vpc_cidr
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  availability_zones = var.availability_zones
  tags               = var.tags
}

module "security" {
  source       = "./modules/security"
  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
  tags         = var.tags
}

module "eks" {
  source             = "./modules/eks"
  project_name       = var.project_name
  cluster_version    = var.cluster_version
  private_subnet_ids = module.vpc.private_subnet_ids
  cluster_role_arn   = module.security.cluster_iam_role_arn
  node_role_arn      = module.security.node_iam_role_arn
  cluster_sg_id      = module.security.cluster_sg_id
  tags               = var.tags

  depends_on = [
    module.vpc,
    module.security
  ]
}
