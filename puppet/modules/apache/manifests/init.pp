class apache {
  exec {'apt-update': 
    command => '/usr/bin/apt-get update'
  }
  Exec["apt-update"] -> Package <| |>
  

  package { 'apache2': 
    ensure => installed,
  }


  file { '/etc/apache2/ports.conf':
    ensure  => present,
    content => template('apache/ports.conf.erb'),
    require => Package['apache2'],
  }
  

  file { '/etc/apache2/sites-enabled/000-default.conf':
    ensure => absent,
    require => Package['apache2'],
  }

  file { '/etc/apache2/sites-available/wordpress.conf':
    content => template('apache/virtual-hosts.conf.erb'),
    require => File['/etc/apache2/sites-enabled/000-default.conf'],
  }


  file { "/etc/apache2/sites-enabled/wordpress.conf":
    ensure  => link,
    target  => "/etc/apache2/sites-available/wordpress.conf",
    require => File['/etc/apache2/sites-available/wordpress.conf'],
    notify  => Service['apache2'],
  }

  file { 'Remove file index':
    path => "${project_directory}/index.html",
    ensure => absent,
    require => File['/etc/apache2/sites-enabled/wordpress.conf'],
  }


  service { 'apache2':
    ensure => running,
    enable => true,
    hasstatus  => true,
    restart => "/usr/sbin/apachectl configtest && /usr/sbin/service apache2 reload",
  }


}
