# This is obnoxious

class gentoo {
    exec { "sync-overlays":
        path    => "/usr/local/sbin",
        require => [File["/etc/sync-overlays.cfg"],
                    File["/usr/local/sbin/sync-overlays"],];
    }

    file {
        "/etc/sync-overlays.cfg":
            ensure      => present,
            source      => "puppet:///gentoo/etc/sync-overlays.cfg";
        "/usr/local/sbin/sync-overlays":
            ensure      => present;
            source      => "puppet:///gentoo/usr/local/sbin/sync-overlays",
            mode        => 755;
    }
}
