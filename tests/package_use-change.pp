# change use
package_use { 'mysql-server':
    package     => "dev-db/mysql",
    use_flags   => ['cluster', 'community'],
    target      => "/tmp/mysql",
}
