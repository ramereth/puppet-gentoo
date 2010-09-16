# test basic
package_keywords { 'app-admin/puppet':
    target      => "/tmp/test-packages-keywords",
}

package_keywords { 'app-editors/vim':
    keywords    => "~x86",
    target      => "/tmp/test-packages-keywords",
}

package_keywords { 'mysql-client5':
    package     => "=dev-db/mysql-5*",
    keywords    => ['-*', '**'],
    target      => "/tmp/test-packages-keywords",
}

package_keywords { 'mysql-client4':
    package     => "=dev-db/mysql-4*",
    target      => "/tmp/test-packages-keywords",
}
