 $dateStr=Get-Date -Format "yyyyMMdd"
Get-SPODeletedSite -IncludePersonalSite -Limit ALL | export-csv -Path "D:\sftp\deletedSPOsite_$dateStr.csv" -NoTypeInformation

 Get-RetentionCompliancePolicy -Identity "Lenovo retention" -DistributionDetail | Format-List