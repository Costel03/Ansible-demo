
Write-Host "Destroying old VMs..."
vagrant destroy -f

Write-Host "Cleaning up..."
Remove-Item -Path ".vagrant" -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "Starting new VMs with updated names..."
vagrant up

Write-Host "Done! Now run in WSL:"
Write-Host "  bash scripts/copy-keys.sh"
Write-Host "  ansible all -m ping"
