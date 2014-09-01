# == Class: graphite::aggregator::config
#
# This class provides the configuration for the graphite aggregator
# service.
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
#   class { 'graphite::carbon::aggregator::config': }
#
# It is not intended to be used directly by external resources like node
# definitions or other modules.
#
#
# === Authors
#
# * Russell Sim <mailto:russell.sim@gmail.com>
#
class graphite::carbon::aggregator::config {

  #### Configuration

  file_fragment { "carbon_aggregation_header_${::fqdn}":
    tag     => "carbon_aggregation_rules_${::fqdn}",
    content => template("${module_name}/etc/carbon/aggregation-rules-header.erb"),
    order   => 01
  }

  file_concat { '/etc/carbon/aggregation-rules.conf':
    tag     => "carbon_aggregation_rules_${::fqdn}",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => File['/etc/carbon']
  }

}
