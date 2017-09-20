provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region = "${var.region}"
}

terraform {
  required_version = "0.10.6"
  backend "s3" {}
}

data "terraform_remote_state" "tfstate" {
  backend = "s3"
  config {
    bucket     = "${var.s3_bucket}"
    region     = "${var.region}"
    key        = "${var.s3_bucket_key}"
    encrypt    = "${var.s3_bucket_encrypt}"
  }
}



resource "aws_vpc" "jenkins-vpc" {
  cidr_block = "${var.vpc_cidr_block}"
  enable_dns_hostnames = true

  tags {
    for = "${var.ecs_cluster_name}"
    Email = "${var.contact_email}"
    Engagement_Office = "${var.contact_office}"
    Manager = "${var.contact_name}"
  }
}

resource "aws_route_table" "external-route-table" {
  vpc_id = "${aws_vpc.jenkins-vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.jenkins-gateway.id}"
  }

  tags {
    for = "${var.ecs_cluster_name}"
    Email = "${var.contact_email}"
    Engagement_Office = "${var.contact_office}"
    Manager = "${var.contact_name}"
  }
}

resource "aws_route_table_association" "external-jenkins" {
  subnet_id = "${aws_subnet.jenkins-subnet.id}"
  route_table_id = "${aws_route_table.external-route-table.id}"
}

resource "aws_subnet" "jenkins-subnet" {
  vpc_id = "${aws_vpc.jenkins-vpc.id}"
  cidr_block = "${var.subnet_cidr_block}"
  availability_zone = "${var.availability_zone}"

  tags {
    for = "${var.ecs_cluster_name}"
    Email = "${var.contact_email}"
    Engagement_Office = "${var.contact_office}"
    Manager = "${var.contact_name}"
  }
}

resource "aws_internet_gateway" "jenkins-gateway" {
  vpc_id = "${aws_vpc.jenkins-vpc.id}"

  tags {
    for = "${var.ecs_cluster_name}"
    Email = "${var.contact_email}"
    Engagement_Office = "${var.contact_office}"
    Manager = "${var.contact_name}"
  }
}

resource "aws_security_group" "sg-jenkins" {
  name = "sg_${var.ecs_cluster_name}"
  description = "Allows all traffic"
  vpc_id = "${aws_vpc.jenkins-vpc.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = 50000
    to_port = 50000
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}

resource "aws_ecs_cluster" "jenkins-cluster" {
  name = "${var.ecs_cluster_name}"
}

resource "aws_autoscaling_group" "asg-jenkins" {
  name = "${var.ecs_cluster_name}_asg"
  min_size = "${var.min_instance_size}"
  max_size = "${var.max_instance_size}"
  desired_capacity = "${var.desired_instance_capacity}"
  health_check_type = "EC2"
  health_check_grace_period = 300
  launch_configuration = "${aws_launch_configuration.lc-jenkins.name}"
  vpc_zone_identifier = ["${aws_subnet.jenkins-subnet.id}"]

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key = "Name"
    value = "${var.ecs_cluster_name}_asg"
    propagate_at_launch = true
  }

  tag {
    key = "Email"
    value = "${var.contact_email}"
    propagate_at_launch = true
  }

  tag {
    key = "Engagement_Office"
    value = "${var.contact_office}"
    propagate_at_launch = true
  }

  tag {
    key = "Manager"
    value = "${var.contact_name}"
    propagate_at_launch = true
  }
}

data "template_file" "user-data" {
  template = "${file("templates/user_data.tpl")}"
  vars {
    region = "${var.region}"
    ecs_cluster_name = "${var.ecs_cluster_name}"
  }
}

resource "aws_launch_configuration" "lc-jenkins" {
  name_prefix = "lc_${var.ecs_cluster_name}-"
  image_id = "${lookup(var.amis, var.region)}"
  instance_type = "${var.instance_type}"
  security_groups = ["${aws_security_group.sg-jenkins.id}"]
  iam_instance_profile = "${aws_iam_instance_profile.iam_instance_profile.name}"
  key_name = "${var.key_name}"
  associate_public_ip_address = true
  user_data = "${data.template_file.user-data.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role" "host-role-jenkins" {
  name = "host_role_${var.ecs_cluster_name}"
  assume_role_policy = "${file("roles/ecs-role.json")}"
}

resource "aws_iam_role_policy" "instance-role-policy-jenkins" {
  name = "instance_role_policy_${var.ecs_cluster_name}"
  policy = "${file("policies/ecs-instance-role-policy.json")}"
  role = "${aws_iam_role.host-role-jenkins.id}"
}

resource "aws_iam_instance_profile" "iam_instance_profile" {
  name = "iam_instance_profile_${var.ecs_cluster_name}"
  path = "/"
  role = "${aws_iam_role.host-role-jenkins.name}"
}
