class gentoo {
    $modbase        = "puppet:///modules/gentoo"
    $updateconfig   = "/usr/local/sbin/update-config"
    $makeconf_d     = "/etc/make.conf.d"
    $makeconf       = "/etc/make.conf"

    exec {
        "sync-overlays":
            path    => "/usr/local/sbin/:/usr/bin",
            cwd     => "/tmp",
            returns => 0,
            require => [File["/etc/sync-overlays.cfg"],
                        File["/usr/local/sbin/sync-overlays"],];
        "update-makeconf":
            command     => "${updateconfig} ${makeconf} ${makeconf_d} conf",
            require     => File["${updateconfig}"],
            refreshonly => true;
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
        "${updateconfig}":
            ensure      => present,
            source      => "${modbase}${updateconfig}",
            mode        => 755;
        "/usr/local/overlays":
            ensure      => directory;
        "/etc/overlays":
            ensure      => directory;
        "${makeconf_d}":
            ensure      => directory;
    }

    gentoo::overlay {"osl":}

    gentoo::makeconf_include {"00base":}

    define overlay() {
        file {"/etc/overlays/${name}":
            ensure  => file,
            before  => Exec["sync-overlays"];
        }
    }

    define makeconf_include() {
        file {"/etc/make.conf.d/${name}.conf":
            ensure  => present,
            source  => "${modbase}/etc/make.conf.d/${name}.conf",
            notify  => Exec["update-makeconf"];
        }
    }
}

