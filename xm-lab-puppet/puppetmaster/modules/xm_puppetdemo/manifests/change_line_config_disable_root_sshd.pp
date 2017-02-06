# disable root login on ssh
class xm_puppetdemo::change_line_config_disable_root_sshd {
  #upewnij sie, ze masz zainstalowany modul stdlib
  #ls /etc/puppet/modules
  #puppet module install puppetlabs-stdlib

  file_line {'sshd_disable_root_login':
    path  => '/etc/ssh/sshd_config',
    line  => 'PermitRootLogin no',
    match => '^\#?PermitRootLogin',
    #ensure => absent,

  }
}
