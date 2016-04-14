# == Class elkstack::service
#
# This class is meant to be called from elkstack.
# It ensure the service is running.
#
class elkstack::service {

  Service {
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
  service { $::elkstack::service_name:
  }
  if $::elkstack::with_nginx {
    service { 'nginx':
    }
  }


}
