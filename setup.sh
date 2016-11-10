#!/usr/bin/env bash
###########################		FUNCTIONS           ###########################

function createVagrantSlave() {
    echo "INFO: Creating Vagrant Box"
    cd jenkins/

    mkdir -p $JENKINS_DATA/.ssh/
    vagrant up

    #We copy the vagrant box's SSH key as Jenkins own master key so that we can connect to it
    VAGRANT_SSH_KEY="$JENKINS_DATA/.ssh/id_rsa"
    if [ ! -f "$VAGRANT_SSH_KEY" ]; then
        echo "INFO: Copying Vagrant's SSH key"
        sudo cp .vagrant/machines/default/virtualbox/private_key  $VAGRANT_SSH_KEY
        sudo chown $JENKINS_UID:$JENKINS_UID $VAGRANT_SSH_KEY
    fi

    cd -
}

function downloadJenkinsClient() {
    if [ ! -f jenkins-cli.jar ]
    then
        wget http://localhost:10000/jnlpJars/jenkins-cli.jar
    fi
}

function declareCredentials() {
    cat jenkins/default_conf/credential.xml | java -jar jenkins-cli.jar -s http://localhost:10000/ create-credentials-by-xml "system::system::jenkins" "(global)"
}

function declareNode() {
    cat jenkins/default_conf/node.xml | java -jar jenkins-cli.jar -s http://localhost:10000/ create-node
}

function declareJobs() {
    cat jenkins/default_conf/folder.xml | java -jar jenkins-cli.jar -s http://localhost:10000/ create-job my-todo-app
    cat jenkins/default_conf/build.xml | java -jar jenkins-cli.jar -s http://localhost:10000/ create-job my-todo-app/build
}

###########################		MAIN SCRIPT         ###########################
START_TIME=$SECONDS
JENKINS_UID=1000
JENKINS_DATA=$PWD/data/jenkins

createVagrantSlave

echo "INFO: Building Jenkins Docker Image"
docker build -t training/jenkins jenkins/

docker-compose up -d

echo "INFO: Waiting for Jenkins to start..."
sleep 20

echo "INFO: Setting up Jenkins"
downloadJenkinsClient
declareCredentials
declareNode
declareJobs

ELAPSED_TIME=$(($SECONDS - $START_TIME))
echo "TOTAL SETUP TIME: $(($ELAPSED_TIME/60)) min $(($ELAPSED_TIME%60)) sec"