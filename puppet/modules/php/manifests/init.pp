class php {
  exec {'apt -y install software-properties-common': 
    command => '/usr/bin/apt -y install software-properties-common'
  }
  Exec["apt -y install software-properties-common"] -> Package <| |>

  
  exec {'add-apt-repository ppa:ondrej/php': 
    command => '/usr/bin/add-apt-repository ppa:ondrej/php'
  }
  Exec["add-apt-repository ppa:ondrej/php"] -> Package <| |>

  exec {'apt-update1': 
    command => '/usr/bin/apt-get update'
  }
  Exec["apt-update1"] -> Package <| |>

  package { 'php8.1': ensure => installed, }
  package { 'php8.1-mysql': ensure => installed, }
  package { 'php8.1-cli': ensure => installed, }
 # package { 'php8.1-json': ensure => installed, }
  package { 'php8.1-common': ensure => installed, }
  package { 'php8.1-zip': ensure => installed, }
  package { 'php8.1-gd': ensure => installed, }
  package { 'php8.1-mbstring': ensure => installed, }
  package { 'php8.1-curl': ensure => installed, }
  package { 'php8.1-xml': ensure => installed, }
  package { 'php8.1-bcmath': ensure => installed, }
  package { 'php8.1-intl': ensure => installed, }

  exec { 'enable_php':
      command => "a2enmod proxy_fcgi setenvif && a2enconf  && a2enmod php8.1",
      notify => Service['apache2']
    }




  /*file { '/etc/apache2/sites-available/php-init-site.conf':
    content => template('php/virtual-hosts-php.conf.erb'),
  }


  file { "/etc/apache2/sites-enabled/php-init-site.conf":
    ensure  => link,
    target  => "/etc/apache2/sites-available/php-init-site.conf",
    require => File['/etc/apache2/sites-available/php-init-site.conf'],
    notify  => Service['apache2'],
  }

  file { "${project_directory}/info.php":
    ensure  => present,
    source => 'puppet:///modules/php/info.php',
    require => File['/etc/apache2/sites-enabled/php-init-site.conf'],
    notify  => Service['apache2'],
  }
*/
 /* service { 'php7.4':
    ensure => running,
    enable => true,
    hasstatus  => true,
  }*/

}
