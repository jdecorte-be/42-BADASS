#!/bin/bash

docker pull alpine:latest
docker build --file=Dockerfile --tag=router_jdecorte .
