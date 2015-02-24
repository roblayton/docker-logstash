# docker-logstash

`docker run -e ES_HOST=192.168.59.103 -e ES_HTTP_PORT=9200 -e ES_PORT=9300 -d -p 5000:5000 -p 514:514 -p 9292:9292 --name logstash --link elasticsearch:es -t logstash`
