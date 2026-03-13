mkdir -p ~/.vagrant-keys
cp .vagrant/machines/ubuntu/virtualbox/private_key ~/.vagrant-keys/ubuntu
cp .vagrant/machines/rocky/virtualbox/private_key ~/.vagrant-keys/rocky
cp .vagrant/machines/centos/virtualbox/private_key ~/.vagrant-keys/centos
cp .vagrant/machines/wordpress/virtualbox/private_key ~/.vagrant-keys/wordpress
chmod 600 ~/.vagrant-keys/*

Powershell:
vagrant up/halt/destroy


WSL:
ansible ubuntu -m ping
ansible all -m ping
ansible ubuntu -a "reboot"
ansible ubuntu -a "cat /etc/os-release"
ansible-playbook playbook.yml --tags lamp,nfs
ansible-playbook playbook.yml --tags wordpress
ansible-playbook playbook.yml


Wordpress test:
-files
ansible wordpress_vms -m shell -a "ls -la /var/www/html/wordpress/" -b
-config
ansible wordpress_vms -m shell -a "cat /var/www/html/wordpress/wp-config.php | head -20" -b
-http response
ansible wordpress_vms -m shell -a "curl -s http://localhost/ | head -20" -b

NFS:
-status
ansible nfsservers -m shell -a "systemctl status nfs-kernel-server" -b
-configuration
ansible nfsservers -m shell -a "cat /etc/exports" -b
-active share
ansible nfsservers -m shell -a "exportfs -v" -b
-shared dir exist
ansible nfsservers -m shell -a "ls -la /srv/nfs/share" -b

LAMP:
-apache2 running
ansible webservers -m shell -a "systemctl status apache2 || systemctl status httpd" -b
-MySQL running
ansible webservers -m shell -a "systemctl status mysql || systemctl status mysqld" -b
-PHP working
ansible webservers -m shell -a "curl -s -H 'Host: acasa.local' http://localhost/ | grep -i 'bine ai venit'" -b
-PHP files
ansible webservers -m shell -a "ls -la /var/www/acasa.local/index.php" -b



sudo mount 192.168.56.120:/srv/nfs/share /share
