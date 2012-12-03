# = Define: portage::package
#
# Configures and installs a package with portage-specific configuration
define portage::package (
    $ensure          = undef,
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
