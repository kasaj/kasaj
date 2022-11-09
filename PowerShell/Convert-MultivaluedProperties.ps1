function Convert-MultivaluedProperties ($In,$Delimeter){
    $Out = @()
    $Props = $In|Get-Member -MemberType property,NoteProperty|%{$_.name}
    foreach($i in $In){
        $Obj = "" | select $Props
        foreach($Prop in $Props){
            $Obj.$Prop = $i.$Prop -join ($Delimeter)
        }
        $Out+=$Obj
    }
    $Out
}

<# EXAMPLE

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