# == Class: graphite::carbon::relay::service
#
# This class exists to coordinate all service management related actions,
# functionality and logical units in a central place.
#
# <b>Note:</b> "service" is the Puppet term and type for background processes
# in general and is used in a platform-independent way. E.g. "service" means
# "daemon" in relation to Unix-like systems.
#
#
# === Parameters
#
# This class does not provide any parameters.
#
#
# === Examples
#
# This class may be imported by other classes to use its functionality:
#   class { 'graphite::service': }
#
# It is not intended to be used directly by external resources like node
# definitions or other modules.
#
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
class graphite::carbon::relay::service {

  #### Service management

  # set params: in operation
  if $graphite::ensure == 'present' {

    case $graphite::status {
      # make sure service is currently running, start it on boot
      'enabled': {
        $service_ensure = 'running'
        $service_enable = true
      }
      # make sure service is currently stopped, do not start it on boot
      'disabled': {
        $service_ensure = 'stopped'
        $service_enable = false
      }
      # make sure service is currently running, do not start it on boot
      'running': {
        $service_ensure = 'running'
        $service_enable = false
      }
      # do not start service on boot, do not care whether currently running or not
      'unmanaged': {
        $service_ensure = undef
        $service_enable = false
      }
      # unknown status
      # note: don't forget to update the parameter check in init.pp if you
      #       add a new or change an existing status.
      default: {
        fail("\"${graphite::status}\" is an unknown service status value")
      }
    }

  # set params: removal
  } else {

    # make sure the service is stopped and disabled (the removal itself will be
    # done by package.pp)
    $service_ensure = 'stopped'
    $service_enable = false

  }

  if ($graphite::carbon_relay_init_file != undef) {
    file { 'carbon_relay_init_file':
      ensure => present,
      path   => '/etc/init.d/carbon-relay',
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
      source => $graphite::carbon_relay_init_file,
      before => Service['carbon-relay'];
    }
  }

  case $::lsbdistcodename {
    'Trusty': {
      if ($service_ensure == 'running') {
        file_line { 'carbon_relay_default_enable_line':
          line => 'CARBON_RELAY_ENABLED=true',
          path => "${graphite::params::service_default_path}/graphite-carbon",
        }
        file_line { 'carbon_relay_default_disable_line':
          ensure => absent,
          line => 'CARBON_RELAY_ENABLED=false',
          path => "${graphite::params::service_default_path}/graphite-carbon",
        }
      } else {
        file_line { 'carbon_relay_default_enable_line':
          ensure => absert,
          line => 'CARBON_RELAY_ENABLED=true',
          path => "${graphite::params::service_default_path}/graphite-carbon",
        }
        file_line { 'carbon_relay_default_disable_line':
          line => 'CARBON_RELAY_ENABLED=false',
          path => "${graphite::params::service_default_path}/graphite-carbon",
        }
      }
    }
    default: {
      if ($graphite::carbon_relay_default_file != undef) {
        file { 'carbon_relay_default_file':
          ensure => present,
          path   => "${graphite::params::service_default_path}/carbon-relay",
          owner  => 'root',
          group  => 'root',
          mode   => '0644',
          source => $graphite::carbon_relay_default_file,
          before => Service['carbon-relay'];
        }
      }
    }
  }

  # action
  service { 'carbon-relay':
    ensure     => $service_ensure,
    enable     => $service_enable,
    name       => $graphite::params::service_relay_name,
    hasstatus  => $graphite::params::service_relay_hasstatus,
    hasrestart => $graphite::params::service_relay_hasrestart,
    pattern    => $graphite::params::service_relay_pattern,
  }

}
