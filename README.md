移除SharePoint Online站点的一些常用命令和相关操作

需要首先链接到Sharepoint Online，然后才能执行以下命令

```shell
Remove-SPOSite -Identity  $url -Confirm:$false

```

其次需要链接到exchange online，然后才能执行以下命令

```
Set-RetentionCompliancePolicy -Identity `"Lenovo retention`" -AddSharePointLocationException $batchSites_str
```