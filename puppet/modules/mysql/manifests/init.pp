class mysql {
  #Install MySql Server and additionals libraries
  $enhancers = [ 'mysql-server', 'libapache2-mod-php8.1', 'php-mysql' ]
  package { $enhancers:
    ensure => installed,
    notify => Service['apache2']
  }

  #Star MySql Service
  service { 'Ensure mysql service is running and enable':
    name => 'mysql',
    ensure  => true,
    enable  => true,
    require => Package[$enhancers],
    restart => "/usr/sbin/service mysql reload"
  }

  #Set root password
  exec { "set-mysql-password":
    unless => "mysqladmin -u ${username} -p ${password} status",
    command => "mysqladmin -u ${username} password ${password}",
    require => Service["Ensure mysql service is running and enable"]
  }

  #Copy Create database script to our root directory
  file { 'Copy file exec': 
    path => "${document_root}/create-db.sql",
    ensure  => present,
    content => template('mysql/create-db.sql.erb'),
    require => Exec['set-mysql-password']
  }

  #Execute the create database script
  exec { 'Run MySQL command from file':
    command => "mysql -h localhost -u ${username} -D mysql < ${document_root}/create-db.sql",
    require => File["Copy file exec"]
  }
}
