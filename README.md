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
You can activate the 3 separate services individually depending on requirments.

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

An other of sequence can be given with the order => directive.



### web

For the graphite-web there are 2 variables:

     web_dashboard_config_file => "puppet:///modules/${module_name}/path/to/your/dashboard.conf"
     web_local_settings_file   => "${module_name}/etc/graphite-web/local_settings.py.erb"

### whisper

Whisper is the storage for all the data.
This one has no special configuration.



## assumptions

Certain assumptions have been made with this module:

1. carbon, graphite-web & whisper are available through a repository.
2. when no config files are specified, the default ones are used.
3. All 3 applications are standard installed.
4. For the 3 processes from carbon; unless activated they are not running.
