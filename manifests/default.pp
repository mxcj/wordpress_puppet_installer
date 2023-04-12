$document_root = '/vagrant'
include apache
include php

exec { 'Skip Message':
  command => "echo ‘Este mensaje sólo se muestra si no se ha copiado el fichero index.html'",
  unless => "test -f ${document_root}/index.html",
  path => "/bin:/sbin:/usr/bin:/usr/sbin",
}

exec { 'Skip Message php':
  command => "echo ‘Este mensaje sólo se muestra si no se ha copiado el fichero info.php'",
  unless => "test -f ${document_root}/info.php",
  path => "/bin:/sbin:/usr/bin:/usr/sbin",
}

notify { 'Showing machine Facts':
  message => "Machine with ${::memory['system']['total']} of memory and $::processorcount processor/s.
              Please check access to http://$::ipaddress_enp0s8}",
}
