# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.synced_folder "~", "/home/anonymous"
  config.vm.provision "shell", path: "setup/bootstrap.sh", privileged: false
  config.vm.provision "shell", path: "setup/common.sh", privileged: false
  config.vm.define "master", autostart: true, primary: true do |server|
    server.vm.network "forwarded_port", guest: 8080, host: 8080
    server.vm.network "forwarded_port", guest: 9000, host: 9000
    server.vm.network "private_network", ip: "192.168.33.10", virtualbox__intnet: "intnet0"
    server.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.cpus = "1"
    end
    server.vm.provision "shell", path: "setup/master.sh", privileged: false
    server.vm.provision "shell", path: "setup/credentials.sh", privileged: false
  end
  config.vm.define "slave", autostart: false do |server|
    server.vm.network "private_network", ip: "192.168.33.11", virtualbox__intnet: "intnet0"
    server.vm.provider "virtualbox" do |vb|
      vb.memory = "4096"
      vb.cpus = "4"
    end
    server.vm.provision "shell", path: "setup/slave.sh", args: "slave http://192.168.33.10:8080", privileged: false
    server.vm.provision "shell", path: "setup/credentials.sh", privileged: false
  end
end
