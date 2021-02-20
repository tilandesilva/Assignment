


resource "aws_vpc" main {
  cidr_block = var.vpc_cidr
  instance_tenancy = "default"
  tags = { Name = var.vpc_name }
}


resource "aws_subnet" pub_subnets {
  count = length(var.azs)
  vpc_id = aws_vpc.main.id
  map_public_ip_on_launch = true
  availability_zone = element(var.azs, count.index)
  cidr_block = element(var.pub_subnets_cidr, count.index)
  tags = { Name = "pub_${var.vpc_name}" }
}


resource aws_internet_gateway igw { 
  vpc_id = aws_vpc.main.id
  tags = { Name = "igw_${var.vpc_name}" }
}


resource aws_route_table pub_rt {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "pub_rt_${var.vpc_name}" }
}

resource aws_route_table_association pub_subnet_association {
  count = length(var.azs)
  subnet_id = element(aws_subnet.pub_subnets.*.id, count.index)
  route_table_id = aws_route_table.pub_rt.id
}


resource "aws_key_pair" "ec2-key1" {
  key_name   = "ec2-key1"
  public_key = "${file("/root/.ssh/id_rsa.pub")}"
  }

resource "aws_instance" "web" {
  count = length(var.azs)
  subnet_id = element(aws_subnet.pub_subnets.*.id, count.index)
  ami           = "ami-08e0ca9924195beba"
  instance_type = "t2.micro"
  user_data = "${file("user-data.sh")}"
  tags = {
    Name = "Webserver"
  }
  key_name = "ec2-key1"
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  depends_on = [ aws_security_group.allow_tls]
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}


resource "aws_dynamodb_table" "service-logs-table" {
  name           = "service-logs-table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "DateTime"
  range_key      = "LogDescription"

  attribute {
    name = "DateTime"
    type = "S"
  }

  attribute {
    name = "LogDescription"
    type = "S"
  }


  tags = {
    Name        = "service-logs-table"
  }
}

resource "aws_s3_bucket" "web-server-log-compressed" {
  bucket = "web-server-log-compressed"
  acl    = "private"

  tags = {
    Name        = "log bucket"
    Environment = "Dev"
  }
}

resource "null_resource" "example2" {
  provisioner "local-exec" {
    command = "echo ${aws_instance.web[0].public_ip} >> inventory"
  }
}