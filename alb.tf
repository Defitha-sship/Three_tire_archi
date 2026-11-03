#################################
# TARGET GROUP
#################################

resource "aws_lb_target_group" "app_tg" {

  name = "app-target-group"

  port = 80

  protocol = "HTTP"

  vpc_id = aws_vpc.main.id

  health_check {

    enabled = true

    path = "/"

    protocol = "HTTP"

    matcher = "200"

    interval = 30

    timeout = 5

    healthy_threshold = 2

    unhealthy_threshold = 2
  }

  tags = merge(
    local.common_tags,
    {
      Name = "app-target-group"
    }
  )
}
#################################
# APPLICATION LOAD BALANCER
#################################

resource "aws_lb" "app_alb" {

  name = "application-alb"

  internal = false

  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb_sg.id
  ]

  subnets = [
    aws_subnet.public.id,
    aws_subnet.public_2.id
  ]
  enable_deletion_protection = false

  tags = merge(
    local.common_tags,
    {
      Name = "application-alb"
    }
  )
}
#################################
# HTTP LISTENER
#################################

resource "aws_lb_listener" "http" {

  load_balancer_arn = aws_lb.app_alb.arn

  port = 80

  protocol = "HTTP"

  default_action {

    type = "forward"

    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

#################################
# ASG ATTACHMENT
#################################

resource "aws_autoscaling_attachment" "app_asg_attachment" {

  autoscaling_group_name = aws_autoscaling_group.app.name

  lb_target_group_arn = aws_lb_target_group.app_tg.arn
}