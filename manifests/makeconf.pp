define portage::makeconf(
  $source  = "",
  $content = "",
  $comment = "",
  $order   = 10,
  $ensure = present
) {
  include concat::setup
  include portage

  if $content {
    concat::fragment { "makeconf_${name}":
      target  => $portage::make_conf,
      order   => $order,
      ensure  => $ensure,
      content => template("portage/makeconf.conf.erb"),
    }
  }

  if $source {
    concat::fragment { "makeconf_${name}":
      target  => $portage::make_conf,
      order   => $order,
      ensure  => $ensure,
      source  => $source,
    }
  }
}
