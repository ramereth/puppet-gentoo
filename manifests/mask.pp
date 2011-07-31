define gentoo::mask ($source="", $ensure=present) {
    file { "gentoo_mask_${name}":
        target  => "/etc/portage/package.mask/${name}",
        source  => "${source}",
        ensure  => $ensure,
    }
}
