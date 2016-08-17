#!/bin/bash

docker-compose build vis
docker-compose run --service-ports vis bash