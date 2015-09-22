# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "bento/centos-7.1"
  #config.vm.network "private_network", auto_config: false
  config.vm.provision "file", source: "etc-hosts", destination: "~/hosts"
  config.vm.provision "shell", inline: "cat hosts > /etc/hosts"

  masters = [
    { name: "node1", ip: "192.168.33.10" }
  ]

  slaves = [
    { name: "node2", ip: "192.168.33.11" },
    { name: "node3", ip: "192.168.33.12" },
  #  { name: "node4", ip: "192.168.33.13" }
  ]

  masters.each do |node|
    config.vm.define node[:name] do |vm|
      config.vm.network "private_network", ip: node[:ip]
      config.vm.hostname = node[:name]
    end
  end

  slaves.each do |node|
    config.vm.define node[:name] do |vm|
      config.vm.network "private_network", ip: node[:ip]
      config.vm.hostname = node[:name]
      config.vm.provision "file", source: "etc-resolv.conf", destination: "~/resolv.conf"
      config.vm.provision "shell", inline: "cat resolv.conf > /etc/resolv.conf"
    end
  end

  config.vm.define "m1" do |m1|
    config.vm.network "private_network", ip: "192.168.33.20"
    config.vm.hostname = "m1"
  end

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]

    vb.memory = "1024"
  end
end
