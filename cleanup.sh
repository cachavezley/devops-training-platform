#!/usr/bin/env bash

docker-compose down

sudo chown -R $(whoami):$(whoami) data/
rm -rf data/*
rm -rf $(echo data/.[^.]*)

rm -f jenkins-cli.jar

vagrant destroy -f
docker rmi training/jenkins