class apache {
  #Command to package update
  exec {'apt-update': 
    command => '/usr/bin/apt-get update'
  }
  Exec["apt-update"] -> Package <| |>
  
  #Install Apache2
  package { 'apache2': 
    ensure => installed,
  }
  
  #Apply new port configuration
  file { '/etc/apache2/ports.conf':
    ensure  => present,
    content => template('apache/ports.conf.erb'),
    require => Package['apache2'],
  }
  
  #Delete sites enabled default configuration
  file { '/etc/apache2/sites-enabled/000-default.conf':
    ensure => absent,
    require => Package['apache2'],
  }

  #Create a new virtual host configuration for wordpress
  file { '/etc/apache2/sites-available/wordpress.conf':
    content => template('apache/virtual-hosts.conf.erb'),
    require => File['/etc/apache2/sites-enabled/000-default.conf'],
  }

  #Create a link file to wordpress configure in sites available folder
  file { "/etc/apache2/sites-enabled/wordpress.conf":
    ensure  => link,
    target  => "/etc/apache2/sites-available/wordpress.conf",
    require => File['/etc/apache2/sites-available/wordpress.conf'],
    notify  => Service['apache2'],
  }

  #Remove index file from work directory
  file { 'Remove file index':
    path => "${project_directory}/index.html",
    ensure => absent,
    require => File['/etc/apache2/sites-enabled/wordpress.conf'],
  }

  #Reload configurations and restart apache services
  service { 'apache2':
    ensure => running,
    enable => true,
    hasstatus  => true,
    restart => "/usr/sbin/apachectl configtest && /usr/sbin/service apache2 reload",
  }
}
