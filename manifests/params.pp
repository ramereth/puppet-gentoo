class portage::params {
  # settings that the user can define (if not defined, defaults set here
  # apply).

  $global_use = '$USE'
  $features   = '$FEATURES'
  $mirrors    = "http://distfiles.gentoo.org"
  $sync       = "rsync://rsync.gentoo.org/gentoo-portage"
  $binhost    = ""

  $portdir_overlay = '$PORTDIR_OVERLAY'
  $accept_license  = '$ACCEPT_LICENSE'
  $emerge_opts     = ""

  $make_conf = '/etc/portage/make.conf'
}
