# VPC
##############################

resource "aws_vpc" "main" { # Create vpc, Terraform reference name = main

  cidr_block = var.vpc_cidr # vpc_cidr ip

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-vpc"
    }
  )
}


# PUBLIC SUBNET
##############################

resource "aws_subnet" "public" {

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = merge(
    local.common_tags,
    {
      Name = "public-subnet"
    }
  )
}
resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-2"
  }
}



# PRIVATE APP SUBNET
##############################

resource "aws_subnet" "private_app" {

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_app_subnet_cidr
  availability_zone = "ap-south-1b"

  tags = merge(
    local.common_tags,
    {
      Name = "private-app-subnet"
    }
  )
}


# PRIVATE DB SUBNET
##############################

resource "aws_subnet" "private_db" {

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_db_subnet_cidr
  availability_zone = "ap-south-1c"

  tags = merge(
    local.common_tags,
    {
      Name = "private-db-subnet"
    }
  )
}
resource "aws_subnet" "private_db_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "private-db-subnet-2"
  }
}

# INTERNET GATEWAY
##############################

resource "aws_internet_gateway" "igw" { #create a ig

  vpc_id = aws_vpc.main.id # attach to vpc

  tags = merge(
    local.common_tags,
    {
      Name = "main-igw"
    }
  )
}

# ELASTIC IP
##############################

resource "aws_eip" "nat_eip" {

  domain = "vpc"

  tags = merge(
    local.common_tags,
    {
      Name = "nat-eip"
    }
  )
}

# NAT GATEWAY
##############################

resource "aws_nat_gateway" "nat" {

  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public.id

  depends_on = [
    aws_internet_gateway.igw
  ]

  tags = merge(
    local.common_tags,
    {
      Name = "nat-gateway"
    }
  )
}


# PUBLIC ROUTE TABLE
##############################

resource "aws_route_table" "public_rt" {

  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0" #any dest on internet
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(
    local.common_tags,
    {
      Name = "public-route-table"
    }
  )
}

#connection bw subnet and route table
resource "aws_route_table_association" "public_assoc" {

  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table_association" "public_assoc_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public_rt.id
}

# PRIVATE ROUTE TABLE
##############################

resource "aws_route_table" "private_rt" {

  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = merge(
    local.common_tags,
    {
      Name = "private-route-table"
    }
  )
}
resource "aws_route_table_association" "private_app_assoc" {

  subnet_id      = aws_subnet.private_app.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_db_assoc" {

  subnet_id      = aws_subnet.private_db.id
  route_table_id = aws_route_table.private_rt.id
}