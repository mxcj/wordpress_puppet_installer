class php {
  exec {'apt-update': 
    command => '/usr/bin/apt-get update'
  }
  Exec["apt-update"] -> Package <| |>

  Package { ensure => "installed"}

  package { 'php74': }
  package { 'php74-mysql': }
  package { "phpmyadmin":}

  file { '/etc/apache2/sites-available/php-init-site.conf':
    content => template('apache/virtual-hosts-php.conf.erb'),
  }


  file { "/etc/apache2/sites-enabled/php-init-site.conf":
    ensure  => link,
    target  => "/etc/apache2/sites-available/php-init-site.conf",
    require => File['/etc/apache2/sites-available/php-init-site.conf'],
    notify  => Service['apache2'],
  }

  file { "${document_root}/index.php":
    ensure  => present,
    source => 'puppet:///modules/apache/index.php',
    require => File['/etc/apache2/sites-enabled/php-init-site.conf'],
    notify  => Service['apache2'],
  }

  service { 'php74':
    ensure => running,
    enable => true,
    hasstatus  => true,
  }

}
