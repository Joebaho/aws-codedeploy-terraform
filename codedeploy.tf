# CodeDeploy Application
resource "aws_codedeploy_app" "web_app" {
  name             = "${var.project_name}-app"
  compute_platform = "Server"
}
resource "aws_codedeploy_deployment_group" "web_dg" {
  app_name              = aws_codedeploy_app.web_app.name
  deployment_group_name = "${var.project_name}-dg"
  service_role_arn      = aws_iam_role.codedeploy_role.arn
  autoscaling_groups    = [aws_autoscaling_group.web_asg.name]

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "IN_PLACE"
  }

  load_balancer_info {
    target_group_info {
      name = aws_lb_target_group.web_tg.name
    }
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
  # Add EC2 tag filters to identify instances
  ec2_tag_filter {
    key   = "Name"
    type  = "KEY_AND_VALUE"
    value = "${var.project_name}-web-app"
  }
}
resource "aws_codedeploy_deployment_config" "foo" {
  deployment_config_name = "test-deployment-config"

  minimum_healthy_hosts {
    type  = "HOST_COUNT"
    value = 2
  }
}