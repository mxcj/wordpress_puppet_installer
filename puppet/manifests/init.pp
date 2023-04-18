#Variables Definitions
$document_root = '/home/vagrant'
$project_directory = '/var/www/html'
$username = 'root'
$password = 'vagrant2023'#Password for MySQL
$dbnameWP = 'wordpress'
$dbuserWP = 'wordpress'
$dbpasswordWP = 'vagrant20'#Password Wordpress admin
$wpadmin = 'wp_admin'
$port = '8080'

#Configure exec path for console
Exec { path => "/bin/:/sbin/:/usr/bin/:/usr/sbin/:/usr/local/bin:/usr/local/sbin:~/.composer/vendor/bin/" }

#Include modules
require apache
require php
require mysql
require wordpress
require wpcli
