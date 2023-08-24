//Security Group rule that is applied to the ALB
resource "aws_security_group" "alb_sg" {
  name        = "${var.naming_prefix}-alb-sg"
  description = "Security group for ALB"
  vpc_id      = aws_vpc.vpc.id

  // Allow port 443 (HTTPS) from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] // Allow traffic from anywhere
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp" // Allow all Port 80 traffic to the private subnets containing the EC2 instances
    cidr_blocks = [var.private_subnet_a_cidr, var.private_subnet_b_cidr]
  }

}

resource "aws_security_group" "ec2_sg" {
  name        = "${var.naming_prefix}-ec2-sg"
  description = "Security group for EC2 instances"
  vpc_id      = aws_vpc.vpc.id

  // Ingress rules to allow incoming traffic from the public subnets (ALB traffic)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.public_subnet_a_cidr, var.public_subnet_b_cidr]
  }

  // Allow all outgoing traffic to Internet and public subnets
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" // Allow all outgoing traffic
    cidr_blocks = ["0.0.0.0/0", var.public_subnet_a_cidr, var.public_subnet_b_cidr]
  }

}
