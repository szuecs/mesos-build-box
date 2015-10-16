#!/bin/bash

# Install a few utility tools
sudo yum install -y tar wget

# Fetch the Apache Maven repo file.
sudo wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo

# 'Mesos > 0.21.0' requires 'subversion > 1.8' devel package, which is
# not available in the default repositories.
# Add the WANdisco SVN repo file: '/etc/yum.repos.d/wandisco-svn.repo' with content:

[WANdiscoSVN]
name=WANdisco SVN Repo 1.9
enabled=1
baseurl=http://opensource.wandisco.com/centos/7/svn-1.9/RPMS/$basearch/
gpgcheck=1
gpgkey=http://opensource.wandisco.com/RPM-GPG-KEY-WANdisco

# Install essential development tools.
sudo yum groupinstall -y "Development Tools"

# Install other Mesos dependencies.
sudo yum install -y apache-maven python-devel java-1.7.0-openjdk-devel zlib-devel libcurl-devel openssl-devel cyrus-sasl-devel cyrus-sasl-md5 apr-devel subversion-devel apr-util-devel


mkdir /server

cd /server
git clone https://git-wip-us.apache.org/repos/asf/mesos.git
cd mesos/
# Bootstrap (Only required if building from git repository).
./bootstrap
# Configure and build.
mkdir build
cd build
../configure
make -j 4 V=0

#make check

#make install
