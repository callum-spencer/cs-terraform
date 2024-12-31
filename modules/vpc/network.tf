resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name        = "${var.environment}-vpc"
    Product     = var.product_name
    Subproduct  = var.project_name
    Environment = var.environment
    Accountable = "Example User"
    Dept        = "DevOpsing"
    Function    = "VPC for the ${var.environment} environment for ${var.project_name}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name        = "${var.environment}-igw"
    Product     = var.product_name
    Subproduct  = var.project_name
    Environment = var.environment
    Accountable = "Example User"
    Dept        = "DevOpsing"
    Function    = "Internet Gateway for the ${var.environment} environment for ${var.project_name}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name        = "${var.environment}-public-rt"
    Product     = var.product_name
    Subproduct  = var.project_name
    Environment = var.environment
    Accountable = "Example User"
    Dept        = "DevOpsing"
    Function    = "Public Route Table for the ${var.environment} environment for ${var.project_name}"
  }
}

resource "aws_subnet" "public" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.public_subnet_cidrs, count.index)
  availability_zone = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.environment}-public-subnet-${count.index}"
    Product     = var.product_name
    Subproduct  = var.project_name
    Environment = var.environment
    Accountable = "Example User"
    Dept        = "DevOpsing"
    Function    = "Public Subnet ${count.index} for the ${var.environment} environment for ${var.project_name}"
  }
}

resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
  tags = {
    Name        = "${var.environment}-nat-gateway"
    Product     = var.product_name
    Subproduct  = var.project_name
    Environment = var.environment
    Accountable = "Example User"
    Dept        = "DevOpsing"
    Function    = "NAT Gateway for the ${var.environment} environment for ${var.project_name}"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name        = "${var.environment}-private-rt"
    Product     = var.product_name
    Subproduct  = var.project_name
    Environment = var.environment
    Accountable = "Example User"
    Dept        = "DevOpsing"
    Function    = "Private Route Table for the ${var.environment} environment for ${var.project_name}"
  }
}

resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.private_subnet_cidrs, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name        = "${var.environment}-private-subnet-${count.index}"
    Product     = var.product_name
    Subproduct  = var.project_name
    Environment = var.environment
    Accountable = "Example User"
    Dept        = "DevOpsing"
    Function    = "Private Subnet ${count.index} for the ${var.environment} environment for ${var.project_name}"
  }
}

resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}