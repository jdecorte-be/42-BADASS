#!/bin/bash

# Get all running container names
running_containers=$(docker ps --format '{{.Names}}')

if [[ -z "$running_containers" ]]; then
    echo "No running containers"
    exit 1
fi

for container_name in $running_containers; do
    # Get the hostname of the container
    hostname=$(docker exec "$container_name" hostname)

    # Check if the hostname matches host_* or router_*
    if [[ "$hostname" =~ ^(host_|router_).+ ]]; then
        # The file to copy should have the same name as the hostname
        filename="$hostname"

        # Check if the file exists locally
        if [[ ! -f "$filename" ]]; then
            echo "File $filename not found. Skipping container $hostname."
            continue
        fi

        echo "Applying configuration $filename on container $hostname ($container_name)..."

        # Copy the file into the container
        docker cp "$filename" "$container_name":/

        # Execute the file inside the container
        docker exec "$container_name" ash "/$filename"

        echo "Configuration applied on $hostname ($container_name)."
    else
        echo "Skipping container $hostname ($container_name), hostname does not match."
    fi
done

