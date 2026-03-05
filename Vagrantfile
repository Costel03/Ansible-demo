Vagrant.configure("2") do |config|
  config.vm.box_check_update = false
  config.vm.boot_timeout = 600

  config.vm.provider "virtualbox" do |vb|
    vb.gui    = true
    vb.cpus   = 2
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1",        "on"]
    vb.customize ["modifyvm", :id, "--vram",                "32"]
    vb.customize ["modifyvm", :id, "--graphicscontroller",  "vmsvga"]
  end

  config.vm.define "ubuntu" do |ubuntu|
    ubuntu.vm.box      = "ubuntu/focal64"
    ubuntu.vm.hostname = "ubuntu"
    ubuntu.vm.network "private_network", ip: "192.168.56.120"
    ubuntu.vm.provider "virtualbox" do |vb|
      vb.memory = 4096
    end
    ubuntu.vm.provision "shell", inline: <<-SHELL
      export DEBIAN_FRONTEND=noninteractive
      apt-get update -q
      apt-get install -yq xfce4 xfce4-goodies lightdm
      systemctl set-default graphical.target
      apt-get install -yq openssh-server
      systemctl unmask ssh
      systemctl enable ssh
      systemctl restart ssh
      systemctl start lightdm || true
    SHELL
  end

  config.vm.define "rocky" do |rocky|
    rocky.vm.box      = "generic/rocky8"
    rocky.vm.hostname = "rocky"
    rocky.vm.network "private_network", ip: "192.168.56.101"
    rocky.vm.provider "virtualbox" do |vb|
      vb.memory = 4096
    end
    rocky.vm.provision "shell", inline: <<-SHELL
      dnf groupinstall -y "Server with GUI" --skip-broken
      systemctl set-default graphical.target
      systemctl enable sshd
      systemctl restart sshd
      systemctl start gdm || true
    SHELL
  end

  config.vm.define "centos" do |centos|
    centos.vm.box      = "generic/centos7"
    centos.vm.hostname = "centos"
    centos.vm.network "private_network", ip: "192.168.56.102"
    centos.vm.provider "virtualbox" do |vb|
      vb.memory = 4096
    end
    centos.vm.provision "shell", inline: <<-SHELL
      yum groupinstall -y "GNOME Desktop" --skip-broken
      systemctl set-default graphical.target
      systemctl enable sshd
      systemctl restart sshd
      systemctl start gdm || true
    SHELL
  end

  config.vm.define "wordpress" do |wp|
    wp.vm.box      = "ubuntu/focal64"
    wp.vm.hostname = "wordpress"
    wp.vm.network "private_network", ip: "192.168.56.103"
    wp.vm.provider "virtualbox" do |vb|
      vb.memory = 2048
      vb.gui    = true
    end
    wp.vm.provision "shell", inline: <<-SHELL
      export DEBIAN_FRONTEND=noninteractive
      apt-get update -q
      apt-get install -yq xfce4 xfce4-goodies lightdm
      systemctl set-default graphical.target
      apt-get install -yq openssh-server
      systemctl unmask ssh
      systemctl enable ssh
      systemctl restart ssh
      systemctl start lightdm || true
    SHELL
  end
end
