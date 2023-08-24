// Define the public route table for public subnets. Traffic leaving the VPC is sent to the Internet Gateway
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.int_gw.id
  }
  tags = {
    Name = "${var.naming_prefix}-public-route-table"
  }
}

// Assign the public route table to the public subnet in Availibilty Zone A
resource "aws_route_table_association" "public_route_table_association_a" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_route_table.id
}

// Assign the public route table to the public subnet in Availibilty Zone B
resource "aws_route_table_association" "public_route_table_association_b" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.public_route_table.id
}


// Define the private route table for private subnets in Availibilty Zone A. 
// Traffic leaving the VPC is sent to the NAT Gateway so that the EC2 instances can connect out to the internet
resource "aws_route_table" "private_route_table_a" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw_zone_a.id
  }
  tags = {
    Name = "${var.naming_prefix}-private-route-table-a"
  }
}

// Assign the private route table to the private subnet in Availibilty Zone A
resource "aws_route_table_association" "private_route_table_association_a" {
  subnet_id      = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.private_route_table_a.id
}

// Define the private route table for private subnets in Availibilty Zone B. 
// Traffic leaving the VPC is sent to the NAT Gateway so that the EC2 instances can connect out to the internet
resource "aws_route_table" "private_route_table_b" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw_zone_b.id
  }
  tags = {
    Name = "${var.naming_prefix}-private-route-table-b"
  }
}

// Assign the private route table to the private subnet in Availibilty Zone B
resource "aws_route_table_association" "private_route_table_association_b" {
  subnet_id      = aws_subnet.private_subnet_b.id
  route_table_id = aws_route_table.private_route_table_b.id
}