define portage::package (
    $package = $title,
    $use = undef,
    $use_target = undef,
    $keywords = undef,
    $keywords_target = undef,
    $ensure = undef,
    $target = undef,
  ) {
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
    package_keywords { $package:
      keywords => $keywords,
      target   => $keywords_target,
      before   => Package[$package],
    }
  }
  if $unmask {
    package_unmask { $package:
      target => $unmask_target,
      before => Package[$package],
    }
  }
  if $mask {
    package_mask { $package:
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
