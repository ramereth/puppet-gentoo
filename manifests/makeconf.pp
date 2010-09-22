class gentoo::makeconf inherits gentoo {
    include concat::setup
    #$makeconf = "/etc/make.conf"
    $makeconf = "/tmp/make.conf"

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

define gentoo::makeconf::setting( $content="", $order=10) {
    if $content == "" {
        $body = $name
    } else {
        $body = $content
    }

    concat::fragment { "makeconf_$name":
        target  => "/etc/make.conf",
        content => "$body\n",
    }
}
