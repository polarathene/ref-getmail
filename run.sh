#! /usr/bin/env bash

docker compose up -d --force-recreate

# Wait until the retriever container is ready:
until [[ -n "$(docker ps -q -f name=dms-retriever -f health=healthy)" ]]; do
  sleep 1
done
