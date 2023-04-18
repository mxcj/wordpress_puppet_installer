class nginx {
  package { 'nginx': 
    ensure => installed,
  }

  file { 'Remove default server block':
    path => "/etc/nginx/sites-enabled/default",
    ensure => absent,
    require => Package['nginx'],
  }

  file { 'Create new Server Block for Proxy connections':
    path => "/etc/nginx/sites-available/proxy.conf",
    content => template('nginx/server-block.conf.erb'),
    require => File['Remove default server block'],
  }

  file { "Create link from site availables to site enabled":
    path => '/etc/nginx/sites-enabled/proxy.conf',
    ensure  => link,
    target  => "/etc/nginx/sites-available/proxy.conf",
    require => File['Create new Server Block for Proxy connections'],
    notify  => Service['apache2'],
  }

  file { 'Remove nginx index':
    path => "${project_directory}/index.nginx-debian.html",
    ensure => absent,
    require => File['/etc/nginx/sites-enabled/proxy.conf'],
  }


  service { 'nginx':
    ensure => running,
    enable => true,
    hasstatus  => true,
    restart => "/usr/sbin/service nginx restart",
  }
  
}
