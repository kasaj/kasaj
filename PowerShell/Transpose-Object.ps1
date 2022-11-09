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

get-mailbox 11|select Name,EmailAddresses

Name EmailAddresses
---- --------------
11   {SIP:11@fikas.eu, SMTP:11@fikas.eu}

Convert-ObjectTransposed (get-mailbox 11|select Name,EmailAddresses) (", ")

PropertyName   Value
------------   -----
EmailAddresses SIP:11@fikas.eu, SMTP:11@fikas.eu
Name           11

Convert-ObjectTransposed (get-mailbox 11|select Name,EmailAddresses) (", ") | Export-Csv -Path "Test" -Delimiter "`t" -NoTypeInformation -Encoding unicode

#>

