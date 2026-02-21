provider "aws" {
  region = "us-east-1"
}

variable "web_asg_max" {
  default = 6
}

variable "web_asg_min" {
  default = 1
}

variable "web_asg_desired" {
  default = 3
}

variable "key_pair_name" {
  default = "kuberenetes"
}

#Resources

resource "aws_vpc" "tf_vpc" {
  cidr_block = "10.0.0.0/22"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = { Name = "tf_vpc"}
}

resource "aws_subnet" "tf_pub_subnet1" {
  vpc_id = aws_vpc.tf_vpc.id
  cidr_block = "10.0.0.0/25"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = { Name = "tf_pub_subnet1"}
}

resource "aws_subnet" "tf_pub_subnet2" {
  vpc_id = aws_vpc.tf_vpc.id
  cidr_block = "10.0.0.128/25"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
  tags = { Name = "tf_pub_subnet2"}
}

resource "aws_subnet" "tf_pub_subnet3" {
  vpc_id = aws_vpc.tf_vpc.id
  cidr_block = "10.0.1.0/25"
  availability_zone = "us-east-1c"
  map_public_ip_on_launch = true
  tags = { Name = "tf_pub_subnet3"}
}

resource "aws_subnet" "tf_priv_subnet1" {
  vpc_id = aws_vpc.tf_vpc.id
  cidr_block = "10.0.2.0/25"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = false
  tags = { Name = "tf_priv_subnet1"}
}

resource "aws_subnet" "tf_priv_subnet2" {
  vpc_id = aws_vpc.tf_vpc.id
  cidr_block = "10.0.2.128/25"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = false
  tags = { Name = "tf_priv_subnet2"}
}

resource "aws_subnet" "tf_priv_subnet3" {
  vpc_id = aws_vpc.tf_vpc.id
  cidr_block = "10.0.3.0/25"
  availability_zone = "us-east-1c"
  map_public_ip_on_launch = false
  tags = { Name = "tf_priv_subnet3"}
}

resource "aws_internet_gateway" "tf_igw" {
  vpc_id = aws_vpc.tf_vpc.id
  tags = { Name = "tf_igw"}
}

resource "aws_route_table" "tf_rt_pub" {
  vpc_id = aws_vpc.tf_vpc.id
  tags = { Name = "tf_rt_pub"}
}

resource "aws_route_table" "tf_rt_priv" {
  vpc_id = aws_vpc.tf_vpc.id
  tags = { Name = "tf_rt_priv"}
}

resource "aws_route" "tf_rt_pub_route" {
    route_table_id = aws_route_table.tf_rt_pub.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_igw.id
}

resource "aws_eip" "tf_nat_eip" {
  domain = "vpc"
  tags = { Name = "tf_nat_eip"}
}

resource "aws_nat_gateway" "tf_nat_gw" {
  allocation_id = aws_eip.tf_nat_eip.id
  subnet_id = aws_subnet.tf_pub_subnet1.id
  tags = { Name = "tf_nat_gw"}
  
}

resource "aws_route" "tf_rt_priv_route" {
    route_table_id = aws_route_table.tf_rt_priv.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.tf_nat_gw.id
}

resource "aws_route_table_association" "tf_rt_pub_subnet1_assoc" {
    subnet_id = aws_subnet.tf_pub_subnet1.id
    route_table_id = aws_route_table.tf_rt_pub.id
}

resource "aws_route_table_association" "tf_rt_pub_subnet2_assoc" {
    subnet_id = aws_subnet.tf_pub_subnet2.id
    route_table_id = aws_route_table.tf_rt_pub.id
}

resource "aws_route_table_association" "tf_rt_pub_subnet3_assoc" {
    subnet_id = aws_subnet.tf_pub_subnet3.id
    route_table_id = aws_route_table.tf_rt_pub.id
}

resource "aws_route_table_association" "tf_rt_priv_subnet1_assoc" {
    subnet_id = aws_subnet.tf_priv_subnet1.id
    route_table_id = aws_route_table.tf_rt_priv.id
}

resource "aws_route_table_association" "tf_rt_priv_subnet2_assoc" {
    subnet_id = aws_subnet.tf_priv_subnet2.id
    route_table_id = aws_route_table.tf_rt_priv.id
}

resource "aws_route_table_association" "tf_rt_priv_subnet3_assoc" {
    subnet_id = aws_subnet.tf_priv_subnet3.id
    route_table_id = aws_route_table.tf_rt_priv.id
}

### Security Groups

resource "aws_security_group" "tf_sg" {
  vpc_id = aws_vpc.tf_vpc.id
  name = "tf_sg"
  description = "Access HTTP and SSH"

  dynamic "ingress" {
    for_each = [
        {description = "SSH", from_port = 22, to_port = 22, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"]},
        {description = "HTTP", from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"]}
    ]

    content {
      description = ingress.value.description
      from_port = ingress.value.from_port
      to_port = ingress.value.to_port
      protocol = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress{
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }
}

resource "aws_lb" "tf_alb" {
  name = "tf-alb"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.tf_sg.id]
  subnets = [aws_subnet.tf_pub_subnet1.id, aws_subnet.tf_pub_subnet2.id]
}

resource "aws_lb_target_group" "tf_alb_tg" {
    name = "tf-alb-tg"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.tf_vpc.id
    target_type = "instance"

    health_check {
      path = "/"
      interval = 30
      timeout = 5
      healthy_threshold = 2
      unhealthy_threshold = 2
    }
}

resource "aws_lb_listener" "alb_listener" {
    load_balancer_arn = aws_lb.tf_alb.arn
    port = 80
    protocol = "HTTP"

    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.tf_alb_tg.arn
    }
}

resource "aws_launch_template" "tf_launch_template" {
  name = "tf_launch_template"
  image_id = "ami-0f3caa1cf4417e51b"
  instance_type = "t3.micro"
  key_name = var.key_pair_name
  network_interfaces {
    security_groups = [aws_security_group.tf_sg.id]
  }

  lifecycle {
    create_before_destroy = true
  }
  
    user_data = base64encode(<<-EOF
    #!/bin/bash
    exec > /tmp/user-data.log 2>&1
    set -x

    sudo yum update -y
    sudo amazon-linux-extras enable epel
    sudo yum install -y httpd git

    sudo systemctl start httpd
    sudo systemctl enable httpd

    git clone https://github.com/Cloudintelugu/ccitwebsite.git /tmp/website
    sudo cp -r /tmp/website/* /var/www/html/
    sudo chown -R apache:apache /var/www/html
    sudo chmod -R 755 /var/www/html

    sudo systemctl restart httpd
    EOF
    )
}

resource "aws_autoscaling_group" "tf_asg" {
  vpc_zone_identifier = [aws_subnet.tf_priv_subnet1.id]
  desired_capacity = var.web_asg_desired
  max_size = var.web_asg_max
  min_size = var.web_asg_min
  health_check_type = "ELB"
  health_check_grace_period = 300
  target_group_arns = [aws_lb_target_group.tf_alb_tg.arn]

  launch_template {
    id = aws_launch_template.tf_launch_template.id
    version = "$Default"
  }
}