# 准备步骤
1. 通过浏览器(Chrome/Firefox)**登入实验环境** [Docker Playground](https://katacoda.com/loodse/courses/docker/docker-01-playground)
2. 点击"**START SCENARIO**"开启实验环境
# Lab1: Build the website by running docker commands

## 1. Pull git repository to your local
```
cd /tmp
git clone https://github.com/dockersamples/example-voting-app.git
```

## 2. Run voting-app application 
```
cd /tmp/example-voting-app/vote
docker build -t voting-app .
docker run -d -p 5000:80 --name voting-app voting-app
```

## 3. Run redis application
```
docker run -d --name=redis redis:alpine

docker network create backend
docker network connect backend redis
docker network connect backend voting-app
```

## 4. Run db postgres database 
```
docker run -d --name=db -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -e PGDATA=/var/lib/postgresql/data/pgdata postgres:9.4
docker network connect backend db
```

## 5. Run worker application
```
cd /tmp/example-voting-app/worker
docker build -t worker-app .
docker run -d --name worker-app worker-app
docker network connect backend worker-app
```

## 6. Run result-app application
```
cd /tmp/example-voting-app/result
docker build -t result-app .
docker run -d --name result-app -p 5001:80 result-app  
docker network connect backend result-app
```

## 7. Verification
You can access the voting-app website via [127.0.0.1:5000](http://127.0.0.1:5000)

Once you click any option, the result-app website [127.0.0.1:5001](http://127.0.0.1:5001) will reflect the change.

---
# Lab2: Build the website by docker compose

## 1. Install docker compose if not existing
```
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
docker-compose --version
```

## 2. Download the example voting git repostiry if not existing
```
cd /tmp
git clone https://github.com/dockersamples/example-voting-app.git
```

## 3. Run the docker compose
```
cd /tmp/example-voting-app
docker-compose -f docker-compose-simple.yml up
```

## 4. Verification
You can access the voting-app website via [127.0.0.1:5000](http://127.0.0.1:5000)

Once you click any option, the result-app website [127.0.0.1:5001](http://127.0.0.1:5001) will reflect the change.
