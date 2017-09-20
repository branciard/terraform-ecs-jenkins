resource "aws_iam_role" "ecs-task-role-jenkins" {
  name = "${var.ecs_cluster_name}_task_role_${var.region}"
  assume_role_policy = "${file("roles/ecs-task-role.json")}"
}


resource "aws_iam_policy_attachment" "ecs-access-policy-jenkins" {
  name = "ecs_access_attachment"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerServiceFullAccess"
  roles = ["${aws_iam_role.ecs-task-role-jenkins.id}"]
}

resource "aws_ecr_repository" "jenkins-server" {
  name = "${var.jenkins_server_image_name}"
  provisioner "local-exec" {
    command = "sh docker/deploy-image.sh ${self.repository_url} ${var.jenkins_server_image_name} docker/server ${var.region} ${var.push_docker_img_in_ecr}"
  }
}

output "push-manually-jenkins-server" {
  value = "sh docker/deploy-image.sh ${aws_ecr_repository.jenkins-server.repository_url} ${var.jenkins_server_image_name} docker/server ${var.region} true"
}


resource "aws_ecr_repository" "jenkins-build-agent" {
  name = "${var.jenkins_build_agent_image_name}"
  provisioner "local-exec" {
    command = "sh docker/deploy-image.sh ${self.repository_url} ${var.jenkins_build_agent_image_name} docker/agent ${var.region} ${var.push_docker_img_in_ecr}"
  }
}

output "push-manually-jenkins-build-agent" {
  value = "sh docker/deploy-image.sh ${aws_ecr_repository.jenkins-build-agent.repository_url} ${var.jenkins_build_agent_image_name} docker/agent ${var.region} true"
}

data "template_file" "jenkins-task-template" {
  template = "${file("templates/jenkins.json.tpl")}"

  vars {
    jenkins_image_name = "${aws_ecr_repository.jenkins-server.repository_url}"
  }
}

resource "aws_ecs_task_definition" "jenkins-ecs-task-definition" {
  family = "jenkins"
  container_definitions = "${data.template_file.jenkins-task-template.rendered}"
  task_role_arn = "${aws_iam_role.ecs-task-role-jenkins.arn}"

  volume {
    name = "jenkins-home"
    host_path = "/ecs/jenkins-home"
  }
}

resource "aws_ecs_service" "jenkins-ecs" {
  name = "jenkins-ecs"
  cluster = "${var.ecs_cluster_name}"
  task_definition = "${aws_ecs_task_definition.jenkins-ecs-task-definition.arn}"
  desired_count = "${var.desired_service_count}"
  depends_on = ["aws_autoscaling_group.asg-jenkins"]
}
