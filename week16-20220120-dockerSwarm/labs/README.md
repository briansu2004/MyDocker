# 准备步骤
1. 通过浏览器(Chrome/Firefox)**登入实验环境** [Docker Playground](https://katacoda.com/loodse/courses/docker/docker-01-playground)
2. 点击"**START SCENARIO**"开启实验环境

---
# Lab1: Docker Swarm Setup
## 1. Check the system information of your local environment
```
cat /etc/*release*
nproc
free -h
docker --version
systemctl status docker
docker system info |grep -i swarm
```

## 2. Initiate a docker swarm cluster
```
docker swarm init
docker system info |grep -i swarm
docker node ls
docker node inspect host01 --pretty|more
```

## 3. Join another manager or worker
```
docker swarm join-token manager
docker swarm join-token worker

Note: Copy the join command and run in the manager/worker node
```

> Note: Below steps need a second host to be performed
## 4. Promote a worker node to manager
```
docker node promote <workerNodeName>
docker node ls
```

## 5. Demote a worker
```
docker node demote <managerNodeName>
docker node ls
```

## 6. Drain or activate a node
```
docker node update --availability drain <nodeName>
docker node ls

docker node update --availability active <nodeName>
docker node ls
```

## 7. Leave swarm
```
docker node rm <nodeName>
# Note: above command will fail as you have to leave swarm before removing
ssh <leavingNodeName>
docker swarm leave
docker system info|grep -i swarm
exit
docker node rm <nodeName>
```
---
# Lab2: Auto lock

## 1. Turn on auto lock feature
```
docker swarm update --autolock=true
echo "<Token>" > /tmp/autolock.token
```

## 2. Restart the docker daemon to make the docker re-join the swarm cluster
```
systemctl stop docker
systemctl start docker
docker node ls
```

## 3. Unlock and re-run the operation commands
```
docker swarm unlock
docker node ls
```

---
# Lab3: Swarm operation
## 1. List node status
```
docker node ls
```

## 2. Create a service in the Swarm cluster
```
docker service create --name=firstservice -p 80:80 httpd:alpine
docker service ls
docker service ps firstservice
docker service inspect firstservice --pretty|more
docker service logs firstservice
```

## 3. Remove the container and check the service status. The service should bring up another container to replacing the previous one.
```
docker container ls
docker container rm -f <containerName>
docker service ps firstservice
```

## 4. Create another service with 3 replicas
```
docker service create --name=secondservice -p 81:80 --replicas=3 httpd:alpine
docker service ls
docker service ps secondservice
```

## 5. Increase the replicas number
```
docker service update --replicas=5 secondservice
docker service ls
docker service ps secondservice
```

## 6. Decrease the replicas number
```
docker service update --replicas=3 secondservice
docker service ls
docker service ps secondservice
```

## 7. Upgrade the image version
```
docker service inspect secondservice --pretty|grep -i image
docker service update --image=httpd:2 secondservice
docker service ls
docker service ps secondservice
docker service inspect secondservice --pretty|grep -i image
```

## 8. Rollback to previous image version
```
docker service update --rollback secondservice
docker service inspect secondservice --pretty|grep -i image
```

---
# Lab4: Ingress network
## 1. Create a overlay network
```
docker network ls
docker network create --driver=overlay dknet
docker network inspect dknet|more
```

## 2. Create a service and connect to dknet network
```
docker service create --name=ingressservice --name=ingressservice --publish published=82,target=80 --replicas=2 --network=dknet yogeshraheja/kodekloudwebimage:v1
docker service ls
docker service ps ingressservice
```

## 3. Create a service with host mode and connect to dknet network
``` 
docker service create --name=hostservice --publish published=83,target=80,mode=host --network=dknet --replicas=2 yogeshraheja/kodekloudwebimage:v1
docker service ls
docker service ps hostservice
```

---
# Lab5: Docker Stack

## 1. Create docker stack yaml file
```
cd /tmp    
mkdir voting-app-stack
cd voting-app-stack
cat > docker-stack.yaml << EOF
version: '3'
services:
  redis:
    image: redis
    
  db:
    image: postgres:9.4
    
  vote:
    image: dockersamples/examplevotingapp_vote
    ports:
    - 5000:80
    
  worker:
    image: dockersamples/examplevotingapp_worker
    
  result:
    image: dockersamples/examplevotingapp_result
    ports:
    - 5001:80
EOF
```

## 2. Deploy the stack yaml file
```
docker stack deploy voting-app-stack --compose-file docker-stack.yaml
docker stack ls
docker stack ps voting-app-stack
docker service ls
docker service ps voting-app-stack_worker
```

## 3. Update the replicas in the stack yaml file
```
cd /tmp    
cd voting-app-stack
cat > docker-stack.yaml << EOF 
version: '3'
services:
  redis:
    image: redis
    
  db:
    image: postgres:9.4
    
  vote:
    image: dockersamples/examplevotingapp_vote
    ports:
    - 5000:80
    deploy:
      replicas: 2
    
  worker:
    image: dockersamples/examplevotingapp_worker
    
  result:
    image: dockersamples/examplevotingapp_result
    ports:
    - 5001:80
EOF
    
docker stack deploy voting-app-stack --compose-file docker-stack.yaml    
docker service ls
docker service ps voting-app-stack_vote
```
