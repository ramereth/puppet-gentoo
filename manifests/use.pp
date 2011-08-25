define gentoo::use ($source, $ensure=present) {
    include gentoo

    file {
        "gentoo_use_${name}":
            path    => "/etc/portage/package.use/${name}",
            source  => $source,
            ensure  => $ensure,
            notify  => Exec["emerge_changed_use"],
            require => File["/etc/portage/package.use"],
    }
}
