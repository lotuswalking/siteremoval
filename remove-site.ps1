$siteList = Get-Content -Path ".\sitelist.txt"

foreach ($site in $siteList) {
    Write-Host "Remove site: $site"
    Remove-SPOSite -Identity $site -Confirm:$false
}

Write-Host "Remove site done" -ForegroundColor Green
.\ExceptionRemove.ps1