# The script is intended to export Exchange Onprem as well as Online mailbox properties (more $Cmdlets) as XML file per mailbox to $OutputFolder.
# Exchange Onprem Management Shell runspace expected

Connect-ExchangeOnline -Prefix EO

$OutputFolder = "C:\Temp\MailboxConfigBackup"

$Cmdlets = "Get-ADUser","Get-EOMailbox","Get-CASMailbox","Get-EOCalendarProcessing","Get-EOMailboxPermission","Get-EORecipientPermission","Get-EOMailboxRegionalConfiguration"

$RemoteMailboxes = Get-RemoteMailbox -ResultSize Unlimited

foreach($RemoteMailbox in $RemoteMailboxes) {    
    $Mailbox = [PSCustomObject]@{
        DisplayName = $RemoteMailbox.DisplayName
        PrimarySmtpAddress = $RemoteMailbox.PrimarySmtpAddress.tostring()
        RecipientTypeDetails = $RemoteMailbox.RecipientTypeDetails
        RemoteMailbox = $RemoteMailbox
    }
    
    $Email = $Mailbox.PrimarySmtpAddress
    $Email
    
    foreach($Cmdlet in $Cmdlets) {
        
        $Prop = $Cmdlet.split("-")[1]
        $Mailbox | Add-Member -MemberType NoteProperty -Name $Prop -Value "" -force
        
        if($Cmdlet -like "*ADUser") {
            Invoke-Expression -Command $('$Mailbox.'+"$Prop=$Cmdlet -filter {mail -eq '$Email'} -properties *")
        }elseif ($Cmdlet -like "*CalendarProcessing") {
            if($Mailbox.RecipientTypeDetails -notlike "*user*" -or $Mailbox.RecipientTypeDetails -notlike "*shared*") {
                Invoke-Expression -Command $('$Mailbox.'+"$Prop=$Cmdlet $Email")
            }
        }else{
            Invoke-Expression -Command $('$Mailbox.'+"$Prop=$Cmdlet $Email")
        }

    }

    $Mailbox | Export-Clixml -Encoding unicode -Path "$OutputFolder\$Email.xml" -Force -Confirm:$false

}

