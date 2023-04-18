class wpcli {
  #Copy wp-cli to virtual machine bin folder to be executed
  file { 'Copy wp cli to enable commands':
    path => "/usr/local/bin/wp",
    ensure  => present,
    source => 'puppet:///modules/wpcli/wp-cli.phar',
    owner => 'vagrant',
    group => 'vagrant',
    mode => "u+x"
  }

  #Define basic configuration for a new wordpress site
  exec { 'Basic config':
    command => "wp core install --url=localhost:${port} --locale=es_SV --title='Wordpress project Blog UNIR' --admin_name=${wpadmin} --admin_password=${dbpasswordWP} --admin_email=mxcj@hotmail.com --allow-root --path='${project_directory}'",
    require => File['Copy wp cli to enable commands'],
    notify => Service['apache2']
  }

  #Install downloaded theme
  exec { 'Install theme':
    command => "wp theme install generatepress --allow-root --path='${project_directory}' --activate",
    require => Exec['Basic config']
  }
}
