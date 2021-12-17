#!/bin/bash

docker pull nginx:1.20
docker pull redis:alpine3.14
docker pull hello-world
docker pull ubuntu
docker run -d --name indoc -p 8080:80 -p 8081:80 nginx:1.20 &
docker run -d --name dk -p 8082:6379 redis:alpine3.14  &
clear
echo "Please wait 10s for the environment setup..."
sleep 10s
echo ""
echo ""
echo "The test environment is ready! Please go to the quiz to start your test! Good luck!"
echo "Note: The quiz link should be sent to your email. Please contact Chance if you don't receive it. Thanks"
