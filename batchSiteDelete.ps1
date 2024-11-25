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

function Invoke-WithRetry {
    param (
        [string]$cmds,
        [int]$maxRetries = 3,
        [int]$retryDelay = 10
    )

    $retryCount = 0
    $success = $false

    while (-not $success -and $retryCount -lt $maxRetries) {
        try {
            Invoke-Expression $cmds
            $success = $true
        }
        catch {
            $retryCount++
            Write-Host "Error occurred. Retrying... ($retryCount/$maxRetries)"
            Start-Sleep -Seconds $retryDelay
        }
    }

    if (-not $success) {
        Write-Host "Operation failed after $maxRetries attempts."
    }
}

$sites = Import-Csv -Path $csv_path
$batchSites_str = ""
$batchSites = [System.Collections.ArrayList]@()
foreach ($site in $sites) {
    $batchSites_str += $site.Url + ","
    $batchSites+= [PSCustomObject]@{
        Url = $site.Url
    }
    if(($batchSites.Count -gt 90) -or ($site -eq $sites[-1])) {
        $batchSites_str = $batchSites_str.TrimEnd(",")
        # Write-Host $batchSites_str
        $addCMD = "Set-RetentionCompliancePolicy -Identity `"Lenovo retention`" -AddSharePointLocationException $batchSites_str"
        # execute an other powershell script
        write-host "start to add exception ...."
        Invoke-WithRetry $addCMD
        # $addCMD
        Start-Sleep -Seconds 5
        waitPolicyDistribution
        remove-sites -sites $batchSites
        waitPolicyDistribution
        $delCMD = "Set-RetentionCompliancePolicy -Identity `"Lenovo retention`" -RemoveSharePointLocationException $batchSites_str"
        Write-Host "start to remove exception ...."
        

        Invoke-WithRetry $delCMD
        # $delCMD
        Start-Sleep -Seconds 5
        waitPolicyDistribution
        $batchSites_str = ""
        $batchSites = [System.Collections.ArrayList]@()
        # break
    }
}


