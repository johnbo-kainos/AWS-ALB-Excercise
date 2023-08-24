
// Data request that will get the AMI of the Ubuntu 20.04 LTS OS for the defined AWS Region
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-lunar-23.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

// ECS Apache Web Frontend servers that are created in the private subnet in Availibilty Zone A
resource "aws_instance" "web_zone_a" {
  count         = var.instance_count
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  subnet_id       = aws_subnet.private_subnet_a.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = <<-EOF
  #!/bin/bash
  echo "*** Installing apache2"
  sudo apt update -y
  sudo apt install apache2 -y
  echo "*** Completed Installing apache2"
  echo "<h1>loading from $(hostname -f)..</h1>" > /var/www/html/index.html
  EOF

  tags = {
    Name = "${var.naming_prefix}-webserver-zone-a-${count.index}"
  }

  lifecycle {
    create_before_destroy = true
  }

}

// ECS Apache Web Frontend servers that are created in the private subnet in Availibilty Zone B
resource "aws_instance" "web_zone_b" {
  count         = var.instance_count
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  subnet_id       = aws_subnet.private_subnet_b.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = <<-EOF
  #!/bin/bash
  echo "*** Installing apache2"
  sudo apt update -y
  sudo apt install apache2 -y
  echo "*** Completed Installing apache2"
  echo "<h1>loading from $(hostname -f)..</h1>" > /var/www/html/index.html
  EOF

  tags = {
    Name = "${var.naming_prefix}-webserver-zone-b-${count.index}"
  }

  lifecycle {
    create_before_destroy = true
  }

}