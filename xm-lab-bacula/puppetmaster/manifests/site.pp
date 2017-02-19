class baseconfig {

}

node bacula {
  include baseconfig

  # MySQL Server
  $override_options = {
    'mysqld' => {
      'bind-address'    => '127.0.0.1',
      'server_id'       => '1',
    }
  }

  $databases = {
    'bacula' => {
      ensure  => 'present',
      charset => 'utf8',
    },
  }

  $users = {
    'bacula@localhost' => {
       ensure        => 'present',
       password_hash => '*498F6E0FC18D37B6288117511CF2B12BCC8E1A3F', #pass: bacula
    },
  }

  $grants = {
    'bacula@localhost/bacula.*' => {
      ensure     => 'present',
      options    => ['GRANT'],
      privileges => ['ALL', ],
      table      => 'bacula.*',
      user       => 'bacula@localhost',
    },
  }

  class { '::mysql::server':
    root_password           => 'root',
    remove_default_accounts => true,
    override_options        => $override_options,
    users                   => $users,             #not works on Debian7 :(
    grants                  => $grants,            #not works on Debian7 :(
    databases               => $databases,
  }

  #Percona tool for dumping grants from MySQL instance
  file { 'pt-show-grants':
    path    => '/usr/local/sbin/pt-show-grants',
    owner   => root,
    group   => root,
    mode    => '0750',
    source => 'puppet:///files/pt-show-grants',
  }
  # END OF MySQL Server

  # Bacula
  package { 'bacula-director': ensure => 'installed' }
  package { 'bacula-storage': ensure => 'installed' }
  package { 'bacula-console': ensure => 'installed' }
  package { 'bacula-client': ensure => 'installed' }

  exec { 'create bacula db tables':
    command => 'make_mysql_tables -ubacula -pbacula ; touch /var/spool/bacula/.DONE_make_mysql_tables',
    creates => '/var/spool/bacula/.DONE_make_mysql_tables',
    path    => ['/usr/libexec/bacula/', '/usr/bin/',],
    require => [ Package['bacula-director'], Class['::mysql::server'], ],
  }

  #todo test
  alternatives { 'libbaccats.so':
    path    => '/usr/lib64/libbaccats-mysql.so',
    require => Class['::mysql::server'],
  }
  
  file { '/bacula':
    ensure  => 'directory',
    owner   => bacula,
    group   => bacula,
    mode    => 700,
    require => Package['bacula-director'],
  }

  file { '/bacula/backup':
    ensure  => 'directory',
    owner   => bacula,
    group   => bacula,
    mode    => 700,
    require => File['/bacula'],
  }

  file { '/bacula/restore':
    ensure  => 'directory',
    owner   => bacula,
    group   => bacula,
    mode    => 700,
    require => File['/bacula'],
  }

  # END OF Bacula
}

node 'default' {
  include baseconfig
}

if versioncmp($::puppetversion,'3.6.1') >= 0 {
  # Based on
  # https://ask.puppet.com/question/6640/warning-the-package-types-allow_virtual-parameter-will-be-changing-its-default-value-from-false-to-true-in-a-future-release/

  $allow_virtual_packages = hiera('allow_virtual_packages',false)

  Package {
    allow_virtual => $allow_virtual_packages,
  }
}

