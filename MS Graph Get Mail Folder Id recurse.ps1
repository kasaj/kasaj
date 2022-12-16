Import-Module Microsoft.Graph.Mail
Connect-MgGraph -Scopes "User.Read.All","Group.ReadWrite.All","Mail.ReadWrite"

$timestamp = get-date -format dd.MM.yy-hh.mm.ss 
$mailbox= "filip@abc.abc"
$global:path = "$timestamp.csv"

"Mailbox`tParentFolder`tFolderName`tFolderId" > $global:path

function getChildFolderid ($userId,$fid,$root){
    $subfolders = Get-MgUserMailFolderChildFolder -UserId $userid -MailFolderId $fid -All #-ExpandProperty MultiValueExtendedPropertie
    foreach($subfolder in $subfolders){
         $fodername = $subfolder.displayname
         $id = $subfolder.id
         "$mailbox`t$root`t$fodername`t$id" >> $global:path
         "$mailbox`t$root`t$fodername`t$id"
      if($subfolder.childfoldercount -gt 0 -and $subfolder.id){
          getChildFolderid $mailbox $subfolder.id $subfolder.displayname
        }
    }
}

$rootfolders = Get-MgUserMailFolder -UserId $mailbox
foreach($rootfolder in $rootfolders){
  $fodername = $rootfolder.displayname
  $id = $rootfolder.id
  "$mailbox`tRoot`t$fodername`t$id" >> $global:path
    if($rootfolder.childfoldercount -gt 0 -and $rootfolder.id){
       getChildFolderid $mailbox $rootfolder.id "Root"
  }
}
