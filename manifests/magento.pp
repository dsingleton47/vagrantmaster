#variables
$binpath = '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'

# apache some useful text editors and python properties required pre-req for installing php5
package{[
	'vim',
	'nano',
	'apache2',
	'python-software-properties',
	]:
	ensure => 'latest',
	require => Exec['apt-get update'],
}

# php5 on its own, needs to be installed before the extensions
package{[
	'php5',
	]:
	ensure => 'latest',
	require => Exec['apt-get refresh'],
}

# php5 extensions required by magento
package{[
	'php5-curl', 
	'php5-gd',
	'php5-mcrypt', 
	'php5-mysql',
	]:
	ensure => 'latest',
	require => Package['php5'],
}

#install sqllite for mailcatcher
package{[
	'sqlite',
	'libsqlite3-dev'
	]:
	ensure => 'latest'
}
package{
	"g++":	ensure => present;
	"build-essential": ensure => present;
}
# attempt to install mailcatcher
package{ 'mailcatcher':
	ensure	=> 'latest',
	provider => 'gem',
	require => [ Package["build-essential"], Package["g++"] ],
}

# executables
# we want to update sources before we install anything
exec { 'apt-get update':
	command => 'apt-get update',
	path 	=> '/usr/bin/',
}

# not an ideal solution, but it works to refresh apt-get again once php5 repo is added 
# ensuring we get the right php5 package installed (5.4)
exec { 'apt-get refresh':
	command => 'apt-get update',
	path 	=> '/usr/bin/',
	require => Exec['add-apt-repository ppa:ondrej/php5-oldstable'],
}

#add repo for php 5.4
exec { 'add-apt-repository ppa:ondrej/php5-oldstable':
	command	=> 'add-apt-repository ppa:ondrej/php5-oldstable',
	path	=> $binpath,
}

#enable mod rewrite
exec { 'a2enmod rewrite':
	command => 'a2enmod rewrite',
	path 	=> $binpath,
    require => Package[ 'apache2' ],
    notify	=> Service['apache2'],
}

exec {'mailcatcher --ip=0.0.0.0':
	command => 'mailcatcher --ip=0.0.0.0',
	provider => 'gem',
	require => Package['mailcatcher'],
}

# services
# add service for apache2 and ensure it's running
service { 'apache2':
	ensure		=>running,
	hasstatus	=> true,
	hasrestart	=> true,
	require		=> Package['apache2'],
}