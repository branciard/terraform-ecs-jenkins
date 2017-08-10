FROM cloudbees/jnlp-slave-with-java-build-tools

USER root

RUN apt-get update -q
RUN apt-get -y install openjdk-8-jdk
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -qy python-pip groff-base

RUN pip install robotframework
RUN pip install robotframework-selenium2library
RUN pip install robotframework-databaselibrary
RUN pip install pymysql

RUN apt-get -y install uuid-runtime

RUN apt-get install -y mysql-client

RUN echo "mysql-server mysql-server/root_password password root" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections
RUN apt-get install -y mysql-server


ENTRYPOINT ["/opt/bin/entry_point.sh", "/usr/local/bin/jenkins-slave"]
