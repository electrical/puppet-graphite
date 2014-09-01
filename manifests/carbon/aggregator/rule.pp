# == define: graphite::carbon::aggregator::rule
#
# This type is used to define aggregation rules.
#
#
# === Parameters
#
# [*destination*]
#  The name of the metric used to store the aggergated data.
#
# [*delay*]
#  How many seconds to cache metrics for before beginning aggregation.
#
# [*aggregation*]
#  The aggregation function one of average, sum, min, max, or last.
#
# [*source*]
#  The source metrics to use for the aggregation.
#
# === Examples
#
# This class may be imported by other classes to use its functionality:
#
# graphite::carbon::aggregator::rule { 'cell_total_volumes':
#   destination => 'cells.<cell>.total_volumes',
#   delay => '10',
#   aggregation => 'sum',
#   source => 'cells.<cell>.tenants.*.total_volumes',
# }
#
#
# === Authors
#
# * Russell Sim <mailto:russell.sim@gmail.com>
#
define graphite::carbon::aggregator::rule(
  $destination,
  $delay,
  $aggregation='average',
  $source,
) {

  file_fragment { "carbon_aggregation_${$name}_${::fqdn}":
    tag     => "carbon_aggregation_rules_${::fqdn}",
    content => template("${module_name}/etc/carbon/aggregation-rules-item.erb");
  }

}
