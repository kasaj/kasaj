#Requires -Module ExchangeOnlineManagement

<#
.SYNOPSIS
The script is intended to update TargetedUsersToProtect (impersonation protection) from an anti-phish policy based on a group members.

.DESCRIPTION
The script will check the input values (GroupIdentity, AntiPhishingPolicyIdentity) designated for identifying related objects in the environment.
It will then generate a list of TargetedUsersToProtect values (displayname;email) based on group members, where their secondary addresses are also utilized. 
If the anti-phishing policy already uses TargetedUsersToProtect, the values will be summed; otherwise, only those from the group will be used. 
Depending on the script's action, the values will be configured into the policy (Set) or displayed on the screen (Test).
Keep in mind that there is a maximum limit of 350 users for the TargetedUsersToProtect property under user impersonation protection in each anti-phishing policy.

.NOTES
Author: Filip Kasaj (KPCS CZ)
Date: 6.3.2024
Version: 1.0

PS /Users/fikas/Downloads> .\AntiPhishTargetedUsersToProtectViaGroup.ps1 -GroupIdentity "SG2" -AntiPhishingPolicyIdentity "Group-based anti-phishing policy 1" -Action "Test"
Exchange Online is connected.
Anti-phish policy was found.
Group was found.
Group member count:  3                                                                                                  
Group UsersToProtect count:  4
Current UsersToProtect count:  1
Total unique UsersToProtect count:  5

The anti-phishing policy 'Group-based anti-phishing policy 1' and its TargetedUsersToProtect configuration would be updated by:
christie cline;christiec@moderncomms376424.onmicrosoft.com
bob kelly (tailspin);bobk@tailspintoys.com
fikas;f@fikas.eu
fikas;f@moderncomms376424.onmicrosoft.com
alex wilber;alexw@moderncomms376424.onmicrosoft.com

.EXAMPLE
.\AntiPhishTargetedUsersToProtectViaGroup.ps1 -GroupIdentity "Group 123" -AntiPhishingPolicyIdentity "Anti-phishing policy 123" -Action "Test"
.\AntiPhishTargetedUsersToProtectViaGroup.ps1 -GroupIdentity "Group 123" -AntiPhishingPolicyIdentity "Anti-phishing policy 123" -Action "Set"

.LINK
Anti-phishing policies in Microsoft 365: https://learn.microsoft.com/en-us/microsoft-365/security/office-365-security/anti-phishing-policies-about?view=o365-worldwide
Order and precedence of email protection: https://learn.microsoft.com/en-us/microsoft-365/security/office-365-security/how-policies-and-protections-are-combined?view=o365-worldwide
#>

Param(
    [Parameter(Mandatory=$true)] [ValidateNotNullOrEmpty()] [string] $GroupIdentity,
    [Parameter(Mandatory=$true)] [ValidateNotNullOrEmpty()] [string] $AntiPhishingPolicyIdentity,
    [Parameter(Mandatory=$true)] [ValidateSet("Test", "Set")] [string] $Action
)

if(Get-ConnectionInformation |?{$_.State -eq "Connected" -and $_.Name -like "ExchangeOnline*" -and $_.ConnectionUri -eq "https://outlook.office365.com"}){
    write-host "Exchange Online is connected."
}else{
    return "Connect-ExchangeOnline is needed."
}

$AntiPhishPolicy = Get-AntiPhishPolicy $AntiPhishingPolicyIdentity
if($AntiPhishPolicy){
    write-host "Anti-phish policy was found."
    $Group = Get-DistributionGroup $GroupIdentity
    if($Group){
        write-host "Group was found."
        $GroupMembers = $Group | Get-DistributionGroupMember | select DisplayName,EmailAddresses
    }else{
        return "Group was not found."
    }
}else{
    return "Anti-phish policy was not found."
}

if($AntiPhishPolicy.IsDefault -eq $true){
     return "Anti-phish policy is defult, use custom policy."
}

[string[]]$UsersToProtect = $null
if($GroupMembers){
    write-host "Group member count: " ($GroupMembers|measure).count 
    foreach($GroupMember in $GroupMembers){
        foreach($Email in $GroupMember.EmailAddresses){
            if($Email -like "smtp:*" -and $Email -notlike "*.onmicrosoft.com"){
                [string[]]$UsersToProtect += $($GroupMember.displayname+";"+$($Email -replace("smtp:")))
            }
        }
    }
}else{
    return "No group members were found."
}

if($UsersToProtect){
    [string[]]$UsersToProtect = $UsersToProtect | ForEach-Object { $_.ToLower() } | select -Unique
    write-host "Group UsersToProtect count: " ($UsersToProtect|measure).count 
}else{
    return "No UsersToProtect composion."
}
<#
if($AntiPhishPolicy.TargetedUsersToProtect){
    write-host "Current UsersToProtect count: " ($AntiPhishPolicy.TargetedUsersToProtect|measure).count 
    [string[]]$UsersToProtect += $AntiPhishPolicy.TargetedUsersToProtect
    [string[]]$UsersToProtect = $UsersToProtect | ForEach-Object { $_.ToLower() } | select -Unique
}
#>

if($UsersToProtect){
    write-host "Total unique UsersToProtect count: " ($UsersToProtect|measure).count 
}

if(($UsersToProtect|measure).count -le 350){
    if($Action -eq "Set"){
        try{
            Set-AntiPhishPolicy -Identity $AntiPhishingPolicyIdentity -TargetedUsersToProtect $UsersToProtect -ErrorAction Stop
            write-host "`nAnti-phishing policy '$AntiPhishingPolicyIdentity' and its TargetedUsersToProtect configuration was updated by:"
            $UsersToProtect
        }catch{
            $_
        }
    }else{
        write-host "`nAnti-phishing policy '$AntiPhishingPolicyIdentity' and its TargetedUsersToProtect configuration would be updated by:"
        $UsersToProtect
    }
}else{
    return "There is a maximum limit of 350 users for the TargetedUsersToProtect property under user impersonation protection."
}


