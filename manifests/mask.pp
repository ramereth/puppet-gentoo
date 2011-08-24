define gentoo::mask ($source="", $ensure=present) {
    file {
        "gentoo_mask_${name}":
            path    => "/etc/portage/package.mask/${name}",
            source  => "${source}",
            ensure  => $ensure,
#            require => File["/etc/portage/package.mask"],
    }
}
