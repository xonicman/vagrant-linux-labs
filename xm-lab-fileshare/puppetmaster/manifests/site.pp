$subnet=103

node 'server' {

  ### SAMBA SERVER
  include xm_samba::server

  ### FTP SERVER - vsftpd
  ### remember to run module install on puppetmaster:
  ### puppet module install example42-vsftpd --version 2.0.15
  class { 'vsftpd':
    ftpd_banner             => 'Welcome to LAB ftp server!',
    template                => 'vsftpd/vsftpd.conf.erb',
    anonymous_enable        => no,
    anon_upload_enable      => no,
    anon_mkdir_write_enable => no,
  }

  file { '/srv/ftp/upload':
    ensure  => 'directory',
    owner   => root,
    group   => ftp,
    mode    => 777,
    require => Class['vsftpd'],
  }

  ### NFS SERVER
  ### remember to run module install on puppetmaster:
  ### puppet module install derdanne-nfs --version 1.0.2  
  class { '::nfs':
    server_enabled => true
  }
  nfs::server::export{ '/shares/dbbackups':
    ensure  => 'mounted',
    clients => "192.168.$subnet.212(rw,no_root_squash)",
    require => File['/shares'],
  }
 file { '/shares':
     ensure => 'directory',
  }


}

node 'client' {

  ### SAMBA CLIENT
  include xm_samba::client

  ### FTP CLIENT
  package { 'ncftp': ensure => installed, }

  ### NFS CLIENT
  class { '::nfs':
    client_enabled => true,
  }
  nfs::client::mount { '/mysql-backups':
    server => "192.168.$subnet.211",
    share  => '/shares/dbbackups',
  }

}

