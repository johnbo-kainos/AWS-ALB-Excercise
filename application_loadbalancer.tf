// Application Loadbalancer configuration

// Application LB creation and assignment to both public subnets
resource "aws_lb" "alb" {
  name               = "instructor-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_b.id]
  security_groups    = [aws_security_group.alb_sg.id]

  tags = {
    Name = "instructor-application-loadbalancer"
  }
}

// Application LB listener - setting the ALB to listen for connections on Port 80 (HTTP).
// Traffic forwarded to target group using arn
resource "aws_lb_listener" "web_frontend_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_frontend_tg.arn
  }
}

// Creation of Target Group for HTTP traffic
resource "aws_lb_target_group" "web_frontend_tg" {
  name     = "instructor-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    path                = "/index.html"
    port                = 80
    interval            = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
  }

}

//Attaches the EC2 instances to the target group
resource "aws_lb_target_group_attachment" "web_frontend_tg_attachment" {

  count = length(local.web_instance_ids)

  target_group_arn = aws_lb_target_group.web_frontend_tg.arn
  target_id        = local.web_instance_ids[count.index]

}