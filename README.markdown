Puppet Gentoo Portage Module
============================

Provides Gentoo portage features for Puppet.

Usage
-----

The package types and providers share a few common characteristics. For one,
the namevar must be a valid portage DEPEND atom. A full description of this can
be found in portage(5). In addition, all of the providers are based off of the 
parsedfile provider, so they are ensurable. The target parameter has been
altered such that if you do not give a fully qualified path, the target file
will be put in the relevant /etc/portage/package.\* directory.

### package\_use ###

    package_use { "app-admin/puppet":
      use    => ["flag1", "flag2"],
      target => "puppet-flags",
    }

use\_flags can be either a string or an array of strings.

### package\_keywords ###

    package_keywords { 'app-admin/puppet':
      keywords  => ['~x86', '-hppa'],
      target  => 'puppet',
    }"

keywords can be either a string or an array of strings.

### package\_mask and package\_unmask ###

    package_unmask { '=app-admin/puppet-2.7.3':
      target  => 'puppet',
    }"

    package_mask { 'app-admin/tree':
      target  => 'tree',
    }"

Limitations
-----------

These types and providers are built around the ParsedFile provider and are
subject to the same limitations.

See Also
--------

  * man 5 portage: http://www.linuxmanpages.com/man5/portage.5.php
  * man 5 ebuild: http://www.linuxmanpages.com/man5/ebuild.5.php

Contributors
============

  * Lance Albertson (lance@osuosl.org)
  * Russell Haering (russell\_h@osuosl.org)
  * Adrien Thebo (adrien@puppetlabs.com)
  * Theo Chatzimichos (tampakrap@gentoo.org)


