Get-Alias gp*
 
"hello, world".gettype()
 
[datetime]$a="4/20/2020"
 
$a|get-member
 
Get-Help "Get-Service" -Examples
 
$b = @()
$a = "" | select name,count
$b += $a
$b | Add-Member -MemberType NoteProperty -Name Attribute1 -Value "" -force
 
$ErrorActionPreference = 'SilentlyContinue'
 
$dataCollection = [PSCustomObject]@{
   TXT = Resolve-DnsName $domain -Type TXT -Server 8.8.8.8
}
 
$Report = [System.Collections.Generic.List[Object]]::new()
$ReportLine = [PSCustomObject] @{
TimeStamp = Get-Date
User = "abc"
Action = "def"
Service = Get-Service }
$Report.Add($ReportLine)
 
$a="one
two
three".split("`n")
 
Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn
 
(Get-Mailbox -anr filip|Get-MailboxStatistics).TotalItemSize.Value.toBytes()
 
[Microsoft.Exchange.Data.ByteQuantifiedSize]::parse("34.01 MB (35,666,338 bytes)")
 
("34.01 MB (35,666,338 bytes)"|%{`
($_.Substring($_.indexof("(")+1,$_.indexof("b")-$_.indexof("(")-2)) -replace(",","")`
})/1MB
 
GCM exsetup |%{$_.Fileversioninfo}