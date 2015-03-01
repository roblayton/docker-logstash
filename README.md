docker-logstash
===============

```
# generate certificates
# when prompted, enter the boot2docker ip address
cd certs
./lc-tlscert
```
Make sure to copy the .crt into your logstash-forwarder/certs directory after [cloning it](http://github.com/roblayton/docker-logstash-forwarder)

```
# build the image
cd ~/dockerfiles/docker-logstash
docker build -t logstash .

# run and link the container to elasticsearch
docker run -e ES_HOST=<BOOT2DOCKERIP> -e ES_HTTP_PORT=9200 -e ES_PORT=9300 -d -p 5043:5043 -p 9292:9292 --name logstash --link elasticsearch:es -t logstash
```
