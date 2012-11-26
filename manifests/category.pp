define gentoo::category {
  config { "gentoo_category_${name}":
    file  => "/etc/portage/categories",
    line  => "$name",
    pattern => "^$name$",
    engine  => "replaceline",
  }
}
