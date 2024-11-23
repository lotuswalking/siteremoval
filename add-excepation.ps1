# read content from sitelist.txt, put all data in one string split by comma

$siteList = Get-Content -Path ".\sitelist.txt"
$siteList = $siteList -join ","
"Set-RetentionCompliancePolicy -Identity `"Lenovo retention`" -AddSharePointLocationException $siteList" | Out-File -FilePath ".\ExceptionAdd.ps1"
"Set-RetentionCompliancePolicy -Identity `"Lenovo retention`" -RemoveSharePointLocationException  $siteList" | Out-File -FilePath ".\ExceptionRemove.ps1"
# 执行例外添加脚本
.\ExceptionAdd.ps1
.\waitUntilDistribution.ps1
.\remove-site.ps1
.\waitUntilDistribution.ps1
# 执行例外删除脚本
.\ExceptionRemove.ps1