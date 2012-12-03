# change use
package_use { 'mysql-server':
    package => "dev-db/mysql",
    use     => ['cluster', 'community'],
    target  => "/tmp/mysql",
}
