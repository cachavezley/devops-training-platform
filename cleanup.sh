#!/usr/bin/env bash

START_TIME=$SECONDS

echo "INFO: Destroying Docker Containers"
docker-compose down

echo "INFO: Cleaning up Jenkins Data"
sudo chown -R $(whoami):$(whoami) data/
rm -rf data/*
rm -rf $(echo data/.[^.]*)

rm -f jenkins-cli.jar

echo "INFO: Destroying Vagrant Box"
vagrant destroy -f

echo "INFO: Removing Jenkins Docker Image"
docker rmi training/jenkins

ELAPSED_TIME=$(($SECONDS - $START_TIME))
echo "TOTAL CLEANUP TIME: $(($ELAPSED_TIME/60)) min $(($ELAPSED_TIME%60)) sec"