 Get-SPODeletedSite -IncludePersonalSite -Limit ALL | export-csv -Path D:\sftp\deletedSPOsite.csv -NoTypeInformation

 Get-RetentionCompliancePolicy -Identity "Lenovo retention" -DistributionDetail | Format-List