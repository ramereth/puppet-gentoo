class portage (
  $global_use      = $portage::params::global_use,
  $features        = $portage::params::features,
  $mirrors         = $portage::params::mirrors,
  $sync            = $portage::params::sync,
  $binhost         = $portage::params::binhost,
  $portdir_overlay = $portage::params::portdir_overlay,
  $accept_license  = $portage::params::accept_license,
  $emerge_opts     = $portage::params::emerge_opts,
  $make_conf       = $portage::params::make_conf,
) inherits portage::params {

  include concat::setup
  include portage::params

  # Add requires for Package provider
  Package {
    require => Concat[$make_conf],
  }

  file {
    "/etc/portage/package.keywords":
      ensure  => directory;
    "/etc/portage/package.mask":
      ensure  => directory;
    "/etc/portage/package.unmask":
      ensure  => directory;
    "/etc/portage/package.use":
      ensure  => directory;
    "/etc/portage/postsync.d":
      ensure  => directory;
  }

  exec { "changed_makeconf_use":
    command   => "/usr/bin/emerge --reinstall=changed-use @world",
    require   => Concat[$make_conf],
    refreshonly => true,
  }

  concat { $make_conf:
    owner   => root,
    group   => root,
    mode    => 644,
    notify  => Exec["emerge_changed_use"],
  }

  concat::fragment { "makeconf_base":
    target  => $make_conf,
    content => template("portage/makeconf.base.conf.erb"),
    order   => 00,
  }
}
