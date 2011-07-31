define gentoo::use ($source="", $ensure=present) {
    file { "gentoo_use_${name}":
        target  => "/etc/portage/package.use/${name}",
        source  => "${source}",
        ensure  => $ensure,
    }
}
