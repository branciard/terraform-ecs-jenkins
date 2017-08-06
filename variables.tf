variable "access_key" {
  description = "The AWS access key."
}

variable "secret_key" {
  description = "The AWS secret key."
}

variable "region" {
  description = "The AWS region to create resources in."
  default = "us-east-1"
}

variable "availability_zone" {
  description = "The availability zone"
  default = "us-east-1b"
}

variable "ecs_cluster_name" {
  description = "The name of the Amazon ECS cluster."
  default = "jenkins"
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
    us-east-2 = "ami-207b5a45"
    us-east-1 = "ami-04351e12"
    us-west-2 = "ami-57d9cd2e"
    us-west-1 = "ami-7d664a1d"
    eu-west-2 = "ami-ff15039b"
    eu-west-1 = "ami-809f84e6"
    eu-central-1 = "ami-a3a006cc"
    ap-northeast-1 = "ami-e4657283"
    ap-southeast-2 = "ami-42e9f921"
    ap-southeast-1 = "ami-19f7787a"
    ca-central-1 = "ami-3da81759"
  }
}

variable "instance_type" {
  default = "t2.medium"
}

variable "key_name" {
  default = "jenkins"
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
  default = "jenkins"
  description = "ECR Repository for Jenkins."
}

variable "jenkins_server_image_name" {
  default = "jenkins-server"
  description = "Jenkins server image name."
}

variable "jenkins_java_build_agent_image_name" {
  default = "jenkins-java-agent"
  description = "Jenkins Java build agent image name."
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
  default = "false"
  description = "if true it will push docker image into AWS ECR. if false you can do it mannualy after your terraform apply (it is faster, do not know why slow more 3 hours vs few minutes)"
}

