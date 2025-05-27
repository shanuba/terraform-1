provider "aws" {
  alias  = "east"
  region = "us-east-1"
}

provider "aws" {
  alias  = "west"
  region = "us-west-1"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

resource "aws_security_group" "security_1" {
  provider = aws.east
  name     = "security_1"

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags = {
    Name = "websecuritygroup-east"
  }
}

resource "aws_security_group" "security_2" {
  provider = aws.west
  name     = "security_2"

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags = {
    Name = "websecuritygroup-west"
  }
}

resource "aws_instance" "my-ec2-1" {
  provider        = aws.east
  ami             = "ami-0e58b56aa4d64231b"
  instance_type   = var.instance_type
  security_groups = [aws_security_group.security_1.name]
  tags = {
    Name = "terraform1"
  }
}

resource "aws_instance" "my-ec2-2" {
  provider        = aws.west
  ami             = "ami-07706bb32254a7fe5"
  instance_type   = var.instance_type
  security_groups = [aws_security_group.security_2.name]

  tags = {
    Name = "terraform-2"
  }
}

output "instance_ip_east" {
  value = aws_instance.my-ec2-1.public_ip
}

output "instance_ip_west" {
  value = aws_instance.my-ec2-2.public_ip
}
