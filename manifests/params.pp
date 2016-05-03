# == Class elkstack::params
#
# This class is meant to be called from elkstack.
# It sets variables according to platform.
#
class elkstack::params {
  $es_config              = []
  $es_main_version        = '2.x'
  $kibana_config          = [
    'elasticsearch.url: "http://localhost:9200"',
    'server.host: localhost',
  ]
  $kibana_main_version    = '4.5'
  $logstash_config_input  = {}
  $logstash_config_filter = {}
  $logstash_config_output = {
    '99-elasticsearch' => [
      'hosts           => ["localhost:9200"]',
      'sniffing        => true',
      'manage_template => false',
    ],
  }
  $logstash_main_version  = '2.2'
  $package_name           = [ 'elasticsearch', 'logstash', 'kibana', 'java' ]
  $plugins                = {
    elasticsearch => ['license', 'marvel-agent'],
    logstash      => ['logstash-input-jdbc'],
    kibana        => ['elasticsearch/marvel/latest', 'elastic/sense'],
    drivers       => [],
  }
  $service_name           = [ 'elasticsearch', 'kibana', 'logstash' ]
  $with_nginx             = true
}
