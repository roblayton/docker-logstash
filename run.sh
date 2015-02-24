#! /bin/bash
ES_HOST=${ES_HOST:-\"+window.location.hostname+\"}
ES_HTTP_PORT=${ES_HTTP_PORT:-9200}
ES_PORT=${ES_PORT:-9300}

cat << EOF > /etc/logstash/conf.d/logstash.conf 
input {
  lumberjack {
    port => 5000
    type => "logs"
    ssl_certificate => "/etc/pki/tls/certs/logstash-forwarder.crt"
    ssl_key => "/etc/pki/tls/certs/logstash-forwarder.key"
  }
}

filter {
  if [type] == "syslog" {
    grok {
      match => { "message" => "%{SYSLOGTIMESTAMP:syslog_timestamp} %{SYSLOGHOST:syslog_hostname} %{DATA:syslog_program}(?:\[%{POSINT:syslog_pid}\])?: %{GREEDYDATA:syslog_message}" }
      add_field => [ "received_at", "%{@timestamp}" ]
      add_field => [ "received_from", "%{host}" ]
    }
    syslog_pri { }
    date {
      match => [ "syslog_timestamp", "MMM  d HH:mm:ss", "MMM dd HH:mm:ss" ]
    }
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
