
## Credits

* The Makefile idea (and the Makefile itself) is taken from this [blog post](http://karlcode.owtelse.com/blog/2015/09/01/working-with-terraform-remote-statefile/).

* Thanks : forked from https://github.com/jamesggraf/terraform-ecs-jenkins forked from https://github.com/shuaibiyy/terraform-ecs-jenkins


# ECS-Powered Jenkins

This repo contains a [Terraform](https://terraform.io/) module for provisioning a Jenkins 2.0 server in an [AWS ECS](https://aws.amazon.com/ecs/) cluster. Jenkins on ECS can be used to achieve a scalable and cost-efficient CI workflow when coupled with the [Jenkins ECS plugin](https://wiki.jenkins-ci.org/display/JENKINS/Amazon+EC2+Container+Service+Plugin) as described in this [blog post](https://shuaib.me/ecs-jenkins/).

It also contains a Terraform configuration for building and provisioning a Jenkins image in [AWS ECR](https://aws.amazon.com/ecr/).

The terraform script stores the terraform state remotely in an S3 bucket. The Makefile by default sets up a copy of the remote state if it doesn’t exist and then runs either `terraform plan` or `terraform apply` depending on the target.


### Prerequisite

*  Terraform v0.9.11
*  Docker 17.06.0-ce
*  aws cli
*  git


### init


 You must configure a `s3_bucket` in aws to store the terraform state. then fill the backend.tfvars file according to your created S3 bucket

 You must create a key pair in aws and configure the key name in terraform.tfvars 
  
 Init your aws env with `aws configure` 
 
 Check that default values in variables.tf are correct for you

 Create a terraform.tfvars and fill it according to your config
```
s3_bucket = "your bucket name in aws"
s3_bucket_key = "terraform.tfstate"
s3_bucket_encrypt = "true"
key_name = "your ssh key name to use in aws "
region = "ap-southeast-1"
availability_zone = "ap-southeast-1b"
access_key = "your aws access key"
secret_key = "your aws secret key"
auto_push_docker_img_in_ecr = "true or false"
```

From the project's root directory,init your s3 bucket terraform backends with :

`terraform init -backend-config=backend.tfvars`



if  "Error configuring the backend "s3": SignatureDoesNotMatch: " :
do 
```
sudo ntpdate ntp.ubuntu.com
```

## Usage

#### Run 'terraform plan'

    terraform plan

#### Run 'terraform apply'

    terraform apply
    
Upon completion, you'll need to access the AWS ECS console to find out the domain name of the Jenkins instance. It'll be something like `ec2-XX-XX-XX-XX.compute-1.amazonaws.com`. You can then reach Jenkins via your browser at `http://ec2-XX-XX-XX-XX.compute-1.amazonaws.com`.



### Manually push dockers images in ECR

If you auto_push_docker_img_in_ecr to false and want to manually push the docker images in ECR. Do : 

    terraform show
    
    
   you will find commands to execute at the end of the printed log.
   

__Note__: If you provisioned the Jenkins image in ECR, the repository URL would look like: `<aws_account_id>.dkr.ecr.us-east-1.amazonaws.com/<jenkins_image_name>:latest`.


#### Run 'terraform destroy' = all will be destroyed. be careful ..

    terraform destroy

