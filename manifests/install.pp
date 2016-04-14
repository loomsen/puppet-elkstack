# == Class elkstack::install
#
# This class is called from elkstack for install.
#
class elkstack::install(
  $logstash_main_version = $::elkstack::logstash_main_version,
  $es_main_version = $::elkstack::es_main_version,
  $kibana_main_version = $::elkstack::kibana_main_version,
) {

  exec { 'import elasticsearch key':
    command => '/usr/bin/rpm --import http://packages.elastic.co/GPG-KEY-elasticsearch',
    creates => '/etc/pki/rpm-gpg/GPG-KEY-elasticsearch',
    unless  => "rpm -q gpg-pubkey --qf '%{summary}\n' | grep -qi elasticsearch",
    path    => '/usr/bin',
  } ->

  file { 'elasticsearch repo':
    ensure  => file,
    path    => '/etc/yum.repos.d/elasticsearch.repo',
    content => template('elkstack/elasticsearch.repo.erb'),
  } ->
  file { 'kibana repo':
    ensure  => file,
    path    => '/etc/yum.repos.d/kibana.repo',
    content => template('elkstack/kibana.repo.erb'),
  }
  file { 'logstash repo':
    ensure  => file,
    path    => '/etc/yum.repos.d/logstash.repo',
    content => template('elkstack/logstash.repo.erb'),
  }
  file { '/opt/kibana/optimize/.babelcache.json':
    owner => 'kibana',
  }
  package { $::elkstack::package_name:
    ensure  => present,
    require => [ Exec['import elasticsearch key'], File['elasticsearch repo'], File['kibana repo'] ],
  }
  if $::elkstack::with_nginx {
    package { 'nginx':
      ensure => present,
    }
  }
}
