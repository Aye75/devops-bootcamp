## Security Group for Public -------- #
resource "aws_security_group" "public" {
  name   = "devops-public-sg"
  vpc_id = aws_vpc.devops_vpc.id
  tags = { Name = "public-sg" }
}

resource "aws_vpc_security_group_ingress_rule" "public_http" {
  security_group_id = aws_security_group.public.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "public_outbound" {
  security_group_id = aws_security_group.public.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

/* 
esource "aws_vpc_security_group_ingress_rule" "public_https" {
  security_group_id = aws_security_group.public.id
  cidr_ipv4          = "0.0.0.0/0"
  ip_protocol         = "tcp"
  from_port           = 443
  to_port             = 443
}

resource "aws_vpc_security_group_ingress_rule" "public_ssh" {
  security_group_id = aws_security_group.public.id
  cidr_ipv4          = "0.0.0.0/0" # TODO: restrict to your admin IP/CIDR before apply
  ip_protocol         = "tcp"
  from_port           = 22
  to_port             = 22
}
*/


## Security Group for Private -------- #
/*
resource "aws_security_group" "private" {
  name   = "private-sg"
  vpc_id = aws_vpc.devops_vpc.id
  tags   = { Name = "private-sg" }
}

resource "aws_vpc_security_group_ingress_rule" "private_ssh_from_public" {
  security_group_id           = aws_security_group.private.id
  referenced_security_group_id = aws_security_group.public.id
  ip_protocol                  = "tcp"
  from_port                    = 22
  to_port                      = 22
}

resource "aws_vpc_security_group_ingress_rule" "private_internal" {
  security_group_id = aws_security_group.private.id
  cidr_ipv4          = aws_vpc.devops_vpc.cidr_block
  ip_protocol         = "tcp"
  from_port           = 0
  to_port             = 65535
}

resource "aws_vpc_security_group_egress_rule" "private_outbound" {
  security_group_id = aws_security_group.private.id
  cidr_ipv4          = "0.0.0.0/0"
  ip_protocol         = "-1"
}
*/