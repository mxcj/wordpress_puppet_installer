class php {
  #Install Additional libraries
  exec {'apt -y install software-properties-common': 
    command => '/usr/bin/apt -y install software-properties-common'
  }
  Exec["apt -y install software-properties-common"] -> Package <| |>

  #Add PHP Repository  
  exec {'add-apt-repository ppa:ondrej/php': 
    command => '/usr/bin/add-apt-repository ppa:ondrej/php'
  }
  Exec["add-apt-repository ppa:ondrej/php"] -> Package <| |>

  #Update APT Package manager
  exec {'apt-update1': 
    command => '/usr/bin/apt-get update'
  }
  Exec["apt-update1"] -> Package <| |>

  #Instsall PHP 8.1
  package { 'php8.1': ensure => installed, }

  #Install PHP additional components
  package { 'php8.1-mysql': ensure => installed, }
  package { 'php8.1-cli': ensure => installed, }
  package { 'php8.1-common': ensure => installed, }
  package { 'php8.1-zip': ensure => installed, }
  package { 'php8.1-gd': ensure => installed, }
  package { 'php8.1-mbstring': ensure => installed, }
  package { 'php8.1-curl': ensure => installed, }
  package { 'php8.1-xml': ensure => installed, }
  package { 'php8.1-bcmath': ensure => installed, }
  package { 'php8.1-intl': ensure => installed, }

  #Enable necesary modules to interact with Apache
  exec { 'enable_php':
      command => "a2enmod proxy_fcgi setenvif && a2enconf  && a2enmod php8.1",
      notify => Service['apache2']
    }
}
