export GOPATH=/usr/local/src/go
mkdir -p $GOPATH
export PATH=$PATH:$GOPATH/bin
go get github.com/tools/godep
go get github.com/mesosphere/mesos-dns
ln -s $GOPATH/bin/mesos-dns /usr/local/bin/.
chmod a+x /usr/local/bin/mesos-dns
