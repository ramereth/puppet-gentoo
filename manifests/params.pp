# = Class: portage::params
#
# Contains default values for portage.
#
# == Example
#
# This class does not need to be directly included.
#
class portage::params {

  $global_use = '$USE'
  $features   = '$FEATURES'
  $mirrors    = 'http://distfiles.gentoo.org'
  $sync       = 'rsync://rsync.gentoo.org/gentoo-portage'
  $binhost    = ''

  $portdir_overlay = '$PORTDIR_OVERLAY'
  $accept_license  = '$ACCEPT_LICENSE'
  $emerge_opts     = ''

  $make_conf = '/etc/portage/make.conf'
}
