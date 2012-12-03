# = Define: portage::makeconf
#
# Adds optional sections to make.conf
#
# == Parameters
#
# [*name*]
#
# The human readable description for the make.conf section
#
# [*source*]
#
# The source of the configuration fragment. Must be of the form used
# by concat::fragment.
#
# [*content*]
#
# The content of the configuration fragment. Must be of the form used
# by concat::fragment.
#
# [*order*]
#
# An optional order parameter. Defaults to 10.
#
# [*ensure*]
#
# The ensure state of the makeconf section.
#
# == Example
#
#     portage::makeconf { 'extended emerge warning delay':
#       ensure  => present,
#       content => 'EMERGE_WARNING_DELAY = 20',
#       order   => 90,
#     }

define portage::makeconf(
  $ensure = present,
  $source  = '',
  $content = '',
  $order   = 10
) {
  include concat::setup
  include portage

  if $content {
    concat::fragment { "makeconf_${name}":
      ensure  => $ensure,
      content => template('portage/makeconf.conf.erb'),
      target  => $portage::make_conf,
      order   => $order,
    }
  }

  if $source {
    concat::fragment { "makeconf_${name}":
      ensure  => $ensure,
      source  => $source,
      target  => $portage::make_conf,
      order   => $order,
    }
  }
}
