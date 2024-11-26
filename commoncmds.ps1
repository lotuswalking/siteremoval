 $dateStr=Get-Date -Format "yyyyMMdd"
Get-SPODeletedSite -IncludePersonalSite -Limit ALL | 
Select-Object Url, Status, ArchiveStatus, DeletionTime, DaysRemaining | 
export-csv -Path "D:\sftp\deletedSPOsite_$dateStr.csv" -NoTypeInformation

 Get-RetentionCompliancePolicy -Identity "Lenovo retention" -DistributionDetail | Format-List