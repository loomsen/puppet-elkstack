class elkstack::plugins {
  exec { 'install license':
    cwd     => '/usr/share/elasticsearch',
    #    path    => '/usr/share/elasticsearch/bin',
    command => '/usr/share/elasticsearch/bin/plugin install license',
    creates => '/usr/share/elasticsearch/plugins/license',
    notify  => Service['elasticsearch'],
  }
  exec { 'install marvel-agent':
    cwd     => '/usr/share/elasticsearch',
    #    path    => '/usr/share/elasticsearch/bin',
    command => '/usr/share/elasticsearch/bin/plugin install marvel-agent',
    creates => '/usr/share/elasticsearch/plugins/marvel-agent',
    notify  => Service['elasticsearch'],
  }
  exec { 'install logstash-input-jdbc':
    cwd     => '/opt/logstash',
    #    path    => '/opt/logstash/bin',
    command => '/opt/logstash/bin/plugin install logstash-input-jdbc',
    creates => '/opt/logstash/vendor/bundle/jruby/1.9/gems/logstash-input-jdbc-3.0.2/',
  }
  exec { 'download psql jdbc driver':
    cwd     => '/usr/share/elasticsearch/lib',
    command => '/usr/bin/wget https://jdbc.postgresql.org/download/postgresql-9.4.1208.jar',
    creates => '/usr/share/elasticsearch/lib/postgresql-9.4.1208.jar',
    notify  => Service['elasticsearch'],
  }
  exec { 'install marvel into kibana':
    cwd     => '/opt/kibana',
    #    path => '/opt/kibana/bin',
    command => '/opt/kibana/bin/kibana plugin --install elasticsearch/marvel/latest',
    creates => '/opt/kibana/installedPlugins/marvel',
    notify  => Service['kibana'],
  }
  exec { 'install sense into kibana':
    cwd     => '/opt/kibana',
    #    path    => '/opt/kibana/bin',
    command => '/opt/kibana/bin/kibana plugin --install elastic/sense',
    creates => '/opt/kibana/installedPlugins/sense',
    notify  => Service['kibana'],
  }
}
