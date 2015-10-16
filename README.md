# Mesos Development Environment

The installation and build process is based on
[http://mesos.apache.org/gettingstarted/](http://mesos.apache.org/gettingstarted/).

## Prerequisites

Install:
- virtualbox
- vagrant

Depending on which target environment you want to develop Ubuntu14.04
or CentOS7.1 get your vagrant box.

### Ubuntu14.04

    % vagrant box add ubuntu/trusty64 https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box

### CentOS7.1

    % vagrant box add centos7.1 https://github.com/holms/vagrant-centos7-box/releases/download/7.1.1503.001/CentOS-7.1.1503-x86_64-netboot.box
    vagrant box

## Install

    % git clone https://github.com/zalando-techmonkeys/mesos-build-box.git
    % cd mesos-build-box
    % git clone https://git-wip-us.apache.org/repos/asf/mesos.git mesos-src
    % vim Vagrantfile # switch to Centos7.1 if you like, default is Ubuntu14.04
    % vagrant up
    # now zookeeper, mesos-master, mesos-slave, marathon should run
    # and mesos processes were built from source
    % vagrant ssh

## TODO

- Build marathon with new protobuf if you change the protobuf in mesos.
- CentOS7.1 will be not fully bootstrapped. Pull Requests are welcome :)
