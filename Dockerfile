FROM jenkins:2.19.1

RUN install-plugins.sh workflow-aggregator:2.4
RUN install-plugins.sh docker-workflow:1.9
RUN install-plugins.sh credentials-binding:1.9
RUN install-plugins.sh pipeline-utility-steps:1.1.6
RUN install-plugins.sh ssh:2.4
RUN install-plugins.sh ssh-slaves:1.11
RUN install-plugins.sh timestamper:1.8.7
RUN install-plugins.sh git:3.0.0
