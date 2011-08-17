class gentoo (
    $global_use  = $gentoo::params::global_use,
    $features    = $gentoo::params::features,
    $mirrors     = $gentoo::params::mirrors,
    $sync        = $gentoo::params::sync,
    $binhost     = $gentoo::params::binhost,
    $portdir_overlay = $gentoo::params::portdir_overlay,
    $accept_license  = $gentoo::params::accept_license,
    $emerge_opts = $gentoo::params::emerge_opts
    ) inherits gentoo::params {

    include concat::setup
    # load all variables
    require gentoo::params

    # Add requires for Package provider
    Package {
        require => Concat["/etc/make.conf"],
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

    exec { "emerge_changed_use":
        command     => "/usr/bin/emerge --reinstall=changed-use @world",
        require     => Concat["/etc/make.conf"],
        refreshonly => true,
    }

    # make.conf
    concat { "/etc/make.conf":
        owner => root,
        group => root,
        mode  => 644,
    }

    concat::fragment { "makeconf_base":
        target  => "/etc/make.conf",
        content => template("gentoo/makeconf.base.conf.erb"),
        order   => 00,
    }
}
