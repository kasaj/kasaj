function Transpose-Object ($Objects, $Delimiter){
    $Props = $Objects | Get-Member -MemberType Property,NoteProperty|%{$_.name}
    $Report = [System.Collections.Generic.List[Object]]::new()
    foreach($Object in $Objects){
        foreach($Prop in $Props){
            $ReportLine = [PSCustomObject] @{
                PropertyName = $Prop
                Value = $Object.$Prop -join ($Delimiter)
            }
            $Report.Add($ReportLine)
        }
    }
    $Report
}

<# EXAMPLE

Get-Group "test *"|select DisplayName,Members 

DisplayName                  Members
-----------                  -------
Test Group 1                 {GradyA, ChristieC, AlexW}
Test Group 2                 {AlexW}

Convert-ObjectTransposed (Get-Group "test *"|select DisplayName,Members ) (", ")

PropertyName Value
------------ -----
DisplayName  Test Group 1
Members      GradyA, ChristieC, AlexW
DisplayName  Test Group 2
Members      AlexW

Convert-ObjectTransposed (Get-Group "test *"|select DisplayName,Members ) (", ") | Export-Csv -Path "Test" -Delimiter "`t" -NoTypeInformation -Encoding unicode

#>

