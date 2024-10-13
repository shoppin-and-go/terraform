resource "aws_ecs_service" "api" {
  name            = var.service_api_name
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.api.arn
  desired_count   = 1
  launch_type = "EC2"
  force_new_deployment = true

  depends_on = [aws_instance.api_server]
}
