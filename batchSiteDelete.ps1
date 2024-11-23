$csv_path = "D:\\sftp\\siteTodelete.csv"

function remove-sites {
    param(
        [Parameter(Mandatory=$true)]
        [array]$sites
    )
    foreach ($site in $sites) {
        $url = $site.Url
        Write-Host "Remove site: $url"
        Remove-SPOSite -Identity  $url -Confirm:$false
    }
}
function waitPolicyDistribution {
    $policy = Get-RetentionCompliancePolicy -Identity "Lenovo retention" -DistributionDetail
    while ($policy.DistributionStatus -eq "Pending") {
        Write-Host "Distribution status is $($policy.DistributionStatus)" -ForegroundColor Yellow
        Start-Sleep -Seconds 60
        $policy = Get-RetentionCompliancePolicy -Identity "Lenovo retention" -DistributionDetail
    }
    Write-Host "Distribution status is Success" -ForegroundColor Green
}

$sites = Import-Csv -Path $csv_path
$batchSites_str = ""
$batchSites = [System.Collections.ArrayList]@()
foreach ($site in $sites) {
    $batchSites_str += $site.Url + ","
    $batchSites+= [PSCustomObject]@{
        Url = $site.Url
    }
    if($batchSites.Count -eq 90) {
        $batchSites_str = $batchSites_str.TrimEnd(",")
        # Write-Host $batchSites_str
        $addCMD = "Set-RetentionCompliancePolicy -Identity `"Lenovo retention`" -AddSharePointLocationException $batchSites_str"
        # execute an other powershell script
        write-host "start to add exception ...."
        Invoke-Expression $addCMD
        # $addCMD
        Start-Sleep -Seconds 5
        .\waitUntilDistribution.ps1
        remove-sites -sites $batchSites
        .\waitUntilDistribution.ps1
        $delCMD = "Set-RetentionCompliancePolicy -Identity `"Lenovo retention`" -RemoveSharePointLocationException $batchSites_str"
        Write-Host "start to remove exception ...."
        Invoke-Expression $delCMD
        # $delCMD
        Start-Sleep -Seconds 5
        .\waitUntilDistribution.ps1
        $batchSites_str = ""
        $batchSites = [System.Collections.ArrayList]@()
        # break
    }
}


