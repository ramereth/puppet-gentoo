class gentoo {
    # load all variables
    require gentoo::params

    # resets variables needed in templates
    $gentoo_global_use  = $gentoo::params::global_use
    $gentoo_features    = $gentoo::params::features
    $gentoo_mirrors     = $gentoo::params::mirrors
    $gentoo_sync        = $gentoo::params::sync
    $gentoo_binhost     = $gentoo::params::binhost
    $gentoo_portdir_overlay = $gentoo::params::portdir_overlay
    $gentoo_accept_license  = $gentoo::params::accept_license
    $gentoo_emerge_opts = $gentoo::params::emerge_opts
}
