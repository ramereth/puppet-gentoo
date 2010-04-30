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
            source      => $domain ? {
                "osuosl.bak"    => "puppet:///modules/gentoo/etc/sync-overlays.cfg/standard.bak",
                default         => "puppet:///modules/gentoo/etc/sync-overlays.cfg/standard",
            };
        "/usr/local/sbin/sync-overlays":
            ensure      => present,
            source      => "puppet:///modules/gentoo/usr/local/sbin/sync-overlays",
            mode        => 755;
    }

    file {"/etc/overlays": ensure => directory}

    # Puppet went all nazi with its syntax here...
    overlay {"osl":}
}

define overlay() {
    file { "/etc/overlays/${name}":
        ensure  => file,
        before  => Exec["sync-overlays"];
    }
}
