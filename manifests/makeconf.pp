class gentoo::makeconf inherits gentoo {
    include concat::setup
    $makeconf = "/etc/make.conf"

    concat { $makeconf:
        owner => root,
        group => root,
        mode  => 644,
    }

    concat::fragment { "makeconf_base":
        target  => $makeconf,
        content => template("gentoo/makeconf.base.conf.erb"),
        order   => 00,
    }
}

define gentoo::makeconf::setting( $source="", $content="", $order=10) {
    if $content {
        concat::fragment { "makeconf_$name":
            target  => "/etc/make.conf",
            order   => $order,
            content => "$content\n",
    }

    if $source {
        concat::fragment { "makeconf_$name":
            target  => "/etc/make.conf",
            order   => $order,
            source  => $source,
    }
}
