# Mesos Build Box

Mesos Build Box is a simple development environment for adding features and building new features to Mesos.


## Project Context and Features
The project is designed to be the simplest entry point to have a working Mesos box. The project was started during the Hackathon at Mesoscon Europe 2015 and used as a quick and simple way to add new features to Mesos.
The installation and build process is based on
[http://mesos.apache.org/gettingstarted/](http://mesos.apache.org/gettingstarted/).

## Requirements

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

## Installation

    % git clone https://github.com/zalando-techmonkeys/mesos-build-box.git
    % cd mesos-build-box
    % git clone https://git-wip-us.apache.org/repos/asf/mesos.git mesos-src
    % vim Vagrantfile # switch to Centos7.1 if you like, default is Ubuntu14.04
    % vagrant up
    # now zookeeper, mesos-master, mesos-slave, marathon should run
    # and mesos processes were built from source
    % vagrant ssh

## TODO

- Build and launch Marathon or other frameworks.
- CentOS7.1 will be not fully bootstrapped.
- Issues, ideas and Pull Requests are welcome :)

Please use GitHub issues as starting point for contributions, new
ideas or bugreports.

## Contact

* E-Mail: team-techmonkeys@zalando.de
* IRC on freenode: #zalando-techmonkeys

## License

See [LICENSE](LICENSE) file.
