# MODULE

# Install-module AzureADPreview
# https://learn.microsoft.com/en-us/powershell/azure/active-directory/install-adv2?view=azureadps-2.0

# VARIABLE

$timeStamp = get-date -Format yyyyMMdd
$csvExportFilePath = "C:\Temp\AADServicePrincipals_$timeStamp.csv"
$jsonExportFilePath = "C:\Temp\AADServicePrincipals_$timeStamp.json"

# MAIN

Write-host "Connect-AzureAD"
Connect-AzureAD

Write-host "Get-AzureADServicePrincipal"
$Sps = Get-AzureADServicePrincipal -All:1
Write-host "Get-AzureADOAuth2PermissionGrant"
$Pes = Get-AzureADOAuth2PermissionGrant -All:1
Write-host "Get-AzureADApplication"
$Aps = Get-AzureADApplication -All:1

$Sps | Add-Member -MemberType NoteProperty -Name 'AzureADServiceAppRoleAssignment' -Value "" -force # regular non-Managed Identity Service Principals (such as users and manually created Service Principals)
$Sps | Add-Member -MemberType NoteProperty -Name 'AzureADServiceAppRoleAssignedTo' -Value "" -force 
$Sps | Add-Member -MemberType NoteProperty -Name 'AzureADOAuth2PermissionGrant' -Value "" -force # delegated permissions
$Sps | Add-Member -MemberType NoteProperty -Name 'AzureADApplication' -Value "" -force
$Sps | Add-Member -MemberType NoteProperty -Name 'RegisteredApp' -Value "" -force
$Sps | Add-Member -MemberType NoteProperty -Name 'EnterpriseApp' -Value "" -force

$i=0
foreach ($Sp in $Sps){
    $i++
    write-host $($Sp.DisplayName+" ($i/"+$Sps.count+")")
    $Sp.AzureADServiceAppRoleAssignment = Get-AzureADServiceAppRoleAssignment -ObjectId $Sp.ObjectId
    $Sp.AzureADServiceAppRoleAssignedTo = Get-AzureADServiceAppRoleAssignedTo -ObjectId $Sp.ObjectId
    $Sp.AzureADOAuth2PermissionGrant = $Pes|?{$_.ClientId -eq $Sp.ObjectId}
    $Sp.AzureADApplication = $Aps|?{$_.AppId -eq $Sp.AppId}
    if($Sp.AzureADApplication){
        $Sp.RegisteredApp = $True
    }
    if($Sp.Tags -eq "WindowsAzureActiveDirectoryIntegratedApp"){
        $Sp.EnterpriseApp = $True
    }
}

$i=0
foreach ($Sp in $Sps){
    $i++
    write-host $($Sp.DisplayName+" ($i/"+$Sps.count+")")
    if($Sp.AzureADServiceAppRoleAssignment){
        $Sp.AzureADServiceAppRoleAssignment  | Add-Member -MemberType NoteProperty -Name 'AppRoleDisplayName' -Value "" -force
        $Sp.AzureADServiceAppRoleAssignment  | Add-Member -MemberType NoteProperty -Name 'AppRoleValue' -Value "" -force
        foreach($a in $Sp.AzureADServiceAppRoleAssignment){
            $AppRole = $Sps.Approles |?{$_.id -eq $a.id}
            if($AppRole){
                $a.AppRoleDisplayName = $AppRole.DisplayName
                $a.AppRoleValue = $AppRole.Value
            }
        }
    }
    if($Sp.AzureADServiceAppRoleAssignedTo){
        $Sp.AzureADServiceAppRoleAssignedTo  | Add-Member -MemberType NoteProperty -Name 'AppRoleDisplayName' -Value "" -force
        $Sp.AzureADServiceAppRoleAssignedTo  | Add-Member -MemberType NoteProperty -Name 'AppRoleValue' -Value "" -force
        foreach($a in $Sp.AzureADServiceAppRoleAssignedTo){
            $AppRole = $Sps.Approles |?{$_.id -eq $a.id}
            if($AppRole){
                $a.AppRoleDisplayName = ($AppRole.DisplayName|select -Unique) -join (", ")
                $a.AppRoleValue = ($AppRole.Value|select -Unique) -join (", ")
            }
        }
    }
}

Write-host "ExportToCsv $csvExportFilePath"
$Sps|select Info,DisplayName,ServicePrincipalType,AppId,ObjectId,Homepage,LogoutUrl,AppOwnerTenantId,PublisherName,AccountEnabled,AppRoleAssignmentRequired,`
@{n="ADAppAllowGuestsSignIn";e={$_.AzureADApplication.AllowGuestsSignIn -join(", ")}},`
@{n="ADAppAllowPassthroughUsers";e={$_.AzureADApplication.AllowPassthroughUsers -join(", ")}},`
@{n="ADAppIsDeviceOnlyAuthSupported";e={$_.AzureADApplication.IsDeviceOnlyAuthSupported -join(", ")}},`
@{n="ADAppTermsOfService";e={$_.AzureADApplication.InformationalUrls.TermsOfService -join(", ")}},`
@{n="ADAppSupport";e={$_.AzureADApplication.InformationalUrls.Support -join(", ")}},`
@{n="ADAppPrivacy";e={$_.AzureADApplication.InformationalUrls.Privacy -join(", ")}},`
@{n="ADAppMarketing";e={$_.AzureADApplication.InformationalUrls.Marketing -join(", ")}},`
@{n="ADAppOauth2AllowImplicitFlow";e={$_.AzureADApplication.Oauth2AllowImplicitFlow -join(", ")}},`
@{n="ADAppPublisherDomain";e={$_.AzureADApplication.PublisherDomain -join(", ")}},`
@{n="ADAppIdentifierUris";e={$_.AzureADApplication.IdentifierUris -join(", ")}},`
@{n="AppRolesValue";e={$_.AppRoles.value -join(", ")}},`
@{n="Oauth2PermissionsType";e={$_.Oauth2Permissions.Type -join(", ")}},`
@{n="Oauth2PermissionsValue";e={$_.Oauth2Permissions.Value -join(", ")}},`
@{n="Oauth2PermissionsUserConsentDescription";e={$_.Oauth2Permissions.UserConsentDescription -join(", ")}},`
@{n="AppRoleAssignmentPrincipalDisplayName";e={$_.AzureADServiceAppRoleAssignment.PrincipalDisplayName -join(", ")}},`
@{n="AppRoleAssignmentId";e={$_.AzureADServiceAppRoleAssignment.Id -join(", ")}},`
@{n="AppRoleAssignmentAppRoleValue";e={$_.AzureADServiceAppRoleAssignment.AppRoleValue -join(", ")}},`
@{n="PermissionGrantConsentType";e={$_.AzureADOAuth2PermissionGrant.ConsentType -join(", ")}},`
@{n="PermissionGrantScope";e={$_.AzureADOAuth2PermissionGrant.Scope -join(", ")}},`
@{n="AppRoleAssignedToDisplayName";e={$_.AzureADServiceAppRoleAssignedTo.PrincipalDisplayName -join(", ")}},`
@{n="AppRoleAssignedToId";e={$_.AzureADServiceAppRoleAssignedTo.Id -join(", ")}},`
@{n="AppRoleAssignedToAppRoleValue";e={$_.AzureADServiceAppRoleAssignedTo.AppRoleValue -join(", ")}},`
@{n="TagStrings";e={$_.tags -join(", ")}},`
@{n="KeyCredentialsEndDate";e={$_.KeyCredentials.EndDate -join(", ")}},`
@{n="KeyCredentialsType";e={$_.KeyCredentials.Type -join(", ")}}`
| Export-Csv -Path $csvExportFilePath  -Delimiter "`t" -Encoding unicode -NoTypeInformation

Write-host "ExportToJson $csvExportFilePath"
$Sps|ConvertTo-Json -Depth 10 > $jsonExportFilePath

# NOTES
<# 
Get-AzureADApplication
Get-AzureADApplicationExtensionProperty
Get-AzureADApplicationKeyCredential
Get-AzureADApplicationLogo
Get-AzureADApplicationOwner
Get-AzureADApplicationPasswordCredential
Get-AzureADApplicationServiceEndpoint
Get-AzureADDeletedApplication

RegisteredApp - AzureADApplication
EnterpriseApp
Run the cmd below to get a list of all integrated apps (enterprise apps):
Get-AzureADServicePrincipal -All:$true | ? {$_.Tags -eq "WindowsAzureActiveDirectoryIntegratedApp"}

ADAppAllowPassthroughUsers
Gets or sets indicates that the application supports pass through users who have no presence in the resource tenant.

TagStrings (HideApp)
If this option is set to yes, then assigned users will see the application on My Apps and O365 app launcher. If this option is set to no, then no users will see this application on their My Apps and O365 launcher.

appRoleAssignmentRequired
If this option is set to yes, then users and other apps or services must first be assigned this application before being able to access it.
If this option is set to no, then all users will be able to sign in, and other apps and services will be able to obtain an access token to this service.
This option does not affect whether or not an application appears on My Apps. To show the application there, assign an appropriate user or group to the application.
This option only applies to the following types of applications and services: applications using SAML, OpenID Connect, OAuth 2.0, or WS-Federation for user sign-in, Application Proxy applications with Microsoft Entra pre-authentication enabled, and applications or services for which other applications or service are requesting access tokens.
This option has no effect on users' access to the app when the application is configured for any of the other single sign-on modes.

AccountEnabled
If this option is set to yes, then assigned users will be able to sign in to this application, either from My Apps, the User access URL, or by navigating to the application URL directly.
If this option is set to no, then no users will be able to sign in to this app, even if they are assigned to it.

appRoleAssignment
App roles that are assigned to service principals are also known as application permissions. Application permissions can be granted directly with app role assignments, or through a consent experience.

Install-Module Microsoft.Graph -Scope CurrentUser -Allow
https://learn.microsoft.com/en-us/powershell/microsoftgraph/installation?view=graph-powershell-1.0
Connect-MgGraph -Scopes Application.Read.All,AuditLog.Read.All,Directory.Read.All
$Aps = Get-MgApplication -All
$Sps =  Get-MgServicePrincipal -All

List all application role assignments for all service principals in your directory
https://learn.microsoft.com/en-us/powershell/azure/active-directory/list-service-principal-application-roles?view=azureadps-2.0
# Get all service principals, and for each one, get all the app role assignments, 
# resolving the app role ID to it's display name. 
Get-AzureADServicePrincipal | % {

  # Build a hash table of the service principal's app roles. The 0-Guid is
  # used in an app role assignment to indicate that the principal is assigned
  # to the default app role (or rather, no app role).
  $appRoles = @{ "$([Guid]::Empty.ToString())" = "(default)" }
  $_.AppRoles | % { $appRoles[$_.Id] = $_.DisplayName }

  # Get the app role assignments for this app, and add a field for the app role name
  Get-AzureADServiceAppRoleAssignment -ObjectId ($_.ObjectId) | Select ResourceDisplayName, PrincipalDisplayName,  Id | % {  $_ | Add-Member "AppRoleDisplayName" $appRoles[$_.Id] -Passthru
  }
}

https://github.com/microsoft/AzureADToolkit/tree/main
Get-AzureADPSPermissions.ps1 - https://gist.github.com/psignoret/41793f8c6211d2df5051d77ca3728c09
https://github.com/microsoft/EntraExporter/blob/main/src/Get-EEDefaultSchema.ps1

https://github.com/microsoft/AzureADToolkit/blob/main/src/data/aadconsentgrantpermissiontable.csv
Type	Permission	Privilege	Reason
Delegated	Mail.ReadBasic	Medium	DataExfiltration
Delegated	Mail	High	Phishing
Delegated	Contacts	High	Phishing
Delegated	MailboxSettings	High	Phishing
Delegated	People	High	Phishing
Delegated	Files	High	Phishing
Delegated	Notes	High	Phishing
Delegated	Directory.AccessAsUser.All	High	Phishing
Delegated	user_impersonation	High	Phishing
Delegated	Application.ReadWrite.All	High	BroadImpact
Delegated	Directory.ReadWrite.All	High	BroadImpact
Delegated	Domain.ReadWrite.All	High	BroadImpact
Delegated	EduRoster.ReadWrite.All	High	BroadImpact
Delegated	Group.ReadWrite.All	High	BroadImpact
Delegated	Member.Read.Hidden	High	BroadImpact
Delegated	RoleManagement.ReadWrite.Directory	High	BroadImpact
Delegated	User.ReadWrite.All	High	BroadImpact
Delegated	User.ManageCreds.All	High	BroadImpact
Application	Mail	High	Phishing
Application	Contacts	High	Phishing
Application	MailboxSettings	High	Phishing
Application	People	High	Phishing
Application	Files	High	Phishing
Application	Notes	High	Phishing
Application	Directory.AccessAsUser.All	High	Phishing
Application	user_impersonation	High	Phishing
Application	Application.ReadWrite.All	High	BroadImpact
Application	Directory.ReadWrite.All	High	BroadImpact
Application	Domain.ReadWrite.All	High	BroadImpact
Application	EduRoster.ReadWrite.All	High	BroadImpact
Application	Group.ReadWrite.All	High	BroadImpact
Application	Member.Read.Hidden	High	BroadImpact
Application	RoleManagement.ReadWrite.Directory	High	BroadImpact
Application	User.ReadWrite.All	High	BroadImpact
Application	User.ManageCreds.All	High	BroadImpact
Delegated	User.Read	Low	Common pattern
Delegated	User.ReadBasic.All	Low	Common pattern
Delegated	open_id	Low	Common pattern
Delegated	email	Low	Common pattern
Delegated	profile	Low	Common pattern
Delegated	offline_access	Low	Common pattern when used with other low permissions
#>
