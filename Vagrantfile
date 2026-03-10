Vagrant.configure("2") do |config|
  config.vm.box_check_update = false
  config.vm.boot_timeout = 300

  config.vm.provider "virtualbox" do |vb|
    vb.gui  = false
    vb.cpus = 1
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end

  config.vm.define "ubuntu" do |ubuntu|
    ubuntu.vm.box      = "ubuntu/focal64"
    ubuntu.vm.hostname = "ubuntu"
    ubuntu.vm.network "private_network", ip: "192.168.56.120"
    ubuntu.vm.provider "virtualbox" do |vb|
      vb.memory = 1024
    end
  end

  config.vm.define "rocky" do |rocky|
    rocky.vm.box      = "generic/rocky8"
    rocky.vm.hostname = "rocky"
    rocky.vm.network "private_network", ip: "192.168.56.101"
    rocky.vm.provider "virtualbox" do |vb|
      vb.memory = 1024
    end
  end

  config.vm.define "centos" do |centos|
    centos.vm.box      = "generic/centos7"
    centos.vm.hostname = "centos"
    centos.vm.network "private_network", ip: "192.168.56.102"
    centos.vm.provider "virtualbox" do |vb|
      vb.memory = 1024
    end
  end

  config.vm.define "wordpress" do |wp|
    wp.vm.box      = "ubuntu/focal64"
    wp.vm.hostname = "wordpress"
    wp.vm.network "private_network", ip: "192.168.56.103"
    wp.vm.provider "virtualbox" do |vb|
      vb.memory = 1024
    end
  end
end
