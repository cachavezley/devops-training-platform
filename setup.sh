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

###########################		MAIN SCRIPT         ###########################
vagrant up
docker build -t training/jenkins jenkins/
docker-compose up -d

sleep 20
downloadJenkinsClient
declareCredentials
declareNode