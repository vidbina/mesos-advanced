# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "bento/centos-7.1"
  #config.vm.network "private_network", auto_config: false
  config.vm.provision "file", source: "etc-hosts", destination: "~/hosts", run: "always"
  config.vm.provision "shell", inline: "cat hosts > /etc/hosts", run: "always"

  config.vm.provision "file", source: "etc-resolv.conf", destination: "~/resolv.conf", run: "always"

  masters = [
    { name: "node1", ip: "192.168.33.10", zk_id: 1, short: "n1" },
    { name: "node4", ip: "192.168.33.13", zk_id: 2, short: "n4" }
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

      config.vm.provision "shell", inline: "echo === zookeeper init #{node[:zk_id]} 1>>log 2>>err; pwd 1>>log 2>>err;"
      config.vm.provision "shell", inline: "sudo -u zookeeper zookeeper-server-initialize --myid=#{node[:zk_id]} 1>>log 2>>err"
      config.vm.provision "shell", inline: "service zookeeper-server start"
      config.vm.provision "shell", inline: "service mesos-master start"
      config.vm.provision "shell", inline: "service mesos-slave start"
      config.vm.provision "shell", inline: "service marathon start"
      config.vm.provision "shell", inline: "service chronos start"

      config.vm.provision "file", source: "chkconfig.bash", destination: "~/chkconfig.bash"
      config.vm.provision "shell", inline: "bash chkconfig.bash"

      # set internal nameservers in /etc/resolv.conf
      config.vm.provision "file", source: "etc-resolv.conf", destination: "~/resolv.conf"
      config.vm.provision "shell", run: "always", inline: "cat resolv.conf > /etc/resolv.conf"

      # build mesos-dns configuration
      node_mesos_dns_conf = ".#{node[:name]}.mesos-dns-config.json"
      mesos_dns_config = File.read("mesos-dns-config.json").
        gsub("{{MASTER}}", "#{node[:ip]}:2181/mesos").
        gsub("{{MASTERS}}", masters.map { |m| "\"#{m[:ip]}:5050\"" }.join(", ")).
        gsub("{{SOAM}}", node[:short]).
        gsub("{{SOAR}}", node[:short])
      open node_mesos_dns_conf, "w" do |file|
        file.puts mesos_dns_config
      end
      # write mesos-dns configuration to server
      config.vm.provision "file",
        source: node_mesos_dns_conf, destination: "~/mesos-dns.config.json"

      # copy mesos-dns job for marathon to server
      config.vm.provision "file", run: "always",
        source: "mesos-dns.marathon.json", destination: "~/mesos-dns.marathon.json"

      config.vm.provision "shell", inline: "service docker restart"
      config.vm.provision "file", source: "build-outyet.bash", destination: "~/build-outyet.bash"
      config.vm.provision "shell", inline: "bash build-outyet.bash"

      # NOTE: start marathon after docker is installed
      config.vm.provision "shell",
        inline: "curl -XPOST -d@mesos-dns.marathon.json --header \"Content-Type:application/json\" #{node[:ip]}:8080/v2/apps?force=true"
      config.vm.provision "shell",
        inline: "curl -XPOST #{node[:ip]}:8080/v2/apps -d@/vagrant/outyet.docker.marathon.json -H\"Content-Type:application/json\""
    end
  end

  #config.vm.provision "shell", inline: "cat resolv.conf > /etc/resolv.conf", run: "always"

  slaves.each do |node|
    config.vm.define node[:name] do |vm|
      config.vm.network "private_network", ip: node[:ip]
      config.vm.hostname = node[:name]

      # FIX: be consitent either build etc-resolv.conf (see master) or copy
      config.vm.provision "file", source: "etc-resolv.conf", destination: "~/resolv.conf"
      config.vm.provision "shell", inline: "cat resolv.conf > /etc/resolv.conf", run: "always"

      config.vm.provision "file", source: "install-slave.bash", destination: "~/install.bash"
      config.vm.provision "shell", inline: "bash install.bash"

      config.vm.provision "shell", inline: "service mesos-slave start"
      config.vm.provision "shell", inline: "service docker start"

      # TODO: be less explicit about this
      config.vm.provision "shell", inline: "echo zk://192.168.33.13:2181/mesos > /etc/mesos/zk"
      config.vm.provision "shell", inline: "service mesos-slave restart 1>>log 2>>err"
      
      config.vm.provision "file", source: "chkconfig-slave.bash", destination: "~/chkconfig.bash"
      config.vm.provision "shell", inline: "bash chkconfig.bash"

      config.vm.provision "shell", inline: "docker load --input=/vagrant/outyet.tar.gz"
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
