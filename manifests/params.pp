class gentoo::params {
  # settings that the user can define (if not defined, defaults set here
  # apply).

  # Global use flags
  $global_use = '$USE'

  # FEATURES
  $features   = '$FEATURES'

  # GENTOO_MIRRORS
  $mirrors    = "http://distfiles.gentoo.org"

  # SYNC
  $sync       = "rsync://rsync.gentoo.org/gentoo-portage"

  # PORTAGE_BINHOST
  $binhost    = ""

  # PORTDIR_OVERLAY
  $portdir_overlay    = '$PORTDIR_OVERLAY'

  # ACCEPT_LICENSE
  $accept_license     = '$ACCEPT_LICENSE'

  # EMERGE_DEFAULT_OPTS
  $emerge_opts        = ""
}
