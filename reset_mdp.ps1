Set-ExecutionPolicy RemoteSigned -force
import-module activedirectory
$usercred= read-host -prompt 'Entrez utilisateur _ADM '
$cred = Get-Credential $usercred
$utilisateur= read-host -prompt 'Entrez le n° de CP'
$newpwd = ConvertTo-SecureString -String "p@ssw0rd" -AsPlainText –Force
Set-ADAccountPassword -credential $cred -identity $utilisateur -NewPassword $newpwd -Reset -PassThru | Set-ADuser -ChangePasswordAtLogon $True
write-host "mdp de $utilisateur reinitialisé"
Read-Host -Prompt "Appuyez sur Entrée pour quitter"
 