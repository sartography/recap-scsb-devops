#!/usr/bin/env bash
#   Use this script to stop, build, and start up all SCSB containers needed for local dev environment
pause_for () {
  for (( c=1; c<=$1; c++ ))
  do
     sleep 1 && echo "."
  done
}

printf "\n\n\n===================== Old containers =====================\n\n\n"
pause_for 1
docker container ls --all
pause_for 1

printf "\n\n\n===================== Killing old containers =====================\n\n\n"
pause_for 1
docker kill $(docker ps -q)
pause_for 1

printf "\n\n\n===================== Removing old containers =====================\n\n\n"
pause_for 1
docker rm $(docker ps -a -q)
pause_for 1

pause_for 1
docker-compose rm
pause_for 1

printf "\n\n\n===================== Building containers =====================\n\n\n"
pause_for 1
docker-compose build
pause_for 1

printf "\n\n\n===================== Starting containers =====================\n\n\n"
pause_for 1
docker-compose up -V
pause_for 1
