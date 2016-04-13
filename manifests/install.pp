# == Class elkstack::install
#
# This class is called from elkstack for install.
#
class elkstack::install {

  exec { 'import elasticsearch key':
    command => '/usr/bin/rpm --import http://packages.elastic.co/GPG-KEY-elasticsearch',
    creates => '/etc/pki/rpm-gpg/GPG-KEY-elasticsearch',
  } ->

  file { 'elasticsearch repo':
    ensure  => file,
    path    => '/etc/yum.repos.d/elasticsearch.repo',
    content => file('elkstack/elasticsearch.repo'),
  } ->
  file { 'kibana repo':
    ensure  => file,
    path    => '/etc/yum.repos.d/kibana.repo',
    content => file('elkstack/kibana.repo'),
  }
  file { 'logstash repo':
    ensure  => file,
    path    => '/etc/yum.repos.d/logstash.repo',
    content => file('elkstack/logstash.repo'),
  }
  file { '/opt/kibana/optimize/.babelcache.json':
    owner => 'kibana',
  }
  package { $::elkstack::package_name:
    ensure  => present,
    require => [ Exec['import elasticsearch key'], File['elasticsearch repo'], File['kibana repo'] ],
  }
}
