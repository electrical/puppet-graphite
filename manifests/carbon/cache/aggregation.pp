# == define: graphite::carbon::cache::aggregation
#
# This type defines how aggergations occur in carbon.
#
#
# === Parameters
#
# [*pattern*]
#  The pattern to match metrics with.
#
# [*xfilesfactor*]
#  A floating point number between 0 and 1, and specifies what
#  fraction of the previous retention level’s slots must have non-null
#  values in order to aggregate to a non-null value. The default is
#  0.5.
#
# [*aggregationmethod*]
#  The function used to aggregate values for the next retention
#  level. Legal methods are average, sum, min, max, or last. The
#  default is average.
#
# === Examples
#
# graphite::carbon::cache::aggregation { 'all_min':
#   pattern           => '\.min$',
#   xfilesfactor      => 0.1,
#   aggregationmethod => 'min',
# }
#
#
# === Authors
#
# * Russell Sim <mailto:russell.sim@gmail.com>
#
define graphite::carbon::cache::aggregation(
  $pattern,
  $xfilesfactor = undef,
  $aggregationmethod = undef,
  $order = 10
) {

  file_fragment { "carbon_storage_aggregation_${$name}_${::fqdn}":
    tag     => "carbon_storage_aggregation_config_${::fqdn}",
    content => template("${module_name}/etc/carbon/storage-aggregation-item.erb"),
    order   => $order;
  }

}
