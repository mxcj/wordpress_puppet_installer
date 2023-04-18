class wordpress {
  exec { 'Download Wordpress':#'wget https://wordpress.org/latest.tar.gz':
    command => "wget https://wordpress.org/latest.tar.gz",
    cwd => $document_root,
    require => Service['Ensure mysql service is running and enable']
  }

  exec { "tar -xvzf ${document_root}/latest.tar.gz": 
    require => Exec['Download Wordpress']
  }

  file { 'Copy file config wordpress': 
    path => "${document_root}/wordpress/wp-config.php",
    ensure  => present,
    content => template('wordpress/wp-config.php.erb'),
    mode => "600",
    require => Exec["tar -xvzf ${document_root}/latest.tar.gz"]
  }

  exec { "chown -R www-data:www-data ${document_root}/wordpress":
    require => File["Copy file config wordpress"]
  }

  exec { "Modify access Wordpress":
    command => "chmod -R 775 ${document_root}/wordpress",
    require => Exec["chown -R www-data:www-data ${document_root}/wordpress"]
  }

  exec { "Move Wordpress directory":
    command => "mv ${document_root}/wordpress/* ${project_directory}",
    require => Exec["Modify access Wordpress"],
    notify => Service['apache2']
  }

  notify {'Wordpress-Installed':
    message => "Module WordPress installed...",
    require => Exec['Move Wordpress directory']
  }



}
