# = Define: portage::package
#
# Configures and installs a package with portage-specific configuration
define portage::package (
    $ensure          = undef,
    $package         = $title,
    $use             = undef,
    $keywords        = undef,
    $use_target      = undef,
    $keywords_target = undef,
    $mask_target     = undef,
    $unmask_target   = undef,
    $target          = undef,
  ) {
  if $target {

    if $use_target      { $assigned_use_target      = $use_target      }
    if $keywords_target { $assigned_keywords_target = $keywords_target }
    if $mask_target     { $assigned_mask_target     = $mask_target     }
    if $unmask_target   { $assigned_unmask_target   = $unmask_target   }
  }

  if $keywords {
    package_keywords { $package:
      keywords => $keywords,
      target   => $assigned_keywords_target,
      before   => Package[$package],
    }
  }
  if $unmask {
    package_unmask { $package:
      target => $assigned_unmask_target,
      before => Package[$package],
    }
  }
  if $mask {
    package_mask { $package:
      target => $assigned_mask_target,
      before => Package[$package],
    }
  }
  if $use {
    package_use { $package:
      use    => $use,
      target => $assigned_use_target,
      before => Package[$package],
      notify => Exec["changed_package_use"],
    }
    exec {"changed_package_use":
      command     => "/usr/bin/emerge --reinstall=changed-use $package",
      refreshonly => true,
    }
  }
  package { $package:
    ensure => $ensure,
  }
}
