define gentoo::keywords ($source, $ensure=present) {
    include gentoo

    file {
        "gentoo_keywords_${name}":
            path    => "/etc/portage/package.keywords/${name}",
            source  => "${source}",
            ensure  => $ensure,
            require => File["/etc/portage/package.keywords"],
    }
}
