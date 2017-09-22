FROM cloudbees/jnlp-slave-with-java-build-tools

USER root

RUN apt-get update -q
RUN apt-get -y install icedtea-8-plugin
RUN apt-get -y install openjdk-8-jre
RUN apt-get -y install openjdk-8-jdk


RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -qy python-pip groff-base

RUN pip install robotframework
RUN pip install robotframework-selenium2library
RUN pip install robotframework-databaselibrary
RUN pip install pymysql

RUN apt-get -y install zip unzip wget make ant gcc uuid uuid-runtime vim git

RUN apt-get install -y mysql-client

RUN echo "mysql-server mysql-server/root_password password root" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections
RUN apt-get install -y mysql-server

RUN mkdir /var/xwhep && chmod 777 /var/xwhep
RUN chmod 777 /var/log

RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash
RUN nvm install v6.11.2

RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash
RUN touch ~/.bash_profile
RUN echo 'export NVM_DIR=~/.nvm' >> .bash_profile
RUN echo 'source ~/.nvm/nvm.sh' >> .bash_profile
RUN nvm install v6.11.2

ENTRYPOINT ["/opt/bin/entry_point.sh", "/usr/local/bin/jenkins-slave"]
