# = Define: portage::postsync
#
# Install custom postsync scripts
#
# == Parameters
#
# [*ensure*]
#
# The ensure value for the scrypt
#
# [*content*]
#
# The content of the script.
#
# [*source*]
#
# The source path to the script
#
# == Example
#
#     portage::postsync { 'system-bell':
#       ensure  => present,
#       content => "#!/bin/sh\necho -e \"\\a\""
#     }
#
#     portage::postsync { 'regen-layman-cache':
#       ensure => present,
#       source => 'puppet:///modules/site-files/regen-layman-cache.sh',
#     }
#
# == See Also
#
# * portage-utils: http://www.gentoo.org/doc/en/portage-utils.xml
define portage::postsync(
  $ensure  = 'present',
  $content = undef,
  $source  = undef,
) {

  include portage

  if ($content and $source) or !($content and $source) {
    fail('One of [$content, $source] must be specified')
  }

  if $content {
    file { "portage_postsync_${name}":
      ensure  => $ensure,
      path    => "/etc/portage/postsync.d/${name}",
      content => $content,
      mode    => '0755',
      require => File['/etc/portage/postsync.d'],
    }
  }

  if $source {
    file { "portage_postsync_${name}":
      ensure  => $ensure,
      path    => "/etc/portage/postsync.d/${name}",
      source  => $source,
      mode    => '0755',
      require => File['/etc/portage/postsync.d'],
    }
  }
}
