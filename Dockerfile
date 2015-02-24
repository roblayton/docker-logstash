FROM java:8-jre
MAINTAINER Rob Layton hire@roblayton.com

# Update APT
RUN apt-get update

# Install build dependencies
RUN apt-get install -y wget

# Install
RUN \
  wget -O - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add - && \
  echo 'deb http://packages.elasticsearch.org/logstash/1.5/debian stable main' | tee /etc/apt/sources.list.d/logstash.list && \
  apt-get update && \
  apt-get install -y logstash=1.5.0.beta1-1

# Install contrib plugins
ADD http://download.elasticsearch.org/logstash/logstash/logstash-contrib-1.4.1.tar.gz /opt/logstash/

# Mount logstash config files
RUN mkdir -p /etc/pki/tls/certs/
ADD certs/logstash-forwarder.key /etc/pki/tls/certs/logstash-forwarder.key
ADD certs/logstash-forwarder.crt /etc/pki/tls/certs/logstash-forwarder.crt

ADD run.sh /usr/local/bin/run
RUN chmod +x /usr/local/bin/run

# Define default command.
CMD ["/usr/local/bin/run"]

# Expose ports.
#   - 5000: Lumberjack
#   - 514: Syslog
EXPOSE 5000 514
