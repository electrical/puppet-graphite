# == Class: graphite::carbon
#
# This class is able to install or remove graphite carbon cache on a node.
# It manages the status of the related service.
#
#
# === Parameters
#
# [*ensure*]
#   String. Controls if the managed resources shall be <tt>present</tt> or
#   <tt>absent</tt>. If set to <tt>absent</tt>:
#   * The managed software packages are being uninstalled.
#   * Any traces of the packages will be purged as good as possible. This may
#     include existing configuration files. The exact behavior is provider
#     dependent. Q.v.:
#     * Puppet type reference: {package, "purgeable"}[http://j.mp/xbxmNP]
#     * {Puppet's package provider source code}[http://j.mp/wtVCaL]
#   * System modifications (if any) will be reverted as good as possible
#     (e.g. removal of created users, services, changed log settings, ...).
#   * This is thus destructive and should be used with care.
#   Defaults to <tt>present</tt>.
#
# [*autoupgrade*]
#   Boolean. If set to <tt>true</tt>, any managed package gets upgraded
#   on each Puppet run when the package provider is able to find a newer
#   version than the present one. The exact behavior is provider dependent.
#   Q.v.:
#   * Puppet type reference: {package, "upgradeable"}[http://j.mp/xbxmNP]
#   * {Puppet's package provider source code}[http://j.mp/wtVCaL]
#   Defaults to <tt>false</tt>.
#
# [*status*]
#   String to define the status of the service. Possible values:
#   * <tt>enabled</tt>: Service is running and will be started at boot time.
#   * <tt>disabled</tt>: Service is stopped and will not be started at boot
#     time.
#   * <tt>running</tt>: Service is running but will not be started at boot time.
#     You can use this to start a service on the first Puppet run instead of
#     the system startup.
#   * <tt>unmanaged</tt>: Service will not be started at boot time and Puppet
#     does not care whether the service is running or not. For example, this may
#     be useful if a cluster management software is used to decide when to start
#     the service plus assuring it is running on the desired node.
#   Defaults to <tt>enabled</tt>. The singular form ("service") is used for the
#   sake of convenience. Of course, the defined status affects all services if
#   more than one is managed (see <tt>service.pp</tt> to check if this is the
#   case).
#
# [*version*]
#   String to set the specific version you want to install.
#   Defaults to <tt>false</tt>.
#
# The default values for the parameters are set in graphite::params. Have
# a look at the corresponding <tt>params.pp</tt> manifest file if you need more
# technical information about them.
#
#
# === Examples
#
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
class graphite::carbon(
  $ensure            = $graphite::params::ensure,
  $autoupgrade       = $graphite::params::autoupgrade,
  $status            = $graphite::params::status,
  $version           = false,
  $cache_enable      = false,
  $relay_enable      = false,
  $aggregator_enable = false,
  $config_file       = "puppet:///modules/${module_name}/etc/carbon/carbon.conf"
) inherits graphite::params {

  #### Validate parameters

  # ensure
  if ! ($ensure in [ 'present', 'absent' ]) {
    fail("\"${ensure}\" is not a valid ensure parameter value")
  }

  # autoupgrade
  validate_bool($autoupgrade)

  # service status
  if ! ($status in [ 'enabled', 'disabled', 'running', 'unmanaged' ]) {
    fail("\"${status}\" is not a valid status parameter value")
  }

  validate_bool($cache_enable)
  validate_bool($relay_enable)
  validate_bool($aggregator_enable)


  #### Manage actions

  # package(s)
  class { 'graphite::carbon::package': }

  # configuration
  class { 'graphite::carbon::config': }

  # service(s)
  if $cache_enable == true {
    class { 'graphite::carbon::cache::service': }
  }

  if $relay_enable == true {
    class { 'graphite::carbon::relay::service': }
  }

  if $aggregator_enable == true {
    class { 'graphite::carbon::aggregator::config': }
    class { 'graphite::carbon::aggregator::service': }
  }

  #### Manage relationships

  if $ensure == 'present' {

    if $cache_enable == true {
      Class['graphite::carbon::package'] -> Class['graphite::carbon::cache::service']
      Class['graphite::carbon::config']  -> Class['graphite::carbon::cache::service']
    }

    if $relay_enable == true {
      Class['graphite::carbon::package'] -> Class['graphite::carbon::relay::service']
      Class['graphite::carbon::config']  -> Class['graphite::carbon::relay::service']
    }

    if $aggregator_enable == true {
      Class['graphite::carbon::config']  -> Class['graphite::carbon::aggregator::config']
      Class['graphite::carbon::aggregator::config']  -> Class['graphite::carbon::aggregator::service']
      Class['graphite::carbon::package'] -> Class['graphite::carbon::aggregator::service']
      Class['graphite::carbon::config']  -> Class['graphite::carbon::aggregator::service']
    }

    graphite::carbon::cache::storage { 'default_1min_for_1day':
      pattern    => '.*',
      retentions => '60s:1d'
    }

    # we need the software before configuring it
    Class['graphite::carbon::package'] -> Class['graphite::carbon::config']

  } else {

    # make sure all services are getting stopped before software removal
    if $cache_enable == true {
      Class['graphite::carbon::cache::service'] -> Class['graphite::carbon::package']
    }

    if $relay_enable == true {
      Class['graphite::carbon::relay::service'] -> Class['graphite::carbon::package']
    }

    if $aggregator_enable == true {
      Class['graphite::carbon::aggregator::service'] -> Class['graphite::carbon::package']
    }

  }

}
