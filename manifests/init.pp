class gentoo {
    $modbase = "puppet:///modules/gentoo"

    exec { "sync-overlays":
        path    => "/usr/local/sbin/:/usr/bin",
        cwd     => "/tmp",
        returns => 0,
        require => [File["/etc/sync-overlays.cfg"],
                    File["/usr/local/sbin/sync-overlays"],];
    }

    file {
        "/etc/sync-overlays.cfg":
            ensure      => present,
            source      => $domain ? {
                "osuosl.bak"    => "${modbase}/etc/sync-overlays.cfg/standard.bak",
                default         => "${modbase}/etc/sync-overlays.cfg/standard",
            };
        "/usr/local/sbin/sync-overlays":
            ensure      => present,
            source      => "${modbase}/usr/local/sbin/sync-overlays",
            mode        => 755;
    }

    file {"/usr/local/overlays": ensure => directory}
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
