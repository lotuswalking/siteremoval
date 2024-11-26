Get-ChildItem -Path D:\sftp -Filter deletedsposite_*.csv | ForEach-Object {
    $file = "D:\sftp\"+$_
    $lineCount = (Get-Content $file | Measure-Object -Line).Lines
    Write-Output "The number of lines in $file is: $lineCount"
}
