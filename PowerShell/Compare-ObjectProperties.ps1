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
                Equal = if($diff.SideIndicator -eq '=='){$true}else{$false}
            }
            $diffs += New-Object PSObject -Property $diffprops
        }        
    }
    if ($diffs) {
        return ($diffs | Select PropertyName,EqualValue,RefValue,DiffValue,Equal)
    }     
}

<# EXAMPLE

$Obj1 = [PSCustomObject] @{
    Id = "Test"
    Value = 1
    Info = ""
    No = $false
}

$Obj2 = [PSCustomObject] @{
    Id = "Test"
    Value = 2
    Info = "" 
    Yes = $true
}

Compare-ObjectProperties $Obj1 $Obj2 | ft

PropertyName EqualValue RefValue DiffValue Equal
------------ ---------- -------- --------- -----
Id           Test                           True
Info                                        True
No                      False              False
Value                   1        2         False
Yes                              True      False

#>