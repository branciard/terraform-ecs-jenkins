variable "access_key" {
  description = "The AWS access key."
}

variable "secret_key" {
  description = "The AWS secret key."
}

variable "region" {
  description = "The AWS region to create resources in."
}

variable "availability_zone" {
  description = "The availability zone"
}

variable "ecs_cluster_name" {
  description = "The name of the Amazon ECS cluster."
  default = "cluster-jenkins"
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC Jenkins will live in"
  default = "10.0.0.0/16"
}

variable "subnet_cidr_block" {
  description = "The CIDR block for the subnet Jenkins will live in"
  default = "10.0.1.0/24"
}

variable "amis" {
  description = "Which AMI to spawn. Defaults to the AWS ECS optimized images. see here for update http://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html"
  default = {
    us-east-2 = "ami-1c002379"
    us-east-1 = "ami-9eb4b1e5"
    us-west-2 = "ami-1d668865"
    us-west-1 = "ami-4a2c192a"
    eu-west-2 = "ami-cb1101af"
    eu-west-1 = "ami-8fcc32f6"
    eu-central-1 = "ami-0460cb6b"
    ap-northeast-1 = "ami-b743bed1"
    ap-southeast-2 = "ami-c1a6bda2"
    ap-southeast-1 = "ami-9d1f7efe"
    ca-central-1 = "ami-b677c9d2"
  }
}



variable "instance_type" {
  default = "t2.large"
}

variable "key_name" {
  description = "SSH key name in your AWS account for AWS instances."
}

variable "min_instance_size" {
  default = 1
  description = "Minimum number of EC2 instances."
}

variable "max_instance_size" {
  default = 2
  description = "Maximum number of EC2 instances."
}

variable "desired_instance_capacity" {
  default = 1
  description = "Desired number of EC2 instances."
}

variable "desired_service_count" {
  default = 1
  description = "Desired number of ECS services."
}

variable "s3_bucket" {
  description = "S3 bucket where remote state and Jenkins data will be stored."
}

variable "s3_bucket_key" {
  description = "S3 bucket key where remote state will be stored."
}


variable "s3_bucket_encrypt" {
  description = "S3 bucket encrypt or not on remote"
}


variable "jenkins_repository_url" {
  default = "jenkins-ecr"
  description = "ECR Repository for Jenkins."
}

variable "jenkins_server_image_name" {
  default = "jenkins-server"
  description = "Jenkins server image name."
}

variable "jenkins_build_agent_image_name" {
  default = "jenkins-agent"
  description = "Jenkins build agent image name."
}

variable "contact_email" {
  default = "francois.branciard@iex.ec"
  description = "contact email for the resource created "
}

variable "contact_office" {
  default = "Lyon"
  description = "contact office for the resource created "
}

variable "contact_name" {
  default = "Francois Branciard"
  description = "contact name for the resource created "
}

variable "push_docker_img_in_ecr" {
  description = "if true it will push docker image into AWS ECR. if false you can do it mannualy after your terraform apply (it is faster, do not know why slow more 3 hours vs few minutes)"
}

