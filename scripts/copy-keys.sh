#!/usr/bin/env bash
set -euo pipefail

VAGRANT_DIR="/mnt/c/Users/iacob/Documents/repos/Ansible-demo/.vagrant/machines"
KEY_DIR="$HOME/.vagrant-keys"
PROJECT_DIR="/mnt/c/Users/iacob/Documents/repos/Ansible-demo"

mkdir -p "$KEY_DIR"

for VM in ubuntu rocky centos wordpress; do
  SRC="$VAGRANT_DIR/$VM/virtualbox/private_key"
  DST="$KEY_DIR/$VM"

  if [[ -f "$SRC" ]]; then
    cp "$SRC" "$DST"
    chmod 600 "$DST"
    echo "✔  $VM  →  $DST"
  else
    echo "✘  $VM  key not found (VM may not be running): $SRC"
  fi
done

cat > "$HOME/.ansible.cfg" << EOF
[defaults]
inventory = $PROJECT_DIR/inventories/hosts
roles_path = $PROJECT_DIR/roles
host_key_checking = False
remote_user = vagrant
retry_files_enabled = False

[ssh_connection]
pipelining = True
EOF

echo ""
echo "Done. Test with:"
echo "  ansible all -m ping"
