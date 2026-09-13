## Create VPC dgn satu public subnet
resource "aws_vpc" "devops_vpc" {
  cidr_block = "10.0.0.0/24"
  # enable_dns_support = true
  # enable_dns_hostname = true

  tags = {
    Name = "devops-vpc"
  }
}

## Create public subnet --------------------------------------

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.devops_vpc.id
  cidr_block              = "10.0.0.0/25"
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "devops-public-subnet"
  }
}

## buka jalan keluar subnet publik (+ IGW and route table utk subnet) ------------------

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.devops_vpc.id

  tags = {
    Name = "devops-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.devops_vpc.id
    tags = {
        Name = "devops-public-route"
  }
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}


## Elastic IP bwh private subnet --------------------------------------
resource "aws_eip" "nat" {
  ##vpc = true
  tags = {
    Name = "devops-nat-eip"
  }
}   

## Nat Gateway bwh private subnet ada charges. So pakai bila perlu je ------------
/*
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "devops-nat"
  }

  depends_on = [aws_internet_gateway.igw]
}

*/

## Create private subnet --------------------------------------

resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.devops_vpc.id
  cidr_block              = "10.0.0.128/25"
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "devops-private-subnet"
  }
}

## Private Route Table --------------------------------------
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.devops_vpc.id
  tags = {
    Name = "devops-private-route"
  }
}   

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}




##--------------------------------------------------------------------------------


/*resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "nat-eip"
  }
} */




/*resource "aws_route_table" "private" {
  vpc_id = aws_vpc.devops_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private-rt"
  }
}

 */