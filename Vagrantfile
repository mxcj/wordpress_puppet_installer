
Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/bionic64"
  config.vm.box_download_insecure=true

  config.vm.network "forwarded_port", guest: 80, host: 80
  config.vm.network "private_network", ip: "192.168.33.10"
  
  config.vm.provider "virtualbox" do |vb|

     vb.memory = "2048"
  end
 
  config.vm.provision "shell", inline: <<-SHELL
      sudo wget https://apt.puppetlabs.com/puppet6-release-bionic.deb
      sudo dpkg -i puppet6-release-bionic.deb
      sudo apt-get update
      sudo apt-get install -y puppet-agent
    SHELL
   
  config.vm.provision "puppet" do |puppet|
    puppet.module_path = "puppet/modules"        
    puppet.manifests_path = "puppet/manifests"   # Default
    puppet.manifest_file = "init.pp"   # Default
  end
end
