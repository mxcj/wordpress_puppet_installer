class mysql {


  # Create a database and user for your application
  mysql::db { 'myapp':
    ensure => present,
  }

  mysql::user { 'myapp':
    ensure => present,
    password_hash => mysql_password('myapppassword'),
    require => Mysql::Db['myapp'],
  }

  # Allow remote access to the MySQL server
  class { '::mysql::server::account_security':
    remote_root => true,
  }

  # Set up a backup schedule for the MySQL data directory
  class { '::mysql::server::backup':
    backupuser => 'backupuser',
    backuppassword => 'backuppassword',
    backupdir => '/var/backups/mysql',
    backupcompress => true,
    backuprotate => 7,
    backuphour => 2,
    backupminute => 30,
  }
}
