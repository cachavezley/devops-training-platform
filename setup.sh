#!/usr/bin/env bash
###########################		FUNCTIONS           ###########################
function launchSlaveVM() {
    cd jenkins/
    vagrant up
    cd -
}

function destroySlaveVM() {
    cd jenkins/
    vagrant destroy -f
    cd -
}

function downloadJenkinsClient() {
    if [ ! -f jenkins/jenkins-cli.jar ]
    then
        wget -P jenkins/ http://localhost:10000/jnlpJars/jenkins-cli.jar
    fi
}

function declareCredentials() {
    cat jenkins/credential.xml | java -jar jenkins/jenkins-cli.jar -s http://localhost:10000/ create-credentials-by-xml "system::system::jenkins" "(global)"
}

function declareNode() {
    cat jenkins/node.xml | java -jar jenkins/jenkins-cli.jar -s http://localhost:10000/ create-node
}

function cleanData() {
    sudo chown -R $(whoami):$(whoami) data/
    rm -rf data/*
    rm -rf $(echo data/.[^.]*)
}

###########################		MAIN SCRIPT         ###########################
launchSlaveVM
docker build -t training/jenkins jenkins/
docker-compose up -d

sleep 20
downloadJenkinsClient
declareCredentials
declareNode

docker logs -f training-jenkins

docker-compose down
cleanData
destroySlaveVM