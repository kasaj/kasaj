Function Transpose-Object ($Objects, $Delimiter){
    $Props = $Objects | Get-Member -MemberType Property,NoteProperty|%{$_.name}
    $Report = [System.Collections.Generic.List[Object]]::new()
    foreach($Object in $Objects){
        foreach($Prop in $Props){
            $ReportLine = [PSCustomObject] @{
                PropertyName = $Prop
                PropertyValue = $Object.$Prop -join ($Delimiter)
            }
            $Report.Add($ReportLine)
        }
    }
    $Report
}

<# EXAMPLE

PS C:\> Get-Group "test *"|select DisplayName,Members 

DisplayName                  Members
-----------                  -------
Test Group 1                 {GradyA, ChristieC, AlexW}
Test Group 2                 {AlexW}

PS C:\> Transpose-Object (Get-Group "test *"|select DisplayName,Members ) (", ")

PropertyName PropertyValue
------------ -------------
DisplayName  Test Group 1
Members      GradyA, ChristieC, AlexW
DisplayName  Test Group 2
Members      AlexW

PS C:\> Transpose-Object (Get-Group "test *"|select DisplayName,Members ) (", ") | Export-Csv -Path "Test" -Delimiter "`t" -NoTypeInformation -Encoding unicode

PS C:\> Get-OrganizationConfig|select *app*

AppsForOfficeEnabled               : True
AppsForOfficeCorpCatalogAppsCount  : 0
PrivateCatalogAppsCount            : 0
EwsApplicationAccessPolicy         : 
BookingsMembershipApprovalRequired : False
MobileAppEducationEnabled          : True
BasicAuthBlockedApps               : None

PS C:\> Transpose-Object (Get-OrganizationConfig|select *app*)

PropertyName                       PropertyValue
------------                       -------------
AppsForOfficeCorpCatalogAppsCount  0
AppsForOfficeEnabled               True
BasicAuthBlockedApps               None
BookingsMembershipApprovalRequired False
EwsApplicationAccessPolicy
MobileAppEducationEnabled          True
PrivateCatalogAppsCount            0

#>

