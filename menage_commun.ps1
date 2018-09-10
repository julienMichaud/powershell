Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser -Force
import-module PSScheduledJob


$limit= (Get-Date).AddDays(-30)
$path="path"
$poubelle="path_to_bin_folder"
$cheminresultat= "\\chemin_reseau  $(get-date -f dd-MM-yyyy).txt"


$commande= Get-ChildItem -Path $path -Recurse -Force -Filter "*.*" | 
Where-object { !$_.PSISContainer -and $_.LastWriteTime -lt $limit } |  
move-item -destination $poubelle -force -verbose -PassThru > $cheminresultat