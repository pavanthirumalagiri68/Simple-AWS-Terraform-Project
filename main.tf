

// Step - 1 ----- Creating VPC  WITH CIDR BLOCK OF 10.0.0.0/16 -------- //

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "test"
  }
}

// Create the public subnet with CIDR 10.0.1.0/24 above VPC //

resource "aws_subnet" "public_subnet" {
  vpc_id                   = aws_vpc.main.id
  cidr_block               = "10.0.1.0/24"
  availability_zone        = "ap-south-1a"
  map_public_ip_on_launch  = "true"

  tags = {
    Name = "Public-Subnet"
  }
}

// Create the private subnet with CIDR 10.0.2.0/24 above VPC //

resource "aws_subnet" "private_subnet" {
  vpc_id      = aws_vpc.main.id
  cidr_block  = "10.0.2.0/24"
  availability_zone =  "ap-south-1a"

  tags = {
    Name = "Private-Subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "myigw"
  }
}

// Here Our Next step is to create the Route table for the public subnet and associate with it. The route table should route to the internet gateway. //

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "route-table"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.main.id
}

resource "aws_security_group" "ssh_access" {
  name_prefix = "ssh_access"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
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
}

resource "aws_instance" "ubuntu" {
  ami           = "ami-0f5ee92e2d63afc18"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.ssh_access.id]

  tags = {
    Name = "apache-webserver"
  }

  user_data = file("userdata.sh")
}
