Function Convert-MultivaluedProperties{
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline)] 
        [PsObject]$Object,
        [string] $Delimiter
    )
    Begin{
        $Out = @()
    }
    Process{
        $Props = $Object|Get-Member -MemberType property,NoteProperty|%{$_.name}
        foreach($Obj in $Object){
            $Line = "" | select $Props
            foreach($Prop in $Props){
                $Line.$Prop = $Obj.$Prop -join ($Delimiter)
            }
            $Out += $Line
        }
    }
    End{
        $Out
    }
}


<# EXAMPLE

PS C:\> Get-Group "test *"|select DisplayName,Members 

DisplayName                  Members
-----------                  -------
Test Group 1                 {GradyA, ChristieC, AlexW}
Test Group 2                 {AlexW}

PS C:\> Get-Group "test *"|select DisplayName,Members | Convert-MultivaluedProperties -Delimiter (", ")

DisplayName                  Members
-----------                  -------
Test Group 1                 GradyA, ChristieC, AlexW
Test Group 2                 AlexW

PS C:\> Get-Group "test *"|select DisplayName,Members | Convert-MultivaluedProperties -Delimiter (", ") | Export-Csv -Path "Test" -Delimiter "`t" -NoTypeInformation -Encoding unicode

#>