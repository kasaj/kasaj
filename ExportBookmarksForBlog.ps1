$FilePath = "C:\exported-bookmarks.html"
$Bookmarks = get-content $FilePath 
$Lines = $Bookmarks | ?{$_ -like "*HREF=*"}
foreach($Line in $Lines){
    $Temp = ""
    $Temp = $Line.split('"')
    $Temp[4] -replace ("</a>","\\") -replace (">")
    $Temp[1]
    write-host "`n"
}