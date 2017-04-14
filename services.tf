resource "aws_iam_role" "ecs_task_role_jenkins" {
  name = "${var.ecs_cluster_name}_task_role"
  assume_role_policy = "${file("roles/ecs-task-role.json")}"
}

resource "template_file" "ecs_task_role_policy_jenkins" {
  template = "${file("policies/templates/ecs-task-role-policy.json.tpl")}"

  vars {
    s3_bucket = "${var.s3_bucket}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "template_file" "ecs_task_role_policy_jenkins" {
  template = "${file("policies/templates/ecs-task-role-policy.json.tpl")}"

  vars {
    s3_buckets = [
      "arn:aws:s3:::${var.s3_bucket}/*",
      "arn:aws:s3:::dev-abbvie-cfe-ui-us-east-1/*"
    ]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy" "ecs_task_role_policy_jenkins" {
  name = "${var.ecs_cluster_name}_task_role_policy"
  policy = "${template_file.ecs_task_role_policy_jenkins.rendered}"
  role = "${aws_iam_role.ecs_task_role_jenkins.id}"
}

resource "aws_iam_policy_attachment" "ecs_access_policy" {
  name = "ecs_access_attachment"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerServiceFullAccess"
  roles = ["${aws_iam_role.ecs_task_role_jenkins.id}"]
}

resource "aws_ecr_repository" "jenkins-server" {
  name = "${var.jenkins_server_image_name}"
  provisioner "local-exec" {
    command = "cd docker;./deploy-image.sh ${self.repository_url} ${var.jenkins_server_image_name} server"
  }
}

resource "aws_ecr_repository" "jenkins-build-agent" {
  name = "${var.jenkins_java_build_agent_image_name}"
  provisioner "local-exec" {
    command = "cd docker;./deploy-image.sh ${self.repository_url} ${var.jenkins_java_build_agent_image_name} agent"
  }
}

resource "template_file" "jenkins_task_template" {
  template = "${file("templates/jenkins.json.tpl")}"

  vars {
    jenkins_image_name = "${aws_ecr_repository.jenkins-server.repository_url}"
  }
}

resource "aws_ecs_task_definition" "jenkins" {
  family = "jenkins"
  container_definitions = "${template_file.jenkins_task_template.rendered}"
  task_role_arn = "${aws_iam_role.ecs_task_role_jenkins.arn}"

  volume {
    name = "jenkins-home"
    host_path = "/ecs/jenkins-home"
  }
}

resource "aws_ecs_service" "jenkins" {
  name = "jenkins"
  cluster = "${var.ecs_cluster_name}"
  task_definition = "${aws_ecs_task_definition.jenkins.arn}"
  desired_count = "${var.desired_service_count}"
  depends_on = ["aws_autoscaling_group.asg_jenkins"]
}
