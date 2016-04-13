# == Class elkstack::params
#
# This class is meant to be called from elkstack.
# It sets variables according to platform.
#
class elkstack::params {
  $package_name = [ 'elasticsearch', 'logstash', 'kibana', 'nginx', 'java' ]
  $service_name = [ 'elasticsearch', 'kibana', 'nginx' ]
  $es_config = [ ]
  $kibana_config = [ ]
  $logstash_config = {}
}
