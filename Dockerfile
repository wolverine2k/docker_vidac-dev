FROM debian:jessie
MAINTAINER Naresh Mehta <naresh.mehta@gmail.com>

# Update system and make sure we have wget
RUN apt-get update && apt-get -y install wget libwxbase3.0-0v5

# Get the erlang deb file for erlang OTP and install erlang
RUN cd /tmp; wget https://packages.erlang-solutions.com/erlang/esl-erlang/FLAVOUR_1_general/esl-erlang_18.3-1~debian~jessie_amd64.deb && \
    dpkg -i esl-erlang_18.3-1~ubuntu~xenial_amd64.deb

# Update again as needed
RUN apt-get update && apt-get -y install erlang erlang-base-hipe build-essential

# Get the rabbitmq deb file and install it
RUN cd /tmp; wget http://www.rabbitmq.com/releases/rabbitmq-server/v3.6.2/rabbitmq-server_3.6.2-1_all.deb && \
    dpkg -i rabbitmq-server_3.6.2-1_all.deb
    
# Expose the needed ports
EXPOSE 4369 5671 5672 25672 15672

# Install MongoDB from https://docs.docker.com/engine/examples/mongodb/
# Import MongoDB public GPG key AND create a MongoDB list file
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
RUN echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.0.list
# Update apt-get sources AND install MongoDB
RUN apt-get update && apt-get install -y mongodb-org

# Create the MongoDB data directory
RUN mkdir -p /data/db
# Expose port 27017 from the container to the host
EXPOSE 27017

# Set usr/bin/mongod as the dockerized entry-point application
#ENTRYPOINT ["/usr/bin/mongod"]

# Install nodejs (6.x)
RUN curl -sL https://github.com/nodesource/distributions/blob/master/deb/setup_6.x | sudo -E bash -
RUN apt-get install -y nodejs
