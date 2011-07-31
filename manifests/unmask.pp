define gentoo::unmask ($source="", $ensure=present) {
    file { "gentoo_unmask_${name}":
        target  => "/etc/portage/package.unmask/${name}",
        source  => "${source}",
        ensure  => $ensure,
    }
}
