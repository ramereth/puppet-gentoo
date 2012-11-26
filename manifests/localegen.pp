define gentoo::localegen ($value) {
  config { "gentoo_localegen_${name}":
    file  => "/etc/locale.gen",
    line  => "$name $value",
    pattern => "^$name $value$",
    engine  => "replaceline",
  }
}
