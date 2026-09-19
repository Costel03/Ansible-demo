# Ansible-demo

LAMP + WordPress + NFS provisioned by Ansible onto four Vagrant VMs. Multi-distro
on purpose — the point is exercising Debian vs RedHat branching, not shipping
production infrastructure.

## The VMs

| Host | IP | Box | Role |
|---|---|---|---|
| `ubuntu` | 192.168.56.120 | ubuntu/focal64 | webserver + NFS server |
| `rocky` | 192.168.56.101 | generic/rocky8 | webserver |
| `centos` | 192.168.56.102 | generic/centos7 | webserver |
| `wordpress` | 192.168.56.103 | ubuntu/focal64 | WordPress |

Vagrant runs on Windows, Ansible runs from WSL — Ansible has no working control
node on Windows.

## Setup

Bring the VMs up from PowerShell:

```powershell
vagrant up          # or: vagrant up <name>
vagrant halt
vagrant destroy -f
```

Then copy the SSH keys where the inventory expects them (WSL):

```bash
mkdir -p ~/.vagrant-keys
for vm in ubuntu rocky centos wordpress; do
  cp ".vagrant/machines/$vm/virtualbox/private_key" ~/.vagrant-keys/$vm
done
chmod 600 ~/.vagrant-keys/*
```

Redo this after any `vagrant destroy` — new VMs get new keys.

## Running the playbook

```bash
ansible all -m ping
ansible-playbook playbook.yml                       # everything
ansible-playbook playbook.yml --tags lamp,nfs
ansible-playbook playbook.yml --tags wordpress
ansible-playbook playbook.yml --limit centos
```

`ansible.cfg` already sets the inventory, `roles_path`, `remote_user` and
disables host key checking — don't pass those on the command line.

Roles are gated by inventory group, so a host only gets what its group implies:

| Role | Group | Tag |
|---|---|---|
| `webserver` | `webservers` | `lamp` |
| `nfsserver` | `nfsservers` | `nfs` |
| `wordpress` | `wordpress_vms` | `wordpress` |

## Layout

| Path | What |
|---|---|
| `Vagrantfile` | The four VMs |
| `playbook.yml` | One play over `all`, roles gated by group |
| `inventories/hosts` | Static inventory |
| `inventories/group_vars/all.yml` | Every tunable — hostnames, paths, passwords |
| `roles/*/tasks` | The work |
| `roles/*/templates` | Jinja configs (vhosts, `wp-config.php`, `exports`) |

New settings go in `all.yml`, not hardcoded in tasks.

## Checking it worked

```bash
# LAMP
ansible webservers -b -m shell -a "systemctl status apache2 || systemctl status httpd"
ansible webservers -b -m shell -a "systemctl status mysql || systemctl status mysqld"
ansible webservers -b -m shell -a "curl -s -H 'Host: acasa.local' http://localhost/ | grep -i 'bine ai venit'"

# WordPress
ansible wordpress_vms -b -m shell -a "ls -la /var/www/html/wordpress/"
ansible wordpress_vms -b -m shell -a "curl -s http://localhost/ | head -20"

# NFS
ansible nfsservers -b -m shell -a "exportfs -v"
ansible nfsservers -b -m shell -a "cat /etc/exports"
```

Mount the export from another machine:

```bash
sudo mount 192.168.56.120:/srv/nfs/share /share
```

The real test is idempotency: run the playbook twice and the second pass should
report `changed=0`.

## Notes

- CentOS 7 is EOL. Its repos are rewritten to `vault.centos.org` and it needs
  `ansible_python_interpreter=/usr/bin/python`. Both are deliberate.
- OS differences are handled with paired tasks guarded by
  `ansible_os_family`, plus `ansible_distribution_major_version` for el7-vs-el8.
- Service restarts go through handlers, never an inline `state=restarted`.
- `all.yml` holds plaintext demo passwords and `.vagrant/` (including VM private
  keys) is tracked. Fine for throwaway local VMs — don't copy the pattern.
