$CsvPath = "C:\Temp\sip_change.csv"
$CsvData = Import-Csv -Path $CsvPath -Delimiter ","

$CsvData | Add-Member -MemberType NoteProperty -Name SipRemovalStatus -Value "" -force
$CsvData | Add-Member -MemberType NoteProperty -Name SipRemovalError -Value "" -force
$CsvData | Add-Member -MemberType NoteProperty -Name SipAddingStatus -Value "" -force
$CsvData | Add-Member -MemberType NoteProperty -Name SipAddingError -Value "" -force

foreach($Line in $CsvData){
	try{
		Set-Mailbox -identity $Line.PrimarySmtpAddress -EmailAddresses @{remove=$Line.$SIPADDRESS} -ErrorAction Stop
        $Line.SipRemovalStatus = "OK"
        try{
            Set-Mailbox -identity $Line.PrimarySmtpAddress -EmailAddresses @{add=$line.$newSIP} -ErrorAction Stop
            $Line.SipAddingStatus = "OK"
        }catch{
            $Line.SipAddingStatus = "Failed"
            $Line.SipAddingError = $_
        }
	}catch{
        $Line.SipRemovalStatus = "Failed"
        $Line.SipRemovalError = $_
	}
}

$CsvData | Group SipRemovalStatus
$CsvData | Group SipAddingStatus