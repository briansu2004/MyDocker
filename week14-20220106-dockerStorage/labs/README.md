# 准备步骤
1. 通过浏览器(Chrome/Firefox)**登入实验环境** [Docker Playground](https://katacoda.com/loodse/courses/docker/docker-01-playground)
2. 点击"**START SCENARIO**"开启实验环境

# Lab1: How the docker volume works
## 1. Create a docker volume
```
ls -l /var/lib/docker/volumes/

docker volume create data-1

ls -l /var/lib/docker/volumes/
ls -l /var/lib/docker/volumes/data-1/
ls -l /var/lib/docker/volumes/data-1/_data
```

## 2. Run a container and use the volume created above
```
docker run -itd --name=container-1 --mount source=data-1,target=/data busybox
```

## 3. Create a text in the container
```
docker exec -it container-1 sh
cd /data
echo "Happy 2022" > 20220106.txt
cat /data/20220106.txt
exit
cd /var/lib/docker/volumes/data-1/_data
cat 20220106.txt
```

---
# Lab2: How AUFS filesystem works
## 1. Change the storage driver to aufs in daemon.json
```
docker info|grep -i storage
sudo cp -au /var/lib/docker  /var/lib/docker.bak1
vim /etc/docker/daemon.json
{
  "storage-driver": "aufs"
}


systemctl restart docker
docker info|grep -i storage
```

## 2. Create the folders for images/container/mnt respectively
```
cd /tmp
mkdir aufs
cd aufs
mkdir mnt image-1 image-2 container-1
echo "This is container-1" > container-1/container1.txt
echo "This is image 1" > image-1/image1.txt
echo "This is image 2" > image-2/image2.txt
tree .
```

## 3. Mount the aufs folder as AUFS filesystem
```
cd /tmp/aufs
ls /sys/fs/aufs/
mount -t aufs -o dirs=./container-1:./image-2:./image-1  none  ./mnt
mount -t aufs
ls /sys/fs/aufs/
cat /sys/fs/aufs/si_????/*
ls -l /tmp/aufs/mnt
```

## 4. Update the image file in mnt folder and compare to the same file in the container/image folders
```
ls /tmp/aufs/container-1/
echo "New content" >  /tmp/aufs/mnt/image1.txt
cat /tmp/aufs/image-1/image1.txt
cat /tmp/aufs/container-1/image1.txt
```
## 5. Update the container file in mnt folder and compare to the same file in the container folder
```
cat /tmp/aufs/container-1/container1.txt
echo "New content" >  /tmp/aufs/mnt/container1.txt
cat /tmp/aufs/container-1/container1.txt
```

---
# Lab 3: How overlay2 filesystem works
## 1. Configure overlay2 mode in docker
```
docker info |grep -i storage
sudo systemctl stop docker
sudo cp -au /var/lib/docker  /var/lib/docker.bak2

vi /etc/docker/daemon.json
{
  "storage-driver": "overlay",
}
sudo systemctl start docker

docker info |grep -i storage
```
>> Note: If you are not using Katakoda, please use overlay2 instead
```
vi /etc/docker/daemon.json
{
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.size=20G",
    "overlay2.override_kernel_check=true"
  ]
}

```

## 2. Mount a folder as overlay filesystem
```
cd /tmp/
mkdir overlay
cd overlay
mkdir -p lower1/a  lower1/b
mkdir -p lower2/a  lower2/c
mkdir -p upper/b  upper/d
mkdir -p work merged
echo "This is lower1 a" > /tmp/overlay/lower1/a/a.txt
echo "This is lower1 b" > /tmp/overlay/lower1/b/b.txt
echo "This is lower2 a" > /tmp/overlay/lower2/a/a.txt
echo "This is lower2 c" > /tmp/overlay/lower2/c/c.txt
echo "This is upper b" > /tmp/overlay/upper/b/b.txt
echo "This is upper d" > /tmp/overlay/upper/d/d.txt
tree /tmp/overlay
mount -t overlay overlay -o lowerdir=lower1:lower2,upperdir=upper,workdir=work merged
tree /tmp/overlay
```

## 3. Create a file in merged folder and you will see the file appear in upper folder as well
```
cd /tmp/overlay/merged/a 
echo 'hello' > test
find /tmp/overlay -name test
```

## 4. Update a file existing in both lower1 and upper
```
echo "New content" > /tmp/overlay/merged/b/b.txt
cat /tmp/overlay/upper/b/b.txt
cat /tmp/overlay/lower1/b/b.txt
```

## 5. Update a file existing in lower2 but not in upper
```
tree /tmp/overlay
echo "New content" > /tmp/overlay/merged/c/c.txt
tree /tmp/overlay
cat /tmp/overlay/lower2/c/c.txt
cat /tmp/overlay/upper/c/c.txt
```
