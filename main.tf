provider "aws" {
    profile = "default"
    region  = "eu-west-1"
}
 
# create the VPC
resource "aws_vpc" "jon_vpc" {
    cidr_block  =   "10.10.20.0/24" #Jon-lee 10.10.20.0/24 Akashni 10.10.30.0/24 Karabo 10.10.40.0/24
    enable_dns_support   = true
    enable_dns_hostnames = true
    tags = {
        Name = "jon_vpc"
        accountName = var.accountName
        applicationName = var.applicationName
        costCenter = var.costCenter
        costCenterOwner = var.costCenterOwner
        environment = var.environment
    }
}
 
# create the Subnet
resource "aws_subnet" "jon_subnet" {
    vpc_id      =  aws_vpc.jon_vpc.id 
    cidr_block  =  "10.10.20.0/25"
    tags = {
        Name = "jon_subnet"
        accountName = var.accountName
        applicationName = var.applicationName
        costCenter = var.costCenter
        costCenterOwner = var.costCenterOwner
        environment = var.environment
    }
}

# 2nd Subnet
resource "aws_subnet" "jon2_subnet" {
    vpc_id      =  aws_vpc.jon_vpc.id 
    cidr_block  =  "10.10.20.128/25" #Jon-lee 10.10.20.0/26 Akashni 10.10.30.0/26 Karabo 10.10.40.0/26
    tags = {
        Name = "jon2_subnet"
        accountName = var.accountName
        applicationName = var.applicationName
        costCenter = var.costCenter
        costCenterOwner = var.costCenterOwner
        environment = var.environment
    }
}

# create EC2 instance
resource "aws_instance" "jon_instance" {
  ami           = "ami-063d4ab14480ac177" # us-west-2   # ami-063d4ab14480ac177 and t2.micro
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  subnet_id = aws_subnet.jon_subnet.id
      tags = {
        Name = "jon_instance"
        accountName = var.accountName
        applicationName = var.applicationName
        costCenter = var.costCenter
        costCenterOwner = var.costCenterOwner
        environment = var.environment
    }
}

resource "aws_instance" "jon2_instance" {
  ami           = "ami-063d4ab14480ac177" # us-west-2   # ami-063d4ab14480ac177 and t2.micro
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  subnet_id = aws_subnet.jon2_subnet.id
      tags = {
        Name = "jon2_instance"
        accountName = var.accountName
        applicationName = var.applicationName
        costCenter = var.costCenter
        costCenterOwner = var.costCenterOwner
        environment = var.environment
    }
}

# create security group for instances (allow https port 443 inbound only)
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.jon_vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.jon_vpc.cidr_block]
    #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

 /* egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }*/

      tags = {
        Name = "jon_subnet"
        accountName = var.accountName
        applicationName = var.applicationName
        costCenter = var.costCenter
        costCenterOwner = var.costCenterOwner
        environment = var.environment
    }
}