define gentoo::use ($source, $ensure=present) {
    file {
        "gentoo_use_${name}":
            path    => "/etc/portage/package.use/${name}",
            source  => $source,
            ensure  => $ensure,
            require => File["/etc/portage/package.use"],
    }
}
