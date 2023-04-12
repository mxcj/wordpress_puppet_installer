class apache {
  exec {'apt-update': 
    command => '/usr/bin/apt-get update'
  }
  Exec["apt-update"] -> Package <| |>
  

  package { 'apache2': 
    ensure => installed,
  }


  file { '/etc/apache2/ports.conf':
    content => template('apache/ports.conf.erb'),
  }
  

  file { '/etc/apache2/sites-enabled/000-default.conf':
    ensure => absent,
    require => Package['apache2'],
  }

  file { '/etc/apache2/sites-available/apache-init-site.conf':
    content => template('apache/virtual-hosts.conf.erb'),
    require => File['/etc/apache2/sites-enabled/000-default.conf'],
  }


  file { "/etc/apache2/sites-enabled/apache-init-site.conf":
    ensure  => link,
    target  => "/etc/apache2/sites-available/apache-init-site.conf",
    require => File['/etc/apache2/sites-available/apache-init-site.conf'],
    notify  => Service['apache2'],
  }

  file { "${document_root}/index.html":
    ensure  => present,
    source => 'puppet:///modules/apache/index.html',
    require => File['/etc/apache2/sites-enabled/apache-init-site.conf'],
    notify  => Service['apache2'],
  }

  service { 'apache2':
    ensure => running,
    enable => true,
    hasstatus  => true,
    restart => "/usr/sbin/apachectl configtest && /usr/sbin/service apache2 reload",
  }


}
