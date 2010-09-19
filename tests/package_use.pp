class test {
    # test basic
    package_use { 'app-admin/puppet':
        use_flags   => ['augeas', '-rrdtool'],
        target      => "/tmp/test-package-use",
    }

    package_use { 'app-editors/vim':
        use_flags   => "-perl",
        target      => "/tmp/test-package-use",
    }

    # canonical name
    package_use { 'mysql-client':
        package     => "dev-db/mysql",
        use_flags   => ['minimal', '-perl'],
        target      => "/tmp/test-package-use",
    }
}

class test::change inherits test {
    Package_use["app-editors/vim"] { use_flags +> "perl", }
}

#include test
include test::change
