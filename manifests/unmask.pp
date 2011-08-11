define gentoo::unmask ($source="", $ensure=present) {
    file {
        "gentoo_unmask_${name}":
            path    => "/etc/portage/package.unmask/${name}",
            source  => "${source}",
            ensure  => $ensure;
    #        require => File["/etc/portage/package.unmask"];
    #    "/etc/portage/package.unmask":
    #        ensure  => directory;
    }
}
