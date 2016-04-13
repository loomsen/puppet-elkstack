# == Class elkstack::service
#
# This class is meant to be called from elkstack.
# It ensure the service is running.
#
class elkstack::service {

  service { $::elkstack::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
