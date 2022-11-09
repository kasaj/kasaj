Function Convert-MultivaluedProperties ($Objects,$Delimeter){
    $Report = @()
    $Props = $Objects|Get-Member -MemberType property,NoteProperty|%{$_.name}
    foreach($Object in $Objects){
        $Obj = "" | select $Props
        foreach($Prop in $Props){
            $Obj.$Prop = $Object.$Prop -join ($Delimeter)
        }
        $Report += $Obj
    }
    $Report
}

<# EXAMPLE

Get-Group "test *"|select DisplayName,Members 

DisplayName                  Members
-----------                  -------
Test Group 1                 {GradyA, ChristieC, AlexW}
Test Group 2                 {AlexW}

Convert-MultivaluedProperties (Get-Group "test *"|select DisplayName,Members ) (", ")

DisplayName                  Members
-----------                  -------
Test Group 1                 GradyA, ChristieC, AlexW
Test Group 2                 AlexW

Convert-ObjectTransposed (Get-Group "test *"|select DisplayName,Members ) (", ") | Export-Csv -Path "Test" -Delimiter "`t" -NoTypeInformation -Encoding unicode

#>