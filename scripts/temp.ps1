Remove-ADUser -Identity bob -Confirm:$false
Remove-ADUser -Identity alice -Confirm:$false
Remove-ADGroup -Identity Employees -Confirm:$false


# $confirm = Read-Host "Are you sure you want to delete these users and group? (Y/N)"
# if ($confirm -eq 'Y') {
#     Remove-ADUser -Identity bob -Confirm:$false
#     Remove-ADUser -Identity alice -Confirm:$false
#     Remove-ADGroup -Identity Employees -Confirm:$false
# }