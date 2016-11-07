#!/usr/bin/env bash
###########################		FUNCTIONS           ###########################

function downloadJenkinsClient() {
    if [ ! -f jenkins-cli.jar ]
    then
        wget http://localhost:10000/jnlpJars/jenkins-cli.jar
    fi
}

function declareCredentials() {
    cat credential.xml | java -jar jenkins-cli.jar -s http://localhost:10000/ create-credentials-by-xml "system::system::jenkins" "(global)"
}

function declareNode() {
    cat node.xml | java -jar jenkins-cli.jar -s http://localhost:10000/ create-node
}

function declareJobs() {
    cat folder.xml | java -jar jenkins-cli.jar -s http://localhost:10000/ create-job my-todo-app
    cat build.xml | java -jar jenkins-cli.jar -s http://localhost:10000/ create-job my-todo-app/build
}

###########################		MAIN SCRIPT         ###########################
START_TIME=$SECONDS

echo "INFO: Creating Vagrant Box"
vagrant up

echo "INFO: Building Jenkins Docker Image"
docker build -t training/jenkins .
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