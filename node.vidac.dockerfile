# Build: docker build -f node.vidac.dockerfile -t wolverine2k/node_vidac .

# Option 1
# Start MongoDB and Node (link Node to MongoDB container with legacy linking)
 
# docker run -d --name my-mongodb mongo
# docker run -d -p 3000:3000 -p3001:3001 --link my-mongodb:mongodb --name vis wolverine2k/node_vidac
# Option 2: Create a custom bridge network and add containers into it

# docker network create --driver bridge isolated_network
# docker run -d --net=isolated_network --name mongodb mongo
# docker run -d --net=isolated_network --name vis -p 3000:3000 -p 3001:3001 wolverine2k/node_vidac

# Run the VIS application with the proper config file
# Run: docker exec vis node src/app/vis/vis_
# Run: docker exec ems node src/app/ems/ems_

#FROM node:6.3.1
FROM node:4.4.7

MAINTAINER Naresh Mehta

ENV NODE_ENV=development 
ENV PORT_VIS=3000
ENV PORT_EMS=3001

COPY      ./vidac/ /var/vidac
WORKDIR   /var/vidac

RUN       sh -c 'cd /var/vidac/src/app/vis && make deps && cd ../ems && make deps'

EXPOSE $PORT_VIS $PORT_EMS 27017 27018 4370 5672 5673 25673

# ENTRYPOINT ["node", "/var/vidac/src/app/vis/bin/vis.bin.js", "server", "--config", "/var/vidac/src/app/vis/conf/config_bbi_vis.json"]
#CMD ["/usr/local/bin/node", "/var/vidac/src/app/vis/bin/vis.bin.js", "server", "--config", "/var/vidac/src/app/vis/conf/config_bbi_vis.json"]
ENTRYPOINT ["/bin/bash", "/var/vidac/vis.sh"]
#ENTRYPOINT ["/bin/sleep", "100000"]