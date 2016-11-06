#!/usr/bin/env bash

docker build -t training/jenkins jenkins/
docker-compose up
docker-compose down

rm -rf data/jenkins/*
rm -rf $(echo data/jenkins/.[^.]*)
