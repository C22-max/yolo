# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  #config.vm.box = "ubuntu/focal64"
  config.vm.box = "ubuntu/bionic64"
  # Forward port 3000 on the host to port 3000 on the guest.
  config.vm.network "forwarded_port", guest: 3000, host: 3000
  # Provisioning to install Docker
  config.vm.provision "shell", inline: <<-SHELL
    # Update package list and install dependencies
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

    # Add Docker's official GPG key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

    # Set up the stable repository for Docker
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

    # Update the package list again and install Docker
    sudo apt-get update
    sudo apt-get install -y docker-ce

    # Optionally, add the vagrant user to the Docker group
    sudo usermod -aG docker vagrant

    # Enable Docker service to start on boot
    sudo systemctl enable docker
  SHELL


  # Provisioning configuration for Ansible.
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "playbook.yml"
  end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Ansible, Chef, Docker, Puppet and Salt are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
  # Provisioning configuration for Ansible.
# config.vm.provision "ansible" do |ansible|
#   ansible.playbook = "playbook.yml"
# config.vm.network "forwarded_port", guest: 3000, host: 3000  
#   end
end