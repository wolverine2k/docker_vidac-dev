#!/bin/bash

# Start RabbitMQ from the official image https://hub.docker.com/_/rabbitmq/
#sudo docker run -d -p 25672:25672 -p 4369:4369 -p 5671:5671 -p 5672:5672 --hostname mb-host rabbitmq:3.6.2
# Also start the management plugin as needed
#sudo docker run -d -P --hostname mb-host rabbitmq:3.6.2-management

# Create a mongo-data-volume
sudo docker create --name mongo-data-volume -v /data/vidacdb mongo:3.3.6 /bin/true
sudo docker-compose up -d

# Start MongoDB from the official image https://hub.docker.com/_/mongo/
#sudo docker run -v /data/vidacDB -d -p 27017:27017 mongo:3.3.6
sudo docker run -d -p 27017:27017 --volumes-from mongo-data-volume mongo:3.3.6 --smallfiles --master

# --rest --auth

# Start ElasticSearch needed for live data from official image https://hub.docker.com/_/elasticsearch/
sudo docker run -it -d -p 9200:9200 -p 9300:9300 -e ES_JAVA_OPTS="-Xms1g -Xmx1g" elasticsearch:5.0.0-alpha4 -E node.name="es_host" -E http.cors.enabled="true" -E http.cors.allow-origin="*" -E bootstrap.ignore_system_bootstrap_checks=true -E bootstrap.seccomp=false
#-Dhttp.cors.allow-origin:"/http?:\/\/localhost(:[0-9]+)?/"

sleep 5

# Kibana from official https://hub.docker.com/_/kibana/ #4.5.1
sudo docker run --name local-kibana -e ELASTICSEARCH_URL=http://136.225.119.110:9200 -p 5601:5601 -d kibana:5.0.0-alpha4

# Kibana from official https://hub.docker.com/_/kibana/ #4.5.1
#sudo docker run --name edm-kibana -e ELASTICSEARCH_URL=http://150.132.77.249:9200 -p 5610:5601 -d kibana:5.0.0-alpha4

# Jenkins from official https://hub.docker.com/_/jenkins/ #1.651.3
#sudo docker create --name jenkins-data-volume -v /data/jenkins_home jenkins:1.651.3 /bin/true
#sudo docker-compose up -d
#sudo docker run -v /data/jenkins_home -d -p 8080:8080 -p 50000:50000 jenkins:1.651.3
sudo docker create --name jenkins-data-volume -v /data/jenkins_home wolverine2k/my_jenkins /bin/true
sudo docker run -v /home/naresh/jenkins_mount:/data/jenkins_home -d -p 8080:8080 -p 50000:50000 --add-host="gerritmirror:147.214.176.232" wolverine2k/my_jenkins
