[
  {
    "name": "jenkins",
    "image": "${jenkins_image_name}",
    "cpu": 128,
    "memory": 7000,
    "memoryReservation":1024,
    "essential": true,
    "portMappings": [
      {
        "containerPort": 8080,
        "hostPort": 80
      },
      {
        "containerPort": 50000,
        "hostPort": 50000
      }
    ],
    "mountPoints": [
      {
        "sourceVolume": "jenkins-home",
        "containerPath": "/var/jenkins_home"
      }
    ]
  }
]
