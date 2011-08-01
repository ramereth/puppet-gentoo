define gentoo::makeconf( $source="", $content="", comment="", $order=10,
                         ensure=present ) {
    include concat::setup

    if $content {
        concat::fragment { "makeconf_$name":
            target  => "/etc/make.conf",
            order   => $order,
            ensure  => $ensure,
            content => template("gentoo/make.conf.erb"),
    }

    if $source {
        concat::fragment { "makeconf_$name":
            target  => "/etc/make.conf",
            order   => $order,
            ensure  => $ensure,
            source  => $source,
    }
}
