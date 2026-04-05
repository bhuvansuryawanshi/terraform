output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "cluster_id" {
  value = aws_ecs_cluster.ecs-cluster.id
}
