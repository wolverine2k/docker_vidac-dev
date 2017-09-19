# docker_vidac-dev
A Dockerfile for automatic building of the Vidac development environment with all the needed components


Script to run DockerUI
**************************************
#!/bin/bash
docker run -d -p 9000:9000 --privileged -v /var/run/docker.sock:/var/run/docker.sock uifd/ui-for-docker
**************************************
