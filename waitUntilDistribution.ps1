$policy = Get-RetentionCompliancePolicy -Identity "Lenovo retention" -DistributionDetail

while ($policy.DistributionStatus -eq "Pending") {
    Write-Host "Distribution status is $($policy.DistributionStatus)" -ForegroundColor Yellow
    Start-Sleep -Seconds 60
    $policy = Get-RetentionCompliancePolicy -Identity "Lenovo retention" -DistributionDetail
}
Write-Host "Distribution status is Success" -ForegroundColor Green