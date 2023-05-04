
# PREREQUISITES
Connect-ExchangeOnline

# VARIABLES
$Identites = "shared2@fikas.eu","Shared@MODERNCOMMS376424.onmicrosoft.com"
$OutputFolder = "C:\Temp"
$OutputFilePath = "$OutputFolder\DraslovkaCZ_SharedMailboxes_FullAccessRegranting.xml"
$SleepSeconds = 2

# MAIN
$SharedMailboxes = @()
foreach($Identity in $Identites){
    write-host "`n$Identity" -ForegroundColor Yellow
    $SharedMailbox = "" | select Identity, Exist, Permissions, PermissionRegrantStatus, PermissionRegranted, Log
    $SharedMailbox.Identity = $Identity
    $Mailbox = @()
    $MailboxPerms = @()
    $Mailbox = Get-Mailbox -Identity $Identity
    if($Mailbox){
        $SharedMailbox.Exist = $true
        $MailboxPerms = Get-MailboxPermission -Identity $Identity -ErrorAction SilentlyContinue
        if($MailboxPerms){
            $SharedMailbox.Permissions = $MailboxPerms
            foreach($MailboxPerm in $($MailboxPerms|?{$_.user -notlike "NT AUTHORITY\SELF"})){
                try{
                    write-host "Remove-MailboxPermission " $MailboxPerm.user
                    Remove-MailboxPermission -Identity $Identity -User $MailboxPerm.user -AccessRights FullAccess -InheritanceType All -ErrorAction Stop -Confirm:$false | Out-Null
                    [string[]]$SharedMailbox.Log += "Remove-MailboxPermission "+$MailboxPerm.user
                    [bool[]]$SharedMailbox.PermissionRegrantStatus += $true
                    Start-Sleep -s $SleepSeconds
                    try{
                        write-host "Add-MailboxPermission " $MailboxPerm.user
                        Add-MailboxPermission -Identity $Identity -User $MailboxPerm.user -AccessRights FullAccess -InheritanceType All -AutoMapping $false -ErrorAction Stop -Confirm:$false | Out-Null
                        [string[]]$SharedMailbox.Log += "Add-MailboxPermission "+$MailboxPerm.user
                        [bool[]]$SharedMailbox.PermissionRegrantStatus += $true
                    }catch{
                        [string[]]$SharedMailbox.Log += "ERROR Add-MailboxPermission "+$MailboxPerm.user
                        [bool[]]$SharedMailbox.PermissionRegrantStatus += $false
                        $_
                    }
                }catch{
                    [string[]]$SharedMailbox.Log += "ERROR Remove-MailboxPermission "+$MailboxPerm.user
                    $SharedMailbox.PermissionRegrantStatus += $false
                    $_
                }
            }
            if($SharedMailbox.PermissionRegrantStatus -contains $false){
                $SharedMailbox.PermissionRegranted = $false
            }else{
                $SharedMailbox.PermissionRegranted = $true
            }
        }
    }else{
        $SharedMailbox.Exist = $false
        $SharedMailbox.PermissionRegranted = $false
    }
    $SharedMailboxes += $SharedMailbox
}
$SharedMailboxes | Export-Clixml -Path $OutputFilePath -Encoding unicode -Force -Confirm:$false
$SharedMailboxes|ft Identity,Exist, PermissionRegranted -a
Write-Host "`Export file $OutputFilePath`n" -ForegroundColor Yellow

