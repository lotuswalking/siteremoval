$dateStr = Get-Date -Format "yyyyMMddHH"
Get-SPODeletedSite -IncludePersonalSite -Limit ALL | 
Select-Object Url, Status, ArchiveStatus, DeletionTime, DaysRemaining | 
export-csv -Path "D:\sftp\deletedSPOsite_$dateStr.csv" -NoTypeInformation