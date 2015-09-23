echo \"start\" >> log
echo === setup mesosphere rep 1>>log 2>>err
rpm -Uvh http://repos.mesosphere.com/el/7/noarch/RPMS/mesosphere-el-repo-7-1.noarch.rpm 1>>log 2>>err
echo === install mesosphere 1>>log 2>>err
yum -y install mesos marathon chronos 1>log 2>err
echo === setup zookeeper rep 1>>log 2>>err
rpm -Uvh http://archive.cloudera.com/cdh4/one-click-install/redhat/6/x86_64/cloudera-cdh-4-0.x86_64.rpm 1>>log 2>>err
echo === install zookeeper 1>>log 2>>err
yum -y install zookeeper zookeeper-server 1>>log 2>>err
echo === install golang 1>>log 2>>err
yum -y install golang git bind-utils 1>>log 2>>err
echo \"ended\" >> log

