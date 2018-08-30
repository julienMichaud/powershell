Set-ExecutionPolicy RemoteSigned -force
import-module activedirectory
$utilisateur= read-host -prompt 'Entrez le n° de CP'

get-aduser $utilisateur -properties memberof | select -expandproperty memberof | get-adgroup -properties name | select name  | out-file droits_utilisateur.txt -inputobject {$_.name+";"}