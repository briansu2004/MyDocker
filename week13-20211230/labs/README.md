# Lab1: Docker maintains an embedded DNS server when a user-defined network is in use.
docker network ls

## 1. Create 2 containers with default bridge driver
```
docker container run -itd --name=first centos:7
docker container run -itd --name=second centos:7
docker exec -it first ping second
docker exec -it second ping second
```

## 2. Create a user-defined docker network
```
docker network create --driver=bridge --subnet=192.168.10.0/24 dknet
```

## 3. Create another 2 containers connected with the new docker network created above
```
docker container run -itd --name=customfirst --net=dknet centos:7
docker container run -itd --name=customsecond --net=dknet centos:7
docker exec -it customfirst ping customsecond
$ docker exec -it customfirst cat /etc/resolv.conf
nameserver 127.0.0.11
```

## 4. Connect the existing containers to the new docker network
```
docker exec first ping second
docker network connect dknet first
docker network connect dknet second
docker exec -it first ping second
docker network disconnect dknet first

```

## 5. Inspect and clean up
```
docker network inspect dknet
docker network rm dknet
docker network prune
```

---
# Lab2: Network Namespace with virtual cable

## 1. Create 2 network namespaces
```
ip netns add red
ip netns add blue
ip netns

ip netns exec red ip link
ip netns exec blue ip link
or
ip -n red link
ip -n blue link

ip netns exec red arp
ip netns exec blud arp
```

## 2. Create a virtual cable to link the 2 network namespaces together
```
ip link add veth-red type veth peer name veth-blue
ip link set veth-red netns red
ip link set veth-blue netns blue
ip netns exec red ip addr
ip netns exec blue ip addr
```

## 3. Assign IP to the virtual interfaces respectively
```
ip -n red addr add 192.168.15.1/24 dev veth-red
ip -n blue addr add 192.168.15.2/24 dev veth-blue
ip netns exec red ip addr
ip netns exec blue ip addr
```

## 4. Bring up the virtual interfaces respectively
```
ip -n red link set veth-red up
ip -n blue link set veth-blue up
ip netns exec red ip link
ip netns exec blue ip link
```

## 5. Verification
```
ip netns exec red ping 192.168.15.2
ip netns exec blue ping 192.168.15.1

ip netns exec red arp
ip netns exec blud arp
arp
```

## 6. Delete the virtual cable and continue the lab 3
```
ip -n red link del veth-red
```
---
# Lab3: Network Namespace with virtual bridge

## 1. Create a virtual bridge
```
ip link add v-net-0 type bridge
ip link
ip link set dev v-net-0 up
```

## 2. Create 2 virtual cables and connect the 2 network nampespaces to the virtual bridge respectively
```
ip link add veth-red type veth peer name veth-red-br
ip link add veth-blue type veth peer name veth-blue-br
ip link set veth-red netns red
ip link set veth-red-br master v-net-0
ip link set veth-blue netns blue
ip link set veth-blue-br master v-net-0
```

## 3. Assign IP and bring up the virtual interfaces
```
ip -n red addr add 192.168.15.1/24 dev veth-red
ip -n blue addr add 192.168.15.2/24 dev veth-blue
ip -n red link set veth-red up
ip -n blue link set veth-blue up
ip link set veth-red-br up
ip link set veth-blue-br up
ping 192.168.15.1
ip addr add 192.168.15.5/24 dev v-net-0
ping 192.168.15.1
```

## 4. Add route/iptables to allow the traffic to the external internet
```
ip netns exec blue ping 8.8.8.8
ip netns exec blue route
ip netns exec blue ip route add default via 192.168.15.5
ip netns exec blue ping 8.8.8.8
iptables -t nat -A POSTROUTING -s 192.168.15.0/24 -j MASQUERADE
```

> Note: If there is any internal host, for instance, 192.168.1.3, you need to add below route in the network namespace
> ip netns exec blue ip route add 192.168.1.0/24 via 192.168.15.5
> iptables -t nat -A PREROUTING --dport 80 --to-destination 192.168.15.2:80 -j DNAT

> Note: the below is how the docker setup the bridge
```
docker run --network=none nginx
docker run --network=host nginx
docker run [--network=bridge] nginx

ip link add docker0 type bridge

iptables \
    -t nat \
    -A PREROUTING \
    -j DNAT \
    --dport 8080 \
    --to-destination 80
iptables -nvL -t nat
```
