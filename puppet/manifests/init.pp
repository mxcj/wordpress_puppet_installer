
$document_root = '/home/vagrant'
$project_directory = '/var/www/html'
$username = 'root'
$password = 'vagrant2023'#Password for MySQL
$dbnameWP = 'wordpress'
$dbuserWP = 'wordpress'
$dbpasswordWP = 'vagrant20'#Password Wordpress admin
$wpadmin = 'wp_admin'
$port = '8081'


Exec { path => "/bin/:/sbin/:/usr/bin/:/usr/sbin/:/usr/local/bin:/usr/local/sbin:~/.composer/vendor/bin/" }


require nginx
require apache
require php
require mysql
require wordpress
require wpcli




