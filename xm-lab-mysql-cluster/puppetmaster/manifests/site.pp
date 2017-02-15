$server_id = $::hostname ? {
  mysql01 => '1',
  mysql02 => '2',
  default => '0',
}

$override_options = {
  'mysqld' => {
    'bind-address'    => '0.0.0.0',
    'server_id'       => $server_id,
    'log-bin'         => 'mysql-bin',
  }
}

$users = {
  'replica@192.168.%' => {
     ensure        => 'present',
     password_hash => '*C9BE8A759406249B2A64AF1B5AA3B49A4CB8AA35',
  },
  'client@%' => {
     ensure        => 'present',
     password_hash => '*459DEC76B4BAF7C0DCE265EDCA7EB68442C45E78',
  },
}

$grants = {
  'replica@192.168.%/*.*' => {
    ensure     => 'present',
    options    => ['GRANT'],
    privileges => ['REPLICATION SLAVE', 'INSERT', 'UPDATE', 'DELETE'],
    table      => '*.*',
    user       => 'replica@192.168.%',
  },
  'client@%/*.*' => {
    ensure     => 'present',
    options    => ['GRANT'],
    privileges => ['SELECT', 'INSERT', 'UPDATE', 'DELETE'],
    table      => '*.*',
    user       => 'client@%',
  },
}

#all nodes mysqlXX
node /mysql\d+$/ {
  class { '::mysql::server':
    root_password           => 'root',
    remove_default_accounts => true,
    override_options        => $override_options,
    users                   => $users,             #not works on Debian7 :(
    grants                  => $grants,            #not works on Debian7 :(
  }

 #Percona tool for dumping grants from MySQL instance
 file { 'pt-show-grants':
    path    => '/usr/local/sbin/pt-show-grants',
    owner   => root,
    group   => root,
    mode    => '0750',
    source => 'puppet:///files/pt-show-grants',
 }
}

node 'client' {

  class {'::mysql::client':
    bindings_enable => true,
  }

}

