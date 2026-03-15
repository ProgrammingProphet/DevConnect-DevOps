output "cluster_sg_id" {
  value = aws_security_group.cluster_sg.id
}

output "node_sg_id" {
  value = aws_security_group.node_sg.id
}

output "lb_sg_id" {
  value = aws_security_group.lb_sg.id
}

output "cluster_iam_role_arn" {
  value = aws_iam_role.cluster_role.arn
}

output "node_iam_role_arn" {
  value = aws_iam_role.node_role.arn
}
