##################################################################################################################

# Créateur: Julien Michaud
# Date: 03/01/2017 
# Objectif: Transfert tous les fichiers de l'utilisateur et son/ses .pst de son ancien ordinateur vers le nouveau. 

##################################################################################################################

$utilisateur= read-host -prompt 'Entrez le n° de CP de la personne'
$pcancien= read-host -prompt 'Entrez le n° de CALIF du poste ou se trouve le .pst et les données de l utilisateur'
$pcnouveau= read-host -prompt 'Entrez le n° de CALIF du nouveau poste'


# Le contenu des dossiers que l'on veut copier sur le nouvel ordinateur
$folders= "Favorites","Desktop","Documents","Pictures","Downloads","Video"



#Pour chaque dossier présent das la variable $folders, on fait un get child-item de chaque dossier 
foreach ($folder in $folders) {
$cheminDossier = "\\" + $pcancien + "\" + "c$" + "\Users\" + $utilisateur + "\" + $folder
$destinationPath = "\\" +$pcnouveau + "\" +"c$" + "\Users\" + $utilisateur + "\" + $folder
$files = Get-ChildItem -Path $cheminDossier 
$filecount = $files.count
$i=0



# Ce code trouvé sur le net permet d'afficher une barre de progression durant le transfert, utile pour savoir ou on en est... 
#http://avbpowershell.nl/copy-files-with-progress-indicator-with-powershell/
    Foreach ($file in $files) {
    $i++
    Write-Progress -activity "Copie des fichiers en cours..." -status "($i of $filecount) $file" -percentcomplete (($i/$filecount)*100)
 
    # Copy the object to the appropriate folder within the destination folder
    copy-Item $file.fullname -Destination $destinationPath -recurse 
    }
    }


# Même principe que pour les dossiers mais ici avec les .pst présent sur le lecteur D
$cheminDossierMail = "\\" + $pcancien + "\" + "d$"
$destinationPathMail = "\\" + $pcnouveau + "\" + "c$" + "\" + "mel"
$filesMail= Get-ChildItem -Path $cheminDossierMail -filter *.pst -recurse 
$filecountMail = $filesMail.count
$iMail=0

Foreach ($fileMail in $filesMail) {
    $iMail++
    Write-Progress -activity "Copie du ou des .pst..." -status "($iMail of $filecountMail) $fileMail" -percentcomplete (($i/$filecount)*100)
  
    copy-Item $fileMail.fullname -Destination $destinationPathMail -Recurse
}
