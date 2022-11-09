function Convert-MultivaluedProperties ($Objects,$Delimeter){
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

get-mailbox 1*|select Name,EmailAddresses

$Obj = [PSCustomObject] @{
    Identity = "Test"
    Values = "1","2","3"
    Info = "" 
}

Report = Convert-MultivaluedProperties $Obj ", "

$Report 

Identity Info Values
-------- ---- ------
Test          1, 2, 3

$Report | Export-Csv -Path "Test" -Delimiter "`t" -NoTypeInformation -Encoding unicode

#>