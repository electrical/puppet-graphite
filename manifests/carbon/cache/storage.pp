# == define: graphite::carbon::cache::storage
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
define graphite::carbon::cache::storage(
  $pattern,
  $retentions,
  $order = 10
) {

  file_fragment { "${$name}_${::fqdn}":
    tag     => "carbon_cache_storage_config_${::fqdn}",
    content => template("${module_name}/etc/carbon/storage-schemas-item.erb"),
    order   => $order
  }

}
