#xm_puppetdemo
class xm_puppetdemo {

  #DEMO make sure file is removed
  include del_file

  #Edit hosts file 
  include local_hosts

  #DEMO install and run mysql service
  include service_install_and_run_mysqld

  #DEMO Put/edit line on file:
  include change_line_config_disable_root_sshd
  include inline_change_mysqld_config

  #DEMO Cron entry
  include cron_report_date

  #DEMO User accounts with rsa keys
  include local_users

  #DEMO Soft installation based on different facts
  include soft_install_basic_tools

  #DEMO Lets restart service once and execute script
  include restart_mysql_once
  include execute_script_once

}
