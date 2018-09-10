### Objectif du script:  ###
### Créer des dumps de toutes les bdd présente sur un serveur pour les archiver sur un nas. Ces dump seront stockés dans des dossiers à leurs noms (exemple les dump de la bdd "glpi" seront dans le dossier "glpi")
import-module PSScheduledJob




#Permet de charger le lecteur réseau avec les identifiants du NAS, ce qui permet de se connecter au répertoire BASES_SQL
net use \\chemin_nas\BASES_SQL login_nas

# Chargement de la dll mysql connector (voir lien en bas pour la télécharger) 
[void][Reflection.Assembly]::LoadWithPartialName('MySQL.Data')

# Core settings - you will need to set these 
$mysql_server = "ip"
$mysql_user = "nom_utilisateur" 
$mysql_password = "mot_de_passe"   
$backupstorefolder= "chemin_reseau_sauvegarde" 
$dbName = "db_name"
$pathtomysqldump = "path to the sqldump exe"


cls
# Determine Today´s Date Day (monday, tuesday etc)
$timestamp = Get-Date -format dd.MM.yyyy.HH.mm.ss
Write-Host $timestamp 

# Connection à la bdd  'information_schema'
[system.reflection.assembly]::LoadWithPartialName("MySql.Data")
$cn = New-Object -TypeName MySql.Data.MySqlClient.MySqlConnection
$cn.ConnectionString = "SERVER=$mysql_server;DATABASE=information_schema;UID=$mysql_user;PWD=$mysql_password;sslmode=none"
$cn.Open()

# Requête pour avoir le nom des bdd en ordre alphabétique
$cm = New-Object -TypeName MySql.Data.MySqlClient.MySqlCommand
$sql = "SELECT DISTINCT CONVERT(SCHEMA_NAME USING UTF8) AS dbName, CONVERT(NOW() USING UTF8) AS dtStamp FROM SCHEMATA ORDER BY dbName ASC"
$cm.Connection = $cn
$cm.CommandText = $sql
$dr = $cm.ExecuteReader()
 
# On boucle dans les résultats de la rêquete précédente
while ($dr.Read())
{
 # On affiche à l'écran quel base est entrain d'être dump
 $dbname = [string]$dr.GetString(0)
 if($dbname -match $dbName)
 {
 write-host "Backing up database: " $dr.GetString(0)
 

 # On créer le nom des dump en prenant le nom de la base en question + la date/heure
 $backupfilename = $timestamp + "_" + $dr.GetString(0) + ".sql"
 $backuppathandfile = $backupstorefolder + "" + $backupfilename
 If (test-path($backuppathandfile))
 {
 write-host "Backup file '" $backuppathandfile "' already exists. Existing file will be deleted"
 Remove-Item $backuppathandfile
 }


 #Permet de creer un dossier pour chaque bdd trouvée 
foreach ($db in $dbname){
 new-item "$backupstorefolder\$db" -itemtype Directory 
 } 

 # Pour chaque bdd trouvée, on invoque mysqldump via cmd pour faire le dump de chaque base au bonne endroit. Pour chaque bdd, placer le dump dans le dossier correspondant
 foreach ($db in  $dbname){
 cmd /c " `"$pathtomysqldump`" -h $mysql_server -u $mysql_user -p$mysql_password $dbname > $backupstorefolder\$db\$backupfilename "
 
} 


#On vérifie que le dump s'est bien crée
 If (test-path($backuppathandfile))
 {
 write-host "Backup created. Presence of backup file verified"
 }
 }
 

# Write Space
 write-host " "
}
 
# Fermeture de la connexion mysql
$cn.Close()  

#source = https://www.codeproject.com/Tips/234492/MySQL-DB-backup-using-powershell-script
# lien dll https://dev.mysql.com/downloads/connector/net/
# Si problème d'accès refusé, essayer de faire un net use depuis le cmd. 




### Supprime les fichiers .sql plus vieux que 7 jours ###


$limit= (Get-Date).AddDays(-7)
$path="\\chemin_reseau\BASES_SQL"
$cheminresultat= "\\chemin_resultat"

# On cherche tous les fichiers en récursif à partir du dossier $path
$commande= Get-ChildItem -Path $path -Recurse -Force -Filter "*.sql" | 

# Si la date de dernière écriture est supérieur à 30jours à partir de la date actuelle
Where-object { !$_.PSISContainer -and $_.LastWriteTime -lt $limit } |  

# Déplacer le dit-objet du dossier $path vers le dossuer $poubelle 
remove-item -force  -verbose -recurse > $cheminresultat

# On supprime le lecteur réseau une fois le script lancé
net use chemin_reseau_nas /d 