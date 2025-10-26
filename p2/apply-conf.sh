#!/bin/bash

# Get all running container IDs
running_containers=$(docker ps -q)

if [[ -z "$running_containers" ]]; then
    echo "No running containers"
    exit 1
fi

for container_id in $running_containers; do
    # Get the hostname of the container
    hostname=$(docker exec "$container_id" hostname)
    
    # Check if the hostname matches host_* or router_*
    if [[ "$hostname" =~ ^(host_|router_).+ ]]; then
        # The file to copy should have the same name as the hostname
        filename="$hostname"
        
        # Check if the file exists locally
        if [[ ! -f "$filename" ]]; then
            echo "File $filename not found. Skipping container $hostname."
            continue
        fi

        echo "Applying configuration $filename on container $hostname ($container_id)..."
        
        # Copy the file into the container
        docker cp "$filename" "$container_id":/

        # Execute the file inside the container
        docker exec "$container_id" ash "/$filename"

        echo "Configuration applied on $hostname ($container_id)."
    else
        echo "Skipping container $hostname ($container_id), hostname does not match."
    fi
done
