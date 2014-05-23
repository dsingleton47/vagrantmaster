# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "precise64"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine.
  # Forward MySql port on 33066, used for connecting admin-clients to localhost:33066
  config.vm.network :forwarded_port, guest: 3306, host: 33066
  
  # Forward http port on 8080, used for connecting web browsers to localhost:8080
  config.vm.network :forwarded_port, guest: 80, host: 8080

  # forward for mailcatcher
  config.vm.network :forwarded_port, guest: 1080, host: 1080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network :private_network, ip: "33.33.33.10"

  # Give it a hostname to prevent FQDN errors from apache
  config.vm.hostname = "local.magento.dev"

  # Set share folder permissions to 777 so that apache can write files
  config.vm.synced_folder ".", "/var/www/", mount_options: ['dmode=777','fmode=666']

  # Provider-specific configuration so you can fine-tune VirtualBox for Vagrant.
  # These expose provider-specific options.
  config.vm.provider :virtualbox do |vb|
    # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize ["modifyvm", :id, "--memory", "4096"]
  end

  # Create a basic manifest for our magento requirements this is super simple
  # and I will probably end up spliting it into different manifests later
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "manifests"
    puppet.manifest_file = "magento.pp"
  end
end