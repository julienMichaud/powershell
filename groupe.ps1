$groupe = Read-Host "Nom du groupe"
Get-ADGroupMember -identity $groupe | 
select name | 
Export-Csv -path groupe.csv -NoTypeInformation