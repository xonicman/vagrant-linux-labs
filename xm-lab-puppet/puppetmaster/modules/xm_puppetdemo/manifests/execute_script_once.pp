# command or script runned olny once
class xm_puppetdemo::execute_script_once {
  $tagfile = '/var/local/remove_this_file_to_run_command_from_puppet.tag'

  exec { 'create_file_with_date':
    command => "/bin/date >> /tmp/dates; touch ${tagfile}",
    creates => $tagfile,
  }
}
