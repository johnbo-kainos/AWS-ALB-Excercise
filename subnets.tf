//Subnet Configuration for the VPC - Private and Public Subnets

//Public Subnet in Availibilty Zone A
resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_a_cidr
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}a"

  tags = {
    Name = "instructor-public-alb-subnet-az-a"
  }
}
//Public Subnet in Availibilty Zone B
resource "aws_subnet" "public_subnet_b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_b_cidr
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}b"

  tags = {
    Name = "instructor-public-alb-subnet-az-b"
  }
}

//Private Subnets for the EC2 Instances

//Private Subnet in Availibilty Zone B
resource "aws_subnet" "private_subnet_a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_a_cidr
  availability_zone = "${var.region}a"

  tags = {
    Name = "instructor-private-alb-subnet-az-a"
  }
}

//Private Subnet in Availibilty Zone B
resource "aws_subnet" "private_subnet_b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_b_cidr
  availability_zone = "${var.region}b"

  tags = {
    Name = "instructor-private-alb-subnet-az-b"
  }
}