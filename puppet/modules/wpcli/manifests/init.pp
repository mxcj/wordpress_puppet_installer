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
    command => "wp core install --url=localhost:${port} --locale=es_SV --title='Wordpress project Blog' --admin_name=${wpadmin} --admin_password=${dbpasswordWP} --admin_email=mxcj@hotmail.com --allow-root --path='${project_directory}'",
    require => File['Copy wp cli to enable commands'],
    notify => Service['apache2']
  }

  #Download a theme selected for this blog
  exec { 'Download theme':
    command => "wget https://downloads.wordpress.org/theme/generatepress.3.3.0.zip",
    cwd => $project_directory,
  }

  #Set permissions to www-data user for this file
  exec { "Change user and group permissions":
    command => "chown -R www-data:www-data ${project_directory}/generatepress.3.3.0.zip",
  }

  #Install downloaded theme
  exec { 'Install theme':
    command => "wp theme install ./generatepress.3.3.0.zip --allow-root --path='${project_directory}' --activate" ,
    require => Exec['Change user and group permissions']
  }
}
