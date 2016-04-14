# == Class elkstack::params
#
# This class is meant to be called from elkstack.
# It sets variables according to platform.
#
class elkstack::params {
  $es_main_version = '2.x'
  $kibana_main_version = '4.5'
  $logstash_main_version = '2.2'
  $package_name = [ 'elasticsearch', 'logstash', 'kibana', 'nginx', 'java' ]
  $service_name = [ 'elasticsearch', 'kibana', 'nginx' ]
  $es_config = [ ]
  $kibana_config = [ ]
  $logstash_config_output = {}
  $logstash_config_input = {
    input  => {},
    output => {},
  }
}
