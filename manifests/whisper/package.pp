# == Class: graphite::whisper::package
#
# This class exists to coordinate all software package management related
# actions, functionality and logical units in a central place.
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
#   class { 'graphite::whisper::package': }
#
# It is not intended to be used directly by external resources like node
# definitions or other modules.
#
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
class graphite::whisper::package {

  #### Package management

  # set params: in operation
  if $graphite::ensure == 'present' {

    # Check if we want to install a specific version or not
    if $graphite::version == false {

      $package_ensure = $graphite::autoupgrade ? {
        true  => 'latest',
        false => 'present',
      }

    } else {

      # install specific version
      $package_ensure = $graphite::version

    }

  # set params: removal
  } else {
    $package_ensure = 'purged'
  }

  # action
  package { $graphite::params::whisper_package:
    ensure => $package_ensure,
  }

}
