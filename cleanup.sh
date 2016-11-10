#!/usr/bin/env bash

START_TIME=$SECONDS

echo "INFO: Destroying Docker Containers"
docker-compose down

echo "INFO: Cleaning up Jenkins Data"
sudo rm -rf data/

rm -f jenkins-cli.jar

echo "INFO: Destroying Vagrant Box"
cd jenkins/
vagrant destroy -f
rm -rf .vagrant/
cd -

echo "INFO: Removing Jenkins Docker Image"
docker rmi training/jenkins

ELAPSED_TIME=$(($SECONDS - $START_TIME))
echo "TOTAL CLEANUP TIME: $(($ELAPSED_TIME/60)) min $(($ELAPSED_TIME%60)) sec"