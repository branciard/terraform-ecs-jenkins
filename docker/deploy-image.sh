#!/bin/sh
#RUN /usr/local/bin/install-plugins.sh ace-editor amazon-ecr amazon-ecs analysis-core antisamy-markup-formatter authentication-tokens aws-credentials awseb-deployment-plugin bouncycastle-api branch-api build-timeout cloudbees-folder credentials credentials-binding dependency-check-jenkins-plugin display-url-api docker-commons docker-workflow durable-task email-ext external-monitor-job git git-client git-parameter git-server github github-api github-branch-source github-organization-folder gradle greenballs handlebars icon-shim jira jquery jquery-detached junit ldap mailer mapdb-api matrix-auth matrix-project momentjs nexus-artifact-uploader pam-auth pipeline-build-step pipeline-github-lib pipeline-graph-analysis pipeline-input-step pipeline-milestone-step pipeline-model-api pipeline-model-declarative-agent pipeline-model-definition pipeline-model-extensions pipeline-rest-api pipeline-stage-step role-strategy pipeline-stage-tags-metadata pipeline-stage-view plain-credentials resource-disposer scm-api script-security slack sonar ssh-credentials ssh-slaves structs subversion timestamper token-macro windows-slaves workflow-aggregator workflow-api workflow-basic-steps workflow-cps workflow-cps-global-lib workflow-durable-task-step workflow-job workflow-multibranch workflow-scm-step workflow-step-api workflow-support ws-cleanup

repository_url=`echo $1 | sed 's~http[s]*://~~g'`
image_name=$2
directory=$3
region=$4
push_docker_img_in_ecr=$5

if [ "$push_docker_img_in_ecr" = "true" ]
then
   eval $(aws ecr get-login --no-include-email --region ${region})
   cd ${directory}
   docker build -t ${image_name} --no-cache .
   docker tag ${image_name}:latest ${repository_url}:latest
   docker push ${repository_url}:latest
   cd -
   exit 0
else
   echo "push_docker_img_in_ecr var [${push_docker_img_in_ecr}] is not equal to true. Do nothing "
   exit 0
fi


