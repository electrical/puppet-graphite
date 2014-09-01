# == define: graphite::carbon::cache::storage
#
# This type defines how metrics are stored by carbon.
#
#
# === Parameters
#
# [*pattern*]
#  The pattern to match metrics with.
#
# [*retention*]
#  How long the metrics are stored in for.
#
# === Examples
#
# graphite::carbon::cache::storage { 'apache_busyWorkers':
#   pattern    => '^servers\.www.*\.workers\.busyWorkers$',
#   retentions => '15s:7d,1m:21d,15m:5y',
# }
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

  file_fragment { "carbon_storage_${$name}_${::fqdn}":
    tag     => "carbon_cache_storage_config_${::fqdn}",
    content => template("${module_name}/etc/carbon/storage-schemas-item.erb"),
    order   => $order
  }

}
