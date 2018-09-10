$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path

$cp= read-host "Entrez votre CP"
$password_admin= read-host "MDP du compte administrateur local de la machine:" -AsSecureString
Set-Localuser -name administrateur -password $password_admin

#Activation du compte administrateur local 
Enable-LocalUser -Name administrateur 

# Ajout de l'ordinateur dans le domaine 
Add-Computer -DomainName domaine_name -Credential (get-credential) 


# Ajout du groupe  dans le groupe administrateurs de la machine
Add-LocalGroupMember -group "Administrateurs" -member "groupe"

# Le prochain redémarrage se fera en mode sans echec sans réseau
cmd.exe /c "bcdedit /set {default} safeboot minimal"


# On crée une nouvelle tâche qui se lancera au redémarrage avec votre session
$action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument $ScriptDir"\logiciels.ps1" 
$trigger= New-ScheduledTaskTrigger -AtLogOn -user $cp
New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DeleteExpiredTaskAfter 00:00:01
Register-ScheduledTask -action $action -trigger $trigger -taskname "installation_logiciels" -runlevel Highest
Set-ScheduledTask -TaskName installation_logiciels -user $cp


read-host "Le PC va redémarrer en mode sans echec sans reseau, veuillez vous connecter avec le compte administrateur local de la machine"
restart-computer 