class wpcli {
  file { 'Copy wp cli to enable commands':
    path => "/usr/local/bin/wp",
    ensure  => present,
    source => 'puppet:///modules/wpcli/wp-cli.phar',
    owner => 'vagrant',
    group => 'vagrant',
    mode => "u+x"
  }


  exec { 'Basic config':
    command => "wp core install --url=localhost:${port} --locale=es_SV --title='Wordpress project Blog' --admin_name=${wpadmin} --admin_password=${dbpasswordWP} --admin_email=mxcj@hotmail.com --allow-root --path='${project_directory}'",
    require => File['Copy wp cli to enable commands'],
    notify => Service['apache2']
  }

   exec { 'Download theme':
    command => "wget https://downloads.wordpress.org/theme/generatepress.3.3.0.zip",
    cwd => $project_directory,
  }

  exec { "Change user and group permissions":
    command => "chown -R www-data:www-data ${project_directory}/generatepress.3.3.0.zip",

  }

  exec { 'Install theme':
    command => "wp theme install ./generatepress.3.3.0.zip --allow-root --path='${project_directory}' --activate" ,
    require => Exec['Change user and group permissions']
  }

  notify {'WP-CLI-Installed':
    message => "Module WP-CLI installed...",
    require => Exec['Install theme']
  }
}
