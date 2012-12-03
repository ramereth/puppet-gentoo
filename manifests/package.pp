# = Define: portage::package
#
# Configures and install portage backed packages
#
# == Parameters
#
# [*ensure*]
#
# The ensure value of the package.
#
# [*use*]
#
# Use flags for the package.
#
# [*keywords*]
#
# Portage keywords for the package.
#
# [*target*]
#
# A default value for package.* targets
#
# [*use_target*]
#
# An optional custom target for package use flags
#
# [*keywords_target*]
#
# An optional custom target for package keywords
#
# [*mask_target*]
#
# An optional custom target for package masks
#
# [*unmask_target*]
#
# An optional custom target for package unmasks
#
# == Example
#
#     portage::package { 'app-admin/puppet':
#       ensure   => '3.0.1',
#       use      => ['augeas', '-rrdtool'],
#       keywords => '~amd64',
#       target   => 'puppet',
#     }
#
# == See Also
#
#  * `puppet describe package_use`
#  * `puppet describe package_keywords`
#  * `puppet describe package_mask`
#  * `puppet describe package_unmask`
#
define portage::package (
    $ensure          = undef,
    $use             = undef,
    $keywords        = undef,
    $target          = undef,
    $use_target      = undef,
    $keywords_target = undef,
    $mask_target     = undef,
    $unmask_target   = undef,
) {

  if $target {
    if $use_target      { $assigned_use_target      = $use_target      }
    if $keywords_target { $assigned_keywords_target = $keywords_target }
    if $mask_target     { $assigned_mask_target     = $mask_target     }
    if $unmask_target   { $assigned_unmask_target   = $unmask_target   }
  }

  if $keywords {
    package_keywords { $name:
      keywords => $keywords,
      target   => $assigned_keywords_target,
      before   => Package[$name],
    }
  }
  if $unmask {
    package_unmask { $name:
      target => $assigned_unmask_target,
      before => Package[$name],
    }
  }
  if $mask {
    package_mask { $name:
      target => $assigned_mask_target,
      before => Package[$name],
    }
  }
  if $use {
    package_use { $name:
      use    => $use,
      target => $assigned_use_target,
      before => Package[$name],
      notify => Exec["changed_package_use"],
    }
    exec {"changed_package_use":
      command     => "/usr/bin/emerge --reinstall=changed-use ${name}",
      refreshonly => true,
    }
  }
  package { $name:
    ensure => $ensure,
  }
}
