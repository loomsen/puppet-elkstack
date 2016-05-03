# Class: elkstack
# ===========================
#
# Full description of class elkstack here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'elkstack':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2016 Your name here, unless otherwise noted.
#
class elkstack (
  $es_main_version        = $::elkstack::params::es_main_version,
  $kibana_main_version    = $::elkstack::params::kibana_main_version,
  $logstash_main_version  = $::elkstack::params::logstash_main_version,
  $package_name           = $::elkstack::params::package_name,
  $plugins                = $::elkstack::params::plugins,
  $es_config              = $::elkstack::params::es_config,
  $kibana_config          = $::elkstack::params::kibana_config,
  $logstash_config_filter = $::elkstack::params::logstash_config_filter,
  $logstash_config_input  = $::elkstack::params::logstash_config_input,
  $logstash_config_output = $::elkstack::params::logstash_config_output,
  $with_nginx             = $::elkstack::params::with_nginx,
) inherits ::elkstack::params {
  class {'::elkstack::install': } ->
  class {'::elkstack::config': } ~>
  class {'::elkstack::service': }
  class {'::elkstack::plugins': }
  contain '::elkstack::install'
  contain '::elkstack::config'
  contain '::elkstack::service'
  contain '::elkstack::plugins'
}
