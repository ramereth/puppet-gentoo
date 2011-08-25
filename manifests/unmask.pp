define gentoo::unmask ($source, $ensure=present) {
    include gentoo
    file {
        "gentoo_unmask_${name}":
            path    => "/etc/portage/package.unmask/${name}",
            source  => "${source}",
            ensure  => $ensure,
            require => File["/etc/portage/package.unmask"],
    }
}
