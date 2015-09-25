# Mesos Advanced Course Vagrantfile

Upon boot `/etc/resolv.conf` is set (most likely by the NetworkManager).
Vagrant manages `/etc/sysconfig/network-scripts/ifcfg-enp0s8` and the comment
in the file advises against editing this file which means that setting `DNS1`
and `DNS2` in this file is futile.


The Vagrantfile ensures that `/etc/resolv.conf` reflects the setup we want.
It is far from a sound solution, but it was the quickest one I could come up
with after I gave up on finding the way to instruct Vagrant how to handle this.

The answer must be pretty simple, but I'm not having a bright streak here and
the show must go on.


# Setup
The following steps are taken to setup a machine to serve as master:

 1. copy `etc-hosts` to VM
 2. overwrite the contents of the VM's `/etc/hosts` with `etc-hosts`
 -  copy `etc-resolv.conf` to the VM
 -  if master specify master-specifics
   - set vagrant network to `private_network`
   - set vm hostname
   - copy `install.bash` to VM
   - execute `install.bash` to install `mesos`, `zookeeper` and `go`
   - copy `build-mesos-dns.bash` to VM
   - execute `build-mesos-dns.bash` to build and install `mesos-dns`
   - start zookeeper-server with appropriate id
   - start `mesos-master`, `mesos-slave`, `marathon` and `chronos` services
   - copy `chkconfig.bash` to VM
   - execute `chkconfig.bash`
   - write `/etc/resolv.conf` at this stage, all installations have used the host network's DNS server for resolution so we know our Mesos DNS configuration could not have messed this up.
   - populate Mesos DNS configuration to `mesos-dns.config.json`
   - start Marathon job for Mesos DNS
 -  if slave specify slave-specifics
   - copy `install-slave.bash` to VM
   - execute `install-slave.bash` to install `mesos`
   - setup zookeeper endpoint in `/etc/mesos/zk`
   - start mesos-slave service
   - copy `chkconfig.bash` to VM
   - execute `chkconfig.bash`

$$ Troubleshoot

When running into the ```Host ndoeX not found: 3(NXDOMAIN)``` ensure
that `/etc/hosts` contains a record for the respective host.

The `/etc/hosts` file currently contains records for all hosts, spawnable by
this project's Vagrantfile.

