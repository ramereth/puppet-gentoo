class test_params {
    $use_core = "nptl nptlonly mmx crypt tcpd pam -ipv6 unicode"
    $use_apps = "readline ssl zlib bzip2 snmp ncurses berkdb gdbm xml perl python libwww maildir png jpeg"
    $use_nox  = "-X -gtk -gnome -alsa -kde -qt -arts"
    $gentoo_global_use = "$use_core $use_apps $use_nox"

    $gentoo_features    = "parallel-fetch getbinpkg"
    $gentoo_mirrors     = "http://gentoo.osuosl.org/ http://oslportage.osuosl.bak/"
    $gentoo_sync        = "rsync://oslportage.osuosl.bak/portage/"
    $gentoo_binhost     = "http://oslportage.osuosl.org/packages/hardened64-10"
    $gentoo_portdir_overlay = "/usr/local/overlays/osl"
    $gentoo_accept_license  = "dlj-1.1"
    include gentoo::makeconf
}

include test_params
# test no params
# include gentoo::makeconf
