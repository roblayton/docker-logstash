FROM java:8-jre
MAINTAINER Rob Layton hire@roblayton.com

# Update APT
RUN apt-get update

# Install build dependencies
RUN apt-get install -y wget git

# Install
RUN \
  wget -O - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add - && \
  echo 'deb http://packages.elasticsearch.org/logstash/1.5/debian stable main' | tee /etc/apt/sources.list.d/logstash.list && \
  apt-get update && \
  apt-get install -y logstash

# Mount logstash config files
RUN mkdir -p /etc/pki/tls/certs/
ADD certs/selfsigned.key /etc/pki/tls/certs/selfsigned.key
ADD certs/selfsigned.crt /etc/pki/tls/certs/selfsigned.crt

ADD run.sh /usr/local/bin/run
RUN chmod +x /usr/local/bin/run

ADD config/collectd-types.db /opt/collectd-types.db

# Define default command.
CMD ["/usr/local/bin/run"]

# Expose ports.
#   - 5000: Lumberjack
#   - 514: Syslog
EXPOSE 5000 514
