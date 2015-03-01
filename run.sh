#! /bin/bash
ES_HOST=${ES_HOST:-\"+window.location.hostname+\"}
ES_HTTP_PORT=${ES_HTTP_PORT:-9200}
ES_PORT=${ES_PORT:-9300}

cat << EOF > /etc/logstash/conf.d/logstash.conf 
input {
  syslog {
    type => syslog
    port => 514
  }
  lumberjack {
    port => 5043
    type => "logs"
    ssl_certificate => "/etc/pki/tls/certs/selfsigned.crt"
    ssl_key => "/etc/pki/tls/certs/selfsigned.key"
  }
  udp {
    port => 25826
    buffer_size => 1452
    codec => collectd {typesdb => ["/opt/collectd-types.db"]}
    type => "collectd"
  }
}

output {
  elasticsearch { 
    host => "$ES_HOST"
    port => "$ES_PORT"
  }
  stdout { codec => rubydebug }
}
EOF

/opt/logstash/bin/logstash agent -f /etc/logstash/conf.d/logstash.conf
