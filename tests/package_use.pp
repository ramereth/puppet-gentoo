class test {
    # test basic
    package_use { 'app-admin/puppet':
        use    => ['augeas', '-rrdtool'],
        target => "/tmp/test-package-use",
    }

    package_use { 'app-editors/vim':
        use    => "-perl",
        target => "/tmp/test-package-use",
    }

    # canonical name
    package_use { 'mysql-client':
        package => "dev-db/mysql",
        use     => ['minimal', '-perl'],
        target  => "/tmp/test-package-use",
    }
}

class test::change inherits test {
    Package_use["app-editors/vim"] { use +> "perl", }
}

#include test
include test::change
