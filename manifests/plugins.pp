class elkstack::plugins (
  $plugins = $::elkstack::plugins,
){
  
  $plugins.each |$app, $plugin| {
    if ($app == 'elasticsearch') {
      $plugin.each |$p| {
        exec { "install ${p}":
          cwd     => '/usr/share/elasticsearch',
        #    path    => '/usr/share/elasticsearch/bin',
          command => "/usr/share/elasticsearch/bin/plugin install ${p}",
          creates => "/usr/share/elasticsearch/plugins/${p}",
          notify  => Service[$app],
        }
      }
    } elsif ($app == 'logstash') {
      $plugin.each |$p| {
        exec { "install ${p}":
          cwd     => '/opt/logstash',
          command => "/opt/logstash/bin/plugin install ${p}",
          unless  => "/usr/bin/find /opt/logstash/vendor/bundle/jruby/1.9/gems/ -type d | grep ${p}",
        }
      }
    } elsif ($app == 'kibana') {
      $plugin.each |$p| {
        $p_real = regsubst($p, '^(?:[^/]+)/([^/]+)(?:/?.*)$', '\1')
        #        notify { "p_real is: $p_real": }
        exec { "install ${p} into kibana":
          command => "/opt/kibana/bin/kibana plugin --install ${p}",
          creates => "/opt/kibana/installedPlugins/${p_real}",
          notify  => Service['kibana'],
        }
      }
    } elsif ($app == 'drivers') {
      $plugin.each |$p| {
        $driver = regsubst($p, '^(?:.+)/([^/]+)$', '\1')
        notify { "driver is ${driver}": }
        exec { "download ${driver}":
          cwd     => '/usr/share/elasticsearch/lib',
          command => "/usr/bin/wget ${p}",
          creates => "/usr/share/elasticsearch/lib/${driver}",
          notify  => [Service['elasticsearch'],Service['kibana']],
        }

      }
    }
  }
}

