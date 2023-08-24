//Internet Gateway to allow traffic into and out of the public subnets
resource "aws_internet_gateway" "int_gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "instructor-alb-igw"
  }
}

//Elastic IP address is required for the NAT Gateway in Availibiltiy Zone A
resource "aws_eip" "nat_gw_eip_a" {
  domain = "vpc"

  tags = {
    Name = "instructor-alb-ngw-eip-a"
  }
}

//Elastic IP address is required for the NAT Gateway in Availibiltiy Zone B
resource "aws_eip" "nat_gw_eip_b" {
  domain = "vpc"

  tags = {
    Name = "instructor-alb-ngw-eip-b"
  }
}

//NAT Gateway for EC2 Instances in Availibiltiy Zone A (Private Subnet 1) to connect out to the internet
resource "aws_nat_gateway" "nat_gw_zone_a" {
  allocation_id = aws_eip.nat_gw_eip_a.id
  subnet_id     = aws_subnet.public_subnet_a.id

  tags = {
    Name = "instructor-alb-ngw-az-a"
  }

  // To ensure proper ordering, it is recommended to add an explicit dependency on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.int_gw]
}

//NAT Gateway for EC2 Instances in Availibiltiy Zone B (Private Subnet 2) to connect out to the internet
resource "aws_nat_gateway" "nat_gw_zone_b" {
  allocation_id = aws_eip.nat_gw_eip_b.id
  subnet_id     = aws_subnet.public_subnet_b.id

  tags = {
    Name = "instructor-alb-ngw-az-b"
  }

  // To ensure proper ordering, it is recommended to add an explicit dependency on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.int_gw]
}
