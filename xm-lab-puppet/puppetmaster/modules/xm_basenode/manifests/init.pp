#xm_basenode for basic node configuration
class xm_basenode {
  include puppet_run_custom_scripts

  service { 'puppet':
    ensure => 'stopped',
    enable => false,
  }

  file { '/tmp/puppetized-default-node':
    ensure => 'absent',
    force  => true,
  }

}
