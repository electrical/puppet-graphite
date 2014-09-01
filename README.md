# puppet-graphite

A puppet module for managing and configuring graphite

https://github.com/graphite-project

This module is puppet 3 tested

## Usage

Installation, make sure service is running and will be started at boot time:

     class { 'graphite': }

Removal/decommissioning:

     class { 'graphite':
       ensure => 'absent',
     }

Install everything but disable service(s) afterwards:

     class { 'graphite':
       status => 'disabled',
     }

### carbon

Carbon is 1 of the applications for graphite.
You can activate the 3 separate services individually depending on requirements.

Common config variables:

     carbon_config_file => "puppet:///modules/${module_name}/path/to/your/carbon.conf"

#### cache

     carbon_cache_enable => true

#### relay

     carbon_relay_enable => true

#### aggregator

     carbon_aggregator_enable => true

#### storage definitions

For defining the storage methods a define is in place:

     graphite::carbon::cache::storage { 'default_1min_for_1day':
       pattern    => '.*'
       retentions => '60s:1d'
     }

The order of the of storage definitions in the config file is
determined by the order directive.  Each metric storage definition has
a default order of 10.  Lower the value the earlier it will be in the
file.

#### storage aggregation definitions

For defining the aggregation of a metric:

     graphite::carbon::cache::aggregation { 'all_min':
       pattern           => '\.min$',
       xfilesfactor      => 0.1,
       aggregationmethod => 'min',
     }

The order of the of aggregate definitions in the config file is
determined by the order directive.  Each aggregation has a default
order of 10.  Lower the value the earlier it will be in the file.

#### aggregation rules

For defining new aggregation rules:

     graphite::carbon::aggregator::rule { 'cell_total_volumes':
       destination => 'cells.<cell>.total_volumes',
       delay => '10',
       aggregation => 'sum',
       source => 'cells.<cell>.tenants.*.total_volumes',
     }

### web

For the graphite-web there are 2 variables:

     web_dashboard_config_file => "puppet:///modules/${module_name}/path/to/your/dashboard.conf"
     web_local_settings_file   => "puppet:///modules/${module_name}/path/to/your/local_settings.py"

### whisper

Whisper is the storage for all the data.
This one has no special configuration.



## assumptions

Certain assumptions have been made with this module:

1. carbon, graphite-web & whisper are available through a repository.
2. when no config files are specified, the default ones are used.
3. All 3 applications are standard installed.
4. For the 3 processes from carbon; unless activated they are not running.
