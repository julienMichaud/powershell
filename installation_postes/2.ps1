# Ajout du droit de modification sur le lecteur C pour "utilisateurs"
$acl = get-acl -path “C:\”
$new = “Utilisateurs”,”Modify”,”ContainerInherit,ObjectInherit”,”None”,”Allow”
$accessRule = new-object System.Security.AccessControl.FileSystemAccessRule $new
$acl.SetAccessRule($accessRule)
$acl | Set-Acl “C:\”


# Le prochain redémarrage se fera en mode normal 
cmd.exe /c "bcdedit /deletevalue {default} safeboot"

cmd.exe /c "shutdown /r"
