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
