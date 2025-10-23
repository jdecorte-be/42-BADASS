#!/bin/bash

docker build --file=_jdecorte-1_host -t host_jdecorte .
docker build --file=_jdecorte-2 -t router_jdecorte .

echo "All Docker images built successfully."
