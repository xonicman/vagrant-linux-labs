node 'server' {

  ###  NFS SERVER
  ###  remember to run module install on puppetmaster:
  ###  puppet module install derdanne-nfs --version 1.0.2  
  class { '::nfs':
    server_enabled => true
  }
  nfs::server::export{ '/shares/dbbackups':
    ensure  => 'mounted',
    clients => '192.168.16.102(rw,no_root_squash)',
    require => File['/shares'],
  }
  file { '/shares':
    ensure => 'directory',
  }

}

node 'client' {

  ### NFS CLIENT
  class { '::nfs':
    client_enabled => true,
  }
  nfs::client::mount { '/mysql-backups':
      server => '192.168.16.101',
      share  => '/shares/dbbackups',
  }

}

