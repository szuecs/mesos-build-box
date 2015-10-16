Vagrant.configure(2) do |config|
  config.vm.define :mesos do |mesos_config|
    mesos_config.vm.box = "ubuntu/trusty64"
    mesos_config.vm.provision "shell", path: "bootstrap-ubuntu14.04.sh"
    #mesos_config.vm.box = "centos7.1"
    #mesos_config.vm.provision "shell", path: "bootstrap-centos7.1.sh"
    mesos_config.vm.network  "private_network", ip: "192.168.0.5"
    mesos_config.vm.host_name = "mesos01"
    mesos_config.vm.synced_folder "mesos-src/", "/server/mesos"

    mesos_config.vm.provider :virtualbox do |vb|
      vb.customize ['modifyvm', :id, '--cpus', 3]
      vb.customize ['modifyvm', :id, '--memory', 4000] # customization to support marathon development
    end
  end

end
