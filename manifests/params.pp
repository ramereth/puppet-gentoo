class gentoo::params {
# settings that the user can define (if not defined, defaults set here apply).

# Global use flags
    $global_use = $gentoo_global_use ? {
        ''      => '$USE',
        default => "\$USE $gentoo_global_use",
    }

# FEATURES
    $features = $gentoo_features ? {
        ''      => '$FEATURES',
        default => "\$FEATURES $gentoo_features",
    }

# GENTOO_MIRRORS
    $mirrors = $gentoo_mirrors ? {
        ''      => "http://distfiles.gentoo.org",
        default => $gentoo_mirrors,
    }

# SYNC
    $sync = $gentoo_sync ? {
        ''      => "rsync://rsync.gentoo.org/gentoo-portage",
        default => $gentoo_sync,
    }

# PORTAGE_BINHOST
    $binhost = $gentoo_binhost ? {
        ''      => undef,
        default => $gentoo_binhost,
    }

# PORTDIR_OVERLAY
    $portdir_overlay = $gentoo_portdir_overlay ? {
        ''      => '$PORTDIR_OVERLAY',
        default => "\$PORTDIR_OVERLAY $gentoo_portdir_overlay",
    }

# ACCEPT_LICENSE
    $accept_license = $gentoo_accept_license ? {
        ''      => '$ACCEPT_LICENSE',
        default => "\$ACCEPT_LICENSE $gentoo_accept_license",
    }
}
