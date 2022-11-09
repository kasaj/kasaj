Function Compare-ObjectProperties {
    Param(
        [PSObject]$ReferenceObject,
        [PSObject]$DifferenceObject 
    )
    $objprops = @()
    $objprops += $ReferenceObject | Get-Member -MemberType Property,NoteProperty | % Name
    $objprops += $DifferenceObject | Get-Member -MemberType Property,NoteProperty | % Name
    $objprops = $objprops | Sort | Select -Unique
    $diffs = @()
    foreach ($objprop in $objprops) {
        $diff = Compare-Object $ReferenceObject $DifferenceObject -Property $objprop -IncludeEqual
        if ($diff) {            
            $diffprops = @{
                PropertyName=$objprop
                RefValue = ($diff | ? {$_.SideIndicator -eq '<='} | % $($objprop))
                DiffValue = ($diff | ? {$_.SideIndicator -eq '=>'} | % $($objprop))
                EqualValue = ($diff | ? {$_.SideIndicator -eq '=='} | % $($objprop))
                PropertyEqual = if($diff.SideIndicator -eq '=='){$true}else{$false}
            }
            $diffs += New-Object PSObject -Property $diffprops
        }        
    }
    if ($diffs) {
        return ($diffs | Select PropertyName,PropertyEqual,EqualValue,RefValue,DiffValue)
    }     
}

<# EXAMPLE

PS C:\> $Obj1 = [PSCustomObject] @{
        Id = "Test"
        Value = 1
        Info = ""
        No = $false
        }

PS C:\> $Obj2 = [PSCustomObject] @{
        Id = "Test"
        Value = 2
        Info = "" 
        Yes = $true
        }

PS C:\> Compare-ObjectProperties $Obj1 $Obj2 | ft

PropertyName PropertyEqual EqualValue RefValue DiffValue
------------ ------------- ---------- -------- ---------
Id                    True Test
Info                  True
No                   False            False
Value                False            1        2
Yes                  False                     True

#>