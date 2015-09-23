# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "bento/centos-7.1"
  #config.vm.network "private_network", auto_config: false
  config.vm.provision "file", source: "etc-hosts", destination: "~/hosts"
  config.vm.provision "shell", inline: "cat hosts > /etc/hosts"

  masters = [
    { name: "node1", ip: "192.168.33.10", zk_id: 1 },
    { name: "node4", ip: "192.168.33.13", zk_id: 2 }
  ]

  slaves = [
    { name: "node2", ip: "192.168.33.11" },
    { name: "node3", ip: "192.168.33.12" },
    { name: "node5", ip: "192.168.33.14" }
  ]

  masters.each do |node|
    config.vm.define node[:name] do |vm|
      config.vm.network "private_network", ip: node[:ip]
      config.vm.hostname = node[:name]

      config.vm.provision "file", source: "install.bash", destination: "~/install.bash"
      config.vm.provision "shell", inline: "bash install.bash"

      config.vm.provision "file", source: "build-mesos-dns.bash", destination: "~/build-mesos-dns.bash"
      config.vm.provision "shell", inline: "bash build-mesos-dns.bash"
      config.vm.provision "shell", inline: "sudo -u zookeeper zookeeper-server-initialize --myid=#{node[:zk_id]} 1>>log 2>>err"

      config.vm.provision "file", source: "chkconfig.bash", destination: "~/chkconfig.bash"
      config.vm.provision "shell", inline: "bash chkconfig.bash"
    end
  end

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]

    vb.memory = "1024"
  end
end
