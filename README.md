# Ansible Demo - LAMP Stack & WordPress Deployment

## What it does

- Installs Apache, MySQL, PHP on Ubuntu, Rocky Linux, and CentOS with automatic startup
- Creates virtual host `acasa.local` with a custom PHP page
- Installs NFS server on Ubuntu restricted to specific IPs from the network
- Deploys WordPress on a separate VM using `--tags wordpress`

## Project Structure

- `inventories/hosts` - inventory file with VM definitions
- `inventories/group_vars/all.yml` - global variables (passwords, IPs, settings)
- `playbooks/site.yml` - main unified playbook
- `playbooks/test.yml` - verification playbook
- `roles/webserver` - LAMP stack installation and configuration
- `roles/nfsserver` - NFS server with IP-based access control
- `roles/wordpress` - WordPress installation
- `scripts/copy-keys.sh` - SSH key setup script

## Virtual Machines

- **ubuntu**: `192.168.56.120` (LAMP + NFS server)
- **rocky**: `192.168.56.101` (LAMP stack)
- **centos**: `192.168.56.102` (LAMP stack)
- **wordpress**: `192.168.56.103` (WordPress)

## Installation

### 1. Start Virtual Machines (PowerShell)

```powershell
cd C:\Users\iacob\Documents\repos\Ansible-demo
vagrant up
```

### 2. Install Ansible Collections (WSL)

```bash
cd /mnt/c/Users/iacob/Documents/repos/Ansible-demo
ansible-galaxy collection install -r requirements.yml
```

### 3. Copy SSH Keys

```bash
bash scripts/copy-keys.sh
```

### 4. Test Connectivity

```bash
ansible all -m ping
```

### 5. Run Complete Deployment

```bash
# Deploy everything (LAMP, NFS, WordPress)
ansible-playbook playbooks/site.yml
```

Or run specific components:

```bash
# LAMP stack only
ansible-playbook playbooks/site.yml --tags lamp

# LAMP + NFS server
ansible-playbook playbooks/site.yml --tags lamp,nfs

# WordPress only
ansible-playbook playbooks/site.yml --tags wordpress
```

## Verification

### Check Services Status

```bash
# Check Apache web server
ansible webservers -m shell -a "systemctl status apache2 || systemctl status httpd" -b

# Check MySQL database
ansible webservers -m shell -a "systemctl status mysql || systemctl status mysqld" -b

# Check NFS server
ansible nfsservers -m shell -a "systemctl status nfs-kernel-server" -b
```

### Verify Apache Configuration

```bash
# Verify acasa.local virtual host configuration
ansible webservers -m shell -a "grep -r 'acasa.local' /etc/apache2/sites-available/ /etc/httpd/conf.d/ 2>/dev/null" -b

# Check PHP index page
ansible webservers -m shell -a "cat /var/www/acasa.local/index.php" -b
```

### Test Apache with curl

```bash
# Test HTTP response from each web server
ansible webservers -m shell -a "curl -s -H 'Host: acasa.local' http://localhost/ | head -20" -b
```

### Verify NFS Exports

```bash
# Check /etc/exports configuration file
ansible nfsservers -m shell -a "cat /etc/exports" -b

# Check active NFS shares
ansible nfsservers -m shell -a "exportfs -v" -b

# Check NFS shared directory
ansible nfsservers -m shell -a "ls -la /srv/nfs/share" -b
```

### Verify WordPress Installation

```bash
# Check WordPress files
ansible wordpress_vms -m shell -a "ls -la /var/www/wordpress/" -b

# Verify wp-config.php configuration
ansible wordpress_vms -m shell -a "grep DB_NAME /var/www/wordpress/wp-config.php" -b

# Test WordPress HTTP response
ansible wordpress_vms -m shell -a "curl -s http://localhost/ | head -20" -b
```

### Verify MySQL Database

```bash
# List all databases
ansible webservers -m shell -a "mysql -e 'SHOW DATABASES;'" -b

# List MySQL users
ansible webservers -m shell -a "mysql -e 'SELECT user,host FROM mysql.user;'" -b
```

### Run Automated Test Suite

```bash
ansible-playbook playbooks/test.yml
```

## Browser Access

Add to `C:\Windows\System32\drivers\etc\hosts`:

```text
192.168.56.120 acasa.local
192.168.56.101 acasa.local
192.168.56.102 acasa.local
192.168.56.103 wordpress.local
```

Then visit:

- <http://acasa.local> (ubuntu)
- <http://192.168.56.101> (rocky)
- <http://192.168.56.102> (centos)
- <http://192.168.56.103> (wordpress)

## Configuration

Edit `inventories/group_vars/all.yml` to customize:

- `apache_vhost_servername` - virtual host server name
- `mysql_root_password` - MySQL root password
- `nfs_allowed_ips` - list of allowed IPs for NFS access
- `wordpress_db_*` - WordPress database configuration

## Troubleshooting

### VMs Not Responding

```bash
# Restart VMs
vagrant reload

# Check VM status
vagrant status
```

### SSH Connection Issues

```bash
# Regenerate SSH keys
bash scripts/copy-keys.sh

# Test manual SSH connection
ssh -i ~/.vagrant-keys/ubuntu vagrant@192.168.56.120
```

### Services Not Starting

```bash
# Check Apache logs
ansible webservers -m shell -a "tail -50 /var/log/apache2/error.log || tail -50 /var/log/httpd/error_log" -b

# Check MySQL logs
ansible webservers -m shell -a "tail -50 /var/log/mysql/error.log || tail -50 /var/log/mysqld.log" -b
```

## Task Requirements Checklist

- ✅ Install Apache, MySQL, PHP, NFS server with automatic startup
- ✅ Configure Apache, MySQL, PHP with virtualhost `acasa.local` displaying custom PHP page
- ✅ Configure NFS server accessible only from specific network IPs
- ✅ Works on Ubuntu, Rocky Linux, and CentOS
- ✅ Install WordPress on separate machine using tags
