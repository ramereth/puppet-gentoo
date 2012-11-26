define portage::postsync ($content, $ensure=present) {
  file { "portage_postsync_${name}":
    path  => "/etc/portage/postsync.d/${name}",
    content => template("portage/postsync.sh.erb"),
    mode  => 755,
    ensure  => $ensure,
    require => File["/etc/portage/postsync.d"],
  }
}
