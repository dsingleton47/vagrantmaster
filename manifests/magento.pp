#variables
$binpath = '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'

#packages
package{[
	'vim',
	'nano',
	'apache2',
	'python-software-properties',
	]:
	ensure => 'latest',
	require => Exec['apt-get update'],
}


package{[
	'php5',
	]:
	ensure => 'latest',
	require => Exec['add-apt-repository ppa:ondrej/php5-oldstable'],
}
#executables
exec { 'apt-get update':
	command => 'apt-get update',
	path 	=> '/usr/bin/',
}

#add repo for php 5.4
exec { 'add-apt-repository ppa:ondrej/php5-oldstable':
	command	=> 'add-apt-repository ppa:ondrej/php5-oldstable',
	path	=> $binpath,
	require  => Exec['apt-get update'],
}

#enable mod rewrite
exec { 'a2enmod rewrite':
	command => 'a2enmod rewrite',
	path 	=> $binpath,
    require => Package[ 'apache2' ],
    notify	=> Service['apache2'],
}

#services
service { 'apache2':
	ensure		=>running,
	hasstatus	=> true,
	hasrestart	=> true,
	require		=> Package['apache2'],
}