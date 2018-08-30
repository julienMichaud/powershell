Enable-BitLocker -MountPoint C: -EncryptionMethod XtsAes256   -UsedSpaceOnly -SkipHardwareTest -RecoveryPasswordProtector 

(Get-BitLockerVolume -MountPoint c:).keyprotector.recoverypassword > "\\chemin_reseau\$env:computername.txt"