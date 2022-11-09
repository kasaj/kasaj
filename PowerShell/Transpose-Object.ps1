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

PS C:\> Get-OrganizationConfig|select *pla*

DisplayName                 : Contoso
PreviousAdminDisplayVersion : 0.10 (14.0.100.0)
AdminDisplayVersion         : 0.20 (15.20.5813.11)
IsUpdatingServicePlan       : False
ServicePlan                 : BPOS_S_E15_0
TargetServicePlan           : 
InPlaceHolds                : {grp29d1313ebf2742b896e2ac057e619a81:1, mbx29d1313ebf2742b896e2ac057e619a81:1, mbx8e3818129bcd42298ffeb3e4fb0e3914:1, grp8e3818129bcd42298ffeb3e4fb0e3914:1}    
IsMIPLabelForGroupsEnabled  : False

PS C:\> Transpose-Object (Get-OrganizationConfig|select *pla*) (", ")

PropertyName                PropertyValue
------------                -------------
AdminDisplayVersion         0.20 (15.20.5813.11)
DisplayName                 Contoso
InPlaceHolds                grp29d1313ebf2742b896e2ac057e619a81:1, mbx29d1313ebf2742b896e2ac057e619a81:1, mbx8e3818129bcd42298ffeb3e4fb0e3914:1, grp8e3818129bcd42298ffeb3e4fb0e3914:1        
IsMIPLabelForGroupsEnabled  False
IsUpdatingServicePlan       False
PreviousAdminDisplayVersion 0.10 (14.0.100.0)
ServicePlan                 BPOS_S_E15_0
TargetServicePlan

PS C:\> Transpose-Object (Get-OrganizationConfig|select *pla*) (", ") | Export-Csv -Path "Test" -Delimiter "`t" -NoTypeInformation -Encoding unicode

#>

