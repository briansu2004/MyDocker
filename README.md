# MyDocker

### Week 5 : 20211104

<details>
  <summary>Click to expand!</summary>

Form

https://docs.google.com/forms/d/e/1FAIpQLSe7askqcK5IQcE8ejKbBlCL7LkDAY_4N3QVm1uJJTfea1J-SQ/viewform?usp=sf_link

```shell
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
```

</details>

### Week 6 : 20211111

<details>
  <summary>Click to expand!</summary>

https://docs.google.com/forms/d/e/1FAIpQLSfwYtUy4sRGcKCLtSniodfM3Epka4leQu3LDv9K1Fg-OFLjQw/viewscore?viewscore=AE0zAgDjCpW4PNJUMEn6ShcOq5DK3d_gXGKiks5hPbCToXVuCWLZ4ExXYvY4DahB5eMyhOw

```shell
$ pwd
/root/dk-devops-review-quiz/week6-20211111
$ cat setup.sh
#!/bin/bash

docker pull nginx
docker pull redis
docker pull hello-world
docker pull ubuntu
docker run -d --name dk -p 8888:80 -v /usr/local/share:/tmp nginx &
docker run -d --name indoc -p 9999:6379 -p 7777:6378 redis &
clear
echo "Please wait 10s for the environment setup..."
sleep 10s
echo ""
echo ""
echo "The test environment is ready! Please go to the quiz to start your test! Good luck!"
echo "Note: The quiz link should be sent to your email. Please contact Chance if you don't receive it. Thanks"
```

![01.png](week6-20211111/01.png)

![02.png](week6-20211111/02.png)

![03.png](week6-20211111/03.png)

![04.png](week6-20211111/04.png)

</details>

## Appendix

<details>
  <summary>Click to expand!</summary>

### 打卡

https://docs.google.com/spreadsheets/d/1ycnDY6OF1UFTYxSq2lWlQo0y-g6Ozko1KRAQysBQOPg/edit#gid=0

- Chance chance.chen21@gmail.com
- Tony taixue@gmail.com
- Liza Lin lizalin09@gmail.com
- 戎 Roger rogerrwh.work@gmail.com
- Ben Li benli888@hotmail.com
- Angie Fang angiefang@yahoo.com
- Eric eyoonltd@gmail.com
- Brian briansu2004@hotmail.com
- Leo liu leoliu20140212@gmail.com
- Bin Yu yubin.on.ca@gmail.com
- ...

</details>
