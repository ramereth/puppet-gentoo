# = Class: portage
#
# Configure the Portage package management system
#
# == Parameters
#
# [*global_use*]
#
# This variable contains options that control the build behavior of
# several packages. More information in ebuild(5). Possible USE values
# can be found in /usr/portage/profiles/use.desc.
#
# [*features*]
#
# Defines actions portage takes by default. These options should not be
# changed by anyone but developers and/or maintainers. 'sandbox' is an
# important part of FEATURES and should not be disabled by default.
# This is an incremental variable.
#
# [*mirrors*]
#
# Insert your space-seperated list of local mirrors here. These
# locations are used to download files before the ones listed in the
# ebuild scripts. Merging 'mirrorselect' can help.
#
# [*sync*]
#
# Insert your preferred rsync mirror here. This rsync server is used to
# sync the local portage tree when `emerge --sync` is run.
#
# [*binhost*]
#
# This is the host from which portage will grab prebuilt-binary
# packages. The list is a single entry specifying the full address of
# the directory serving the tbz2's for your system.
#
# Note that it should point to the 'All' directory on the host that
# creates the binary packages and not to the root of the PKGDIR.
#
# [*portdir_overlay*]
#
# Defines the directories in which user made ebuilds may be stored and
# not overwriten when `emerge --sync` is run. This is a space delimited
# list of directories.
#
# [*accept_license*]
#
# This variable is used to mask packages based on licensing
# restrictions. It may contain both license and group names, where
# group names are prefixed with the '@' symbol.
#
# Refer to GLEP 23 for further information: http://www.gentoo.org/proj/en/glep/glep-0023.html
#
# [*emerge_opts*]
#
# Options to append to the end of the emerge(1) command line on every invocation.
#
# [*make_conf*]
#
# The path to make.conf.
#
# As of 2012-09-09 new systems will use /etc/portage/make.conf, but on older
# systems this can be /etc/make.conf.
#
# == Example
#
#     class { 'portage':
#       global_use     => 'mmx sse sse2',
#       features       => 'sandbox parallel-fetch parallel-install',
#       mirrors        => 'http://www.gtlib.gatech.edu/pub/gentoo rsync://mirror.the-best-hosting.net/gentoo-distfiles',
#       sync           => 'rsync://rsync.gentoo.org/gentoo-portage',
#       accept_license => '* -@EULA dlj-1.1 IBM-J1.5',
#     }
#
# == See Also
#
#  * emerge(1) http://dev.gentoo.org/~zmedico/portage/doc/man/emerge.1.html
#  * make.conf(5) http://dev.gentoo.org/~zmedico/portage/doc/man/make.conf.5.html

class portage (
  $global_use      = $portage::params::global_use,
  $features        = $portage::params::features,
  $mirrors         = $portage::params::mirrors,
  $sync            = $portage::params::sync,
  $binhost         = $portage::params::binhost,
  $portdir_overlay = $portage::params::portdir_overlay,
  $accept_license  = $portage::params::accept_license,
  $emerge_opts     = $portage::params::emerge_opts,
  $make_conf       = $portage::params::make_conf,
) inherits portage::params {

  include concat::setup
  include portage::params

  # Add requires for Package provider
  Package {
    require => Concat[$make_conf],
  }

  file {
    '/etc/portage/package.keywords':
      ensure  => directory;
    '/etc/portage/package.mask':
      ensure  => directory;
    '/etc/portage/package.unmask':
      ensure  => directory;
    '/etc/portage/package.use':
      ensure  => directory;
    '/etc/portage/postsync.d':
      ensure  => directory;
  }

  exec { 'changed_makeconf_use':
    command     => '/usr/bin/emerge --reinstall=changed-use @world',
    require     => Concat[$make_conf],
    refreshonly => true,
  }

  concat { $make_conf:
    owner   => root,
    group   => root,
    mode    => 644,
    notify  => Exec['changed_makeconf_use'],
  }

  concat::fragment { 'makeconf_base':
    target  => $make_conf,
    content => template('portage/makeconf.base.conf.erb'),
    order   => 00,
  }
}
