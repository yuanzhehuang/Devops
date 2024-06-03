terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.52.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_vpc" "jenkinsVPC" {
  default = true
}

resource "aws_security_group" "jenkins_server_sg_tf" {
  name        = "jenkins_server_sg_tf"
  description = "Allow SSH to jenkins server"
  vpc_id      = data.aws_vpc.jenkinsVPC.id

  ingress {
    description = "SSH ingress"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP ingress"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP ingress"
    from_port   = 8080
    to_port     = 8080
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

resource "aws_iam_role" "jenkinsRole" {
  name = "jenkinsRole"

  assume_role_policy = <<EOF
{
        "Version": "2012-10-17",
        "Statement": [
            {
                "Action":"sts:AssumeRole",
                "Principal": {
                    "Service": "ec2.amazonaws.com"
                },
                "Effect": "Allow",
                "Sid": ""
            }
        ]
}
EOF
}

resource "aws_iam_instance_profile" "jenkinsProfile" {
  name = "jenkinsProfile"
  role = aws_iam_role.jenkinsRole.name
}

resource "aws_iam_policy" "EC2_iam_policy" {
  name   = "EC2_iam_policy"
  policy = <<EOF
 {
    "Version": "2012-10-17", 
    "Statement": [ 
        { 
            "Effect": "Allow",
            "Action": [ 
                "ec2:RunInstances", 
                "ec2:TerminateInstances", 
                "ec2:StartInstances",
                "ec2:StopInstances"
            ],
            "Resource": "*" 
        }, 
        { 
            "Effect": "Allow", 
            "Action": [ 
                "ec2:CreateTags", 
                "ec2:DescribeInstances",
                "ec2:DescribeInstanceStatus",
                "ec2:DescribeAddresses", 
                "ec2:AssociateAddress",
                "ec2:DisassociateAddress",
                "ec2:DescribeRegions",
                "ec2:DescribeAvailabilityZones"
            ], 
            "Resource": "*" 
        } 
    ] 
}
EOF
}

resource "aws_iam_role_policy_attachment" "jenkinsRoleAttachment" {
  role       = aws_iam_role.jenkinsRole.name
  policy_arn = aws_iam_policy.EC2_iam_policy.arn
}

resource "aws_instance" "jenkinsServer" {
  ami                    = "ami-0a3c3a20c09d6f377"
  instance_type          = "t3a.medium"
  key_name               = "son"
  vpc_security_group_ids = [aws_security_group.jenkins_server_sg_tf.id]
  iam_instance_profile   = aws_iam_instance_profile.jenkinsProfile.id

  tags = {
    Name = "jenkinsServer"
  }
}
