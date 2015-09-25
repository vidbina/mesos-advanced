export GOPATH=/usr/local/src/go
go get github.com/golang/example/outyet
cd $GOPATH/src/github.com/golang/example/outyet
docker build -t outyet .
echo 'docker,mesos' | sudo tee /etc/mesos-slave/containerizers
service mesos-slave restart
# NOTE: for the following reason just build one master at a time
docker save --output=/vagrant/outyet.tar.gz outyet
