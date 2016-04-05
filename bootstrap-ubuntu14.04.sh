#!/bin/bash

sudo cat >/etc/resolv.conf <<EOF
nameserver 8.8.8.8
EOF

### docker PRE req
sudo cat >/etc/apt/sources.list.d/docker.list <<EOF
deb https://apt.dockerproject.org/repo ubuntu-trusty main
EOF
sudo /usr/bin/apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
sudo mkdir -p /var/lib/docker
sudo mkdir /selinux
sudo mount -t tmpfs -o size=4k,mode=755 tmpfs /selinux

### install docker
sudo apt-get update
sudo apt-get install -y docker-engine

### PRE req for building mesos + docker-engine
sudo apt-get install -y git-core autoconf libtool
sudo apt-get install -y openjdk-7-jdk
sudo apt-get install -y build-essential python-dev python-boto libcurl4-nss-dev libsasl2-dev maven libapr1-dev libsvn-dev

### build mesos
if [ -d /server/mesos ]
then
  # if you use synced folder in the Vagrantfile
  cd /server/mesos
else
  mkdir /server
  cd /server
  git clone https://git-wip-us.apache.org/repos/asf/mesos.git
  cd mesos/
fi

# Bootstrap (Only required if building from git repository).
./bootstrap
# Configure and build.
mkdir build
cd build
../configure
make -j 4 V=0
#make check
sudo make install # install with PREFIX /usr/local/

### mesos config
test -d /var/log/mesos || sudo mkdir -p /var/log/mesos
test -d /data/mesos || sudo mkdir -p /data/mesos
test -d /etc/mesos || sudo mkdir /etc/mesos
sudo cat >/etc/mesos/zk <<EOF
zk://127.0.0.1:2181/mesos
EOF

### zookeeper
sudo apt-get install -y zookeeper zookeeper-bin zookeeperd
sudo cat >/etc/default/zookeeper <<EOF
## generic config
JAVA_OPTS="$JAVA_OPTS -server"
JAVA_OPTS="$JAVA_OPTS -verbose:gc"
JAVA_OPTS="$JAVA_OPTS -XX:+DisableExplicitGC"
JAVA_OPTS="$JAVA_OPTS -XX:+PrintGCTimeStamps"
JAVA_OPTS="$JAVA_OPTS -XX:+PrintGCDateStamps"
JAVA_OPTS="$JAVA_OPTS -XX:+UseConcMarkSweepGC"
JAVA_OPTS="$JAVA_OPTS -XX:+HeapDumpOnOutOfMemoryError"
JAVA_OPTS="$JAVA_OPTS -XX:-OmitStackTraceInFastThrow"

## memory config
#JAVA_OPTS="$JAVA_OPTS -XX:MaxPermSize=128m"
JAVA_OPTS="$JAVA_OPTS -Xmx512m -Xms128m"

## TODO: jmx config
#JAVA_OPTS="$JAVA_OPTS -Dcom.sun.management.jmxremote"
#JAVA_OPTS="$JAVA_OPTS -Dcom.sun.management.jmxremote.port=$JMX_PORT"
#JAVA_OPTS="$JAVA_OPTS -Dcom.sun.management.jmxremote.authenticate=true"
#JAVA_OPTS="$JAVA_OPTS -Dcom.sun.management.jmxremote.ssl=false"
#JAVA_OPTS="$JAVA_OPTS -Dcom.sun.management.jmxremote.password.file=$CATALINA_HOME/conf/jmxremote.password"
#JAVA_OPTS="$JAVA_OPTS -Dcom.sun.management.jmxremote.access.file=$CATALINA_HOME/conf/jmxremote.access"
EOF

test -d /data/zookeeper || sudo mkdir -p /data/zookeeper
sudo chown zookeeper: /data/zookeeper
test -d /etc/zookeeper/conf || sudo mkdir -p /etc/zookeeper/conf
sudo cat >/etc/zookeeper/conf/zoo.cfg <<EOF
tickTime=2000
dataDir=/data/zookeeper
clientPort=2181
initLimit=5
syncLimit=2
server.1=127.0.0.1:2888:3888
EOF
sudo echo 1 >/etc/zookeeper/conf/myid


### start processes
service zookeeper restart
LD_PRELOAD=/usr/local/lib/libmesos-0.26.0.so /usr/local/sbin/mesos-master \
  --work_dir=/data/mesos \
  --zk=zk://127.0.0.1:2181/mesos \
  --port=5050 \
  --log_dir=/var/log/mesos \
  --quorum=1 >/var/log/mesos/master-stdout 2>/var/log/mesos/master-stderr &

LD_PRELOAD=/usr/local/lib/libmesos-0.26.0.so /usr/local/sbin/mesos-slave \
  --master=zk://127.0.0.1:2181/mesos \
  --log_dir=/var/log/mesos \
  --containerizers=docker,mesos \
  --executor_registration_timeout=5mins \
  --ip=192.168.0.5 \
  --work_dir=/data/mesos >/var/log/mesos/slave-stdout 2>/var/log/mesos/slave-stderr &
