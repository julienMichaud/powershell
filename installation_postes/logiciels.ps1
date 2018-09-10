function Show-Menu
{
     param (
           [string]$Title = 'CHOISISSEZ LES LOGICIELS A INSTALLER'
     )
     cls
     Write-Host "================ $Title ================"
    
     Write-Host "1: Appuyez sur 1 pour chiffrer l'ordinateur avec Bitlocker"
     Write-Host "2: Appuyez sur 2 pour installer Office standard"
     Write-Host "3: Appuyez sur 3 pour installer Office Pro"
     Write-Host "Q: Quitter le menu"
}

$getExecutionPath = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

# Copier le raccourci commun et le tmv sur le bureau de tous les utilisateurs
copy-item $getExecutionPath\"chemin_raccourcis" -Destination "C:\users\public\Desktop"
copy-item $getExecutionPath\"chemin_raccourcis"  -Destination "C:\users\public\Desktop"


$logiciel1=Start-Process "\\chemin_reseau\setup.exe"   -Wait

$logiciel2=Start-Process "\\chemin_reseau\setup.exe"   -Wait

$logiciel3=Start-Process "\\chemin_reseau\OCS-NG-Windows-Agent-Setup.exe" -ArgumentList "/S /now /SERVER=http://ip/ocsinventory /DEBUG=1 /TAG=TMV"  -Wait

$logiciel4=Start-Process "\\chemin_reseau\logiciel.EXE"  -ArgumentList "/S" -Wait





# On supprime la tache qui permet d'installer les logiciels, sinon elle va se relancer à chaque redémarrage
unregister-scheduledtask -TaskName installation_logiciels -confirm:$true

# On desactive le compte admintemp 
Disable-LocalUser -name "admintemp" 

function Delete() {
$Invocation = (Get-Variable MyInvocation -Scope 1).Value
$Path = "c:\outils\logiciels.ps1"
Write-Host $Path 
Remove-Item $Path -force
}       
Delete

# Menu permettant d'installer bitlocker, office standard et pro 
do
{
     Show-Menu
     $input = Read-Host "Appuyez sur 1 ou sur Q"
     switch ($input)
     {
           '1' {
                cls
                Enable-BitLocker -MountPoint C: -EncryptionMethod XtsAes256   -UsedSpaceOnly -SkipHardwareTest -RecoveryPasswordProtector 

                (Get-BitLockerVolume -MountPoint c:).keyprotector.recoverypassword > "\\chemin_reseau\$env:computername.txt"

             } 
           '2' { Start-Process "\\chemin_reseau\office.EXE"  -ArgumentList "/S" -Wait
             }

           '3' { Start-Process "\\chemin_reseau\logiciel.EXE"  -ArgumentList "/S" -Wait
           }
           
           'q' {
                return
           }
     }
     pause
}
until ($input -eq 'q')


read-host "Le script est terminé, veuillez faire attention aux erreurs ci-dessus si il y en a. "