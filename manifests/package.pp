define portage::package (
    $package = $title,
    $version = undef,
    $use = undef,
    $use_target = undef,
    $keywords = undef,
    $keywords_target = undef,
    $slot = undef,
    $ensure = undef,
    $target = undef,
  ) {
  if $version {
    $package_full = "=$package-$version"
    notify{ $package_full : }
  }
  else {
    $package_full = $package
  }
  if $target {
    if $use_target != undef {
      $use_target = $target
    }
    if $keywords_target != undef {
      $keywords_target = $target
    }
    if $unmask_target != undef {
      $unmask_target = $target
    }
    if $mask_target != undef {
      $mask_target = $target
    }
  }
  if $keywords {
    package_keywords { $package_full:
      keywords => $keywords,
      target   => $keywords_target,
      before   => Package[$package],
    }
  }
  if $unmask {
    package_unmask { $package_full:
      target => $unmask_target,
      before => Package[$package],
    }
  }
  if $mask {
    package_mask { $package_full:
      target => $mask_target,
      before => Package[$package],
    }
  }
  if $use {
    package_use { $package:
      use_flags => $use,
      target    => $use_target,
      before    => Package[$package],
      notify    => Exec["changed_useflags"],
    }
    exec {"changed_useflags":
      command     => "/usr/bin/emerge --reinstall=changed-use $package",
      refreshonly => true,
    }
  }
  package { $package:
    ensure => $ensure,
  }
}
