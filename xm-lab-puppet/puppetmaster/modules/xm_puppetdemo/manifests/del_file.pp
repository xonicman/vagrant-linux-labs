# remove file
class xm_puppetdemo::del_file {
  file {'/usr/local/sbin/niebezpieczny-skrypt.sh':
    ensure => 'absent',
  }
}
