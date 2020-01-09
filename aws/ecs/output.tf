output "ecs_id" {
  value = aws_ecs_cluster.this.id
}

output "ecs_arn" {
  value = aws_ecs_cluster.this.arn
}

output "ecs_name" {
  value = module.ecs_cluster_label.id
}
