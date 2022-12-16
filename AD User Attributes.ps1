##  All AD atributes used by users

# Define variables
$users_list = ("c:\temp\AllAdExport_Users_{0:yyyyMMdd_HHmmss}.csv" -f (get-date))
$Delim = "`t"
$DelimMulti = ","

# Export objects to CSV
$allUsers = Get-ADUser  -Filter * -Properties *
$allUserProperties =  $allUsers | %{ $_.psobject.properties | select Name } | select -expand Name -Unique | sort
$allUsers | select $allUserProperties | ConvertMultivaluedProperties -Delimiter $DelimMulti | export-csv $users_list -NoTypeInformation -Encoding Unicode -Delimiter $Delim

## All AD available attributes for user class

<# EXAMPLE

Get-ADUser DZC09WJ | Get-ADUserAllProps | fl msex*

msExchAcceptedDomainBL                                : {}
msExchAccountForestBL                                 : {}
msExchADCGlobalNames                                  : {}
msExchAddressBookFlags                                : 
msExchAddressBookPolicyLink                           : 
msExchAdministrativeUnitBL                            : {}
msExchAdministrativeUnitLink                          : {}
msExchAggregationSubscriptionCredential               : {}
msExchALObjectVersion                                 : 
msExchAlternateMailboxes                              : {}
msExchApprovalApplicationLink                         : {}
msExchArbitrationMailbox                              : 
msExchArchiveAddress                                  : 
msExchArchiveDatabaseBL                               : {}
msExchArchiveDatabaseLink                             : 
msExchArchiveDatabaseLinkSL                           : 
msExchArchiveGUID                                     : 
msExchArchiveName                                     : {}
msExchArchiveQuota                                    : 
msExchArchiveRelease                                  : 
msExchArchiveStatus                                   : 
msExchArchiveWarnQuota                                : 
msExchAssistantName                                   : 
msExchAssociatedAcceptedDomainBL                      : {}
msExchAuditAdmin                                      : 
msExchAuditDelegate                                   : 
msExchAuditDelegateAdmin                              : 
msExchAuditOwner                                      : 
msExchAuthPolicyBL                                    : {}
msExchAuthPolicyLink                                  : 
msExchAuxMailboxParentObjectIdBL                      : {}
msExchAuxMailboxParentObjectIdLink                    : 
msExchAvailabilityOrgWideAccountBL                    : {}
msExchAvailabilityPerUserAccountBL                    : {}
msExchBlockedSendersHash                              : 
msExchBypassAudit                                     : 
msExchBypassModerationBL                              : {}
msExchBypassModerationFromDLMembersBL                 : {}
msExchBypassModerationFromDLMembersLink               : {}
msExchBypassModerationLink                            : {}
msExchCalculatedTargetAddress                         : 
msExchCalendarLoggingQuota                            : 
msExchCalendarRepairDisabled                          : 
msExchCanaryData0                                     : 
msExchCanaryData1                                     : 
msExchCanaryData2                                     : 
msExchCapabilityIdentifiers                           : {}
msExchCatchAllRecipientBL                             : {}
msExchCoManagedObjectsBL                              : {}
msExchConferenceMailboxBL                             : 
msExchConfigurationUnitBL                             : {}
msExchConfigurationXML                                : 
msExchContentConversionSettings                       : 
msExchControllingZone                                 : 
msExchCorrelationId                                   : 
msExchCU                                              : 
msExchCustomProxyAddresses                            : {}
msExchDataEncryptionPolicyBL                          : {}
msExchDataEncryptionPolicyLink                        : 
msExchDefaultPublicFolderMailbox                      : 
msExchDelegateListBL                                  : {}
msExchDelegateListLink                                : {}
msExchDeviceAccessControlRuleBL                       : {}
msExchDirsyncAuthorityMetadata                        : {}
msExchDirsyncID                                       : 
msExchDirsyncSourceObjectClass                        : 
msExchDirsyncStatusAck                                : {}
msExchDisabledArchiveDatabaseLink                     : 
msExchDisabledArchiveDatabaseLinkSL                   : 
msExchDisabledArchiveGUID                             : 
msExchDumpsterQuota                                   : 
msExchDumpsterWarningQuota                            : 
msExchEdgeSyncConfigFlags                             : 
msExchEdgeSyncCookies                                 : {}
msExchEdgeSyncRetryCount                              : 
msExchEdgeSyncSourceGuid                              : 
msExchELCExpirySuspensionEnd                          : 
msExchELCExpirySuspensionStart                        : 
msExchELCMailboxFlags                                 : 
msExchEnableModeration                                : 
msExchEvictedMemebersBL                               : {}
msExchEwsApplicationAccessPolicy                      : 
msExchEwsEnabled                                      : 
msExchEwsExceptions                                   : {}
msExchEwsWellKnownApplicationPolicies                 : {}
msExchExpansionServerName                             : 
msExchExtensionAttribute16                            : 
msExchExtensionAttribute17                            : 
msExchExtensionAttribute18                            : 
msExchExtensionAttribute19                            : 
msExchExtensionAttribute20                            : 
msExchExtensionAttribute21                            : 
msExchExtensionAttribute22                            : 
msExchExtensionAttribute23                            : 
msExchExtensionAttribute24                            : 
msExchExtensionAttribute25                            : 
msExchExtensionAttribute26                            : 
msExchExtensionAttribute27                            : 
msExchExtensionAttribute28                            : 
msExchExtensionAttribute29                            : 
msExchExtensionAttribute30                            : 
msExchExtensionAttribute31                            : 
msExchExtensionAttribute32                            : 
msExchExtensionAttribute33                            : 
msExchExtensionAttribute34                            : 
msExchExtensionAttribute35                            : 
msExchExtensionAttribute36                            : 
msExchExtensionAttribute37                            : 
msExchExtensionAttribute38                            : 
msExchExtensionAttribute39                            : 
msExchExtensionAttribute40                            : 
msExchExtensionAttribute41                            : 
msExchExtensionAttribute42                            : 
msExchExtensionAttribute43                            : 
msExchExtensionAttribute44                            : 
msExchExtensionAttribute45                            : 
msExchExtensionCustomAttribute1                       : {}
msExchExtensionCustomAttribute2                       : {}
msExchExtensionCustomAttribute3                       : {}
msExchExtensionCustomAttribute4                       : {}
msExchExtensionCustomAttribute5                       : {}
msExchExternalDirectoryObjectId                       : 
msExchExternalOOFOptions                              : 
msExchExternalSyncState                               : 
msExchFBURL                                           : 
msExchForeignGroupSID                                 : 
msExchForestModeFlag                                  : 
msExchGenericForwardingAddress                        : 
msExchGroupExternalMemberCount                        : 
msExchGroupMemberCount                                : 
msExchGroupSecurityFlags                              : 
msExchHABRootDepartmentBL                             : {}
msExchHABRootDepartmentLink                           : 
msExchHABShowInDepartments                            : {}
msExchHideFromAddressLists                            : 
msExchHomeMDBSL                                       : 
msExchHomeMTASL                                       : 
msExchHomeServerName                                  : 
msExchHouseIdentifier                                 : 
msExchHygieneConfigurationMalwareBL                   : {}
msExchHygieneConfigurationSpamBL                      : {}
msExchIMACL                                           : {}
msExchIMAddress                                       : 
msExchIMAP4Settings                                   : 
msExchIMAPOWAURLPrefixOverride                        : 
msExchIMMetaPhysicalURL                               : 
msExchImmutableId                                     : 
msExchImmutableSid                                    : 
msExchIMPhysicalURL                                   : 
msExchIMVirtualServer                                 : 
msExchInconsistentState                               : 
msExchIntendedMailboxPlanBL                           : {}
msExchIntendedMailboxPlanLink                         : 
msExchInterruptUserOnAuditFailure                     : 
msExchIsMSODirsynced                                  : 
msExchLabeledURI                                      : {}
msExchLastExchangeChangedTime                         : 
msExchLicenseToken                                    : 
msExchLitigationHoldDate                              : 
msExchLitigationHoldOwner                             : 
msExchLocalizationFlags                               : 
msExchMailboxAuditEnable                              : 
msExchMailboxAuditLastAdminAccess                     : 
msExchMailboxAuditLastDelegateAccess                  : 
msExchMailboxAuditLastExternalAccess                  : 
msExchMailboxAuditLogAgeLimit                         : 
msExchMailboxContainerGuid                            : 
msExchMailboxFolderSet                                : 
msExchMailboxFolderSet2                               : 
msExchMailboxGuid                                     : {61, 45, 64, 40...}
msExchMailboxMoveBatchName                            : 
msExchMailboxMoveFlags                                : 
msExchMailboxMoveRemoteHostName                       : 
msExchMailboxMoveSourceArchiveMDBBL                   : {}
msExchMailboxMoveSourceArchiveMDBLink                 : 
msExchMailboxMoveSourceArchiveMDBLinkSL               : 
msExchMailboxMoveSourceMDBBL                          : {}
msExchMailboxMoveSourceMDBLink                        : 
msExchMailboxMoveSourceMDBLinkSL                      : 
msExchMailboxMoveSourceUserBL                         : {}
msExchMailboxMoveStatus                               : 
msExchMailboxMoveStorageMDBBL                         : {}
msExchMailboxMoveTargetArchiveMDBBL                   : {}
msExchMailboxMoveTargetArchiveMDBLink                 : 
msExchMailboxMoveTargetArchiveMDBLinkSL               : 
msExchMailboxMoveTargetMDBBL                          : {}
msExchMailboxMoveTargetMDBLink                        : 
msExchMailboxMoveTargetMDBLinkSL                      : 
msExchMailboxMoveTargetUserBL                         : {}
msExchMailboxOABVirtualDirectoriesLink                : {}
msExchMailboxPlanType                                 : 
msExchMailboxRelease                                  : 
msExchMailboxSecurityDescriptor                       : 
msExchMailboxTemplateLink                             : 
msExchMailboxUrl                                      : 
msExchManagementSettings                              : 
msExchMasterAccountSid                                : 
msExchMaxBlockedSenders                               : 
msExchMaxSafeSenders                                  : 
msExchMDBAvailabilityGroupConfigurationBL             : {}
msExchMDBRulesQuota                                   : 
msExchMessageHygieneFlags                             : 
msExchMessageHygieneSCLDeleteThreshold                : 
msExchMessageHygieneSCLJunkThreshold                  : 
msExchMessageHygieneSCLQuarantineThreshold            : 
msExchMessageHygieneSCLRejectThreshold                : 
msExchMobileAllowedDeviceIDs                          : {}
msExchMobileBlockedDeviceIDs                          : {}
msExchMobileDebugLogging                              : 
msExchMobileMailboxFlags                              : 
msExchMobileMailboxPolicyLink                         : 
msExchMobileRemoteDocumentsAllowedServersBL           : {}
msExchMobileRemoteDocumentsBlockedServersBL           : {}
msExchMobileRemoteDocumentsInternalDomainSuffixListBL : {}
msExchMobileSettings                                  : 
msExchModeratedByLink                                 : {}
msExchModeratedObjectsBL                              : {}
msExchModerationFlags                                 : 
msExchMultiMailboxDatabasesBL                         : {}
msExchMultiMailboxDatabasesLink                       : {}
msExchMultiMailboxGUIDs                               : {}
msExchMultiMailboxLocationsBL                         : {}
msExchMultiMailboxLocationsLink                       : {}
msExchOABGeneratingMailboxBL                          : {}
msExchObjectCountQuota                                : {}
msExchObjectID                                        : 
msExchOmaAdminExtendedSettings                        : {}
msExchOmaAdminWirelessEnable                          : 
msExchOnPremiseObjectGuid                             : 
msExchOrganizationsAddressBookRootsBL                 : {}
msExchOrganizationsGlobalAddressListsBL               : {}
msExchOrganizationsTemplateRootsBL                    : {}
msExchOrganizationUpgradeRequest                      : 
msExchOrganizationUpgradeStatus                       : 
msExchOriginatingForest                               : {}
msExchOURoot                                          : 
msExchOWAAllowedFileTypesBL                           : {}
msExchOWAAllowedMimeTypesBL                           : {}
msExchOWABlockedFileTypesBL                           : {}
msExchOWABlockedMIMETypesBL                           : {}
msExchOWAForceSaveFileTypesBL                         : {}
msExchOWAForceSaveMIMETypesBL                         : {}
msExchOWAPolicy                                       : CN=OwaMbxPol-SKODA,CN=OWA Mailbox Policies,CN=VWGMS,CN=Microsoft Exchange,CN=Services,CN=C
                                                        onfiguration,DC=vwg
msExchOWARemoteDocumentsAllowedServersBL              : {}
msExchOWARemoteDocumentsBlockedServersBL              : {}
msExchOWARemoteDocumentsInternalDomainSuffixListBL    : {}
msExchOWASettings                                     : 
msExchOWATranscodingFileTypesBL                       : {}
msExchOWATranscodingMimeTypesBL                       : {}
msExchParentPlanBL                                    : {}
msExchParentPlanLink                                  : 
msExchPartnerGroupID                                  : 
msExchPfRootUrl                                       : 
msExchPoliciesExcluded                                : {{26491cfc-9e50-4857-861b-0cb8df22b5d7}}
msExchPoliciesIncluded                                : {}
msExchPolicyEnabled                                   : 
msExchPolicyOptionList                                : {}
msExchPOP3Settings                                    : 
msExchPreviousAccountSid                              : 
msExchPreviousArchiveDatabase                         : 
msExchPreviousArchiveDatabaseSL                       : 
msExchPreviousHomeMDB                                 : 
msExchPreviousHomeMDBSL                               : 
msExchPreviousMailboxGuid                             : 
msExchPreviousRecipientTypeDetails                    : 
msExchProvisioningFlags                               : 
msExchProvisioningTags                                : {}
msExchProxyCustomProxy                                : {}
msExchPublicFolderMailbox                             : 
msExchPublicFolderSmtpAddress                         : 
msExchQueryBaseDN                                     : 
msExchRBACPolicyBL                                    : {}
msExchRBACPolicyLink                                  : 
msExchRecipientDisplayType                            : -1073741818
msExchRecipientSoftDeletedStatus                      : 
msExchRecipientTypeDetails                            : 2147483648
msExchRecipientValidatorCookies                       : {}
msExchRecipLimit                                      : 
msExchRemoteRecipientType                             : 4
msExchRequireAuthToSendTo                             : 
msExchResourceCapacity                                : 
msExchResourceDisplay                                 : 
msExchResourceGUID                                    : {}
msExchResourceMetaData                                : {}
msExchResourceProperties                              : {}
msExchResourceSearchProperties                        : {}
msExchRetentionComment                                : 
msExchRetentionURL                                    : 
msExchRMSComputerAccountsBL                           : {}
msExchRMSComputerAccountsLink                         : {}
msExchRoleGroupType                                   : 
msExchSafeRecipientsHash                              : 
msExchSafeSendersHash                                 : {88, 220, 56, 3...}
msExchSendAsAddresses                                 : {}
msExchSenderHintTranslations                          : {}
msExchServerAssociationBL                             : {}
msExchServerAssociationLink                           : 
msExchServerSiteBL                                    : {}
msExchSetupStatus                                     : 
msExchShadowAssistantName                             : 
msExchShadowC                                         : 
msExchShadowCo                                        : 
msExchShadowCompany                                   : 
msExchShadowCountryCode                               : 
msExchShadowDepartment                                : 
msExchShadowDisplayName                               : 
msExchShadowFacsimileTelephoneNumber                  : 
msExchShadowGivenName                                 : 
msExchShadowHomePhone                                 : 
msExchShadowInfo                                      : 
msExchShadowInitials                                  : 
msExchShadowL                                         : 
msExchShadowMailNickname                              : 
msExchShadowManagerLink                               : 
msExchShadowMobile                                    : 
msExchShadowOtherFacsimileTelephone                   : {}
msExchShadowOtherHomePhone                            : {}
msExchShadowOtherTelephone                            : {}
msExchShadowPager                                     : 
msExchShadowPhysicalDeliveryOfficeName                : 
msExchShadowPostalCode                                : 
msExchShadowProxyAddresses                            : {}
msExchShadowSn                                        : 
msExchShadowSt                                        : 
msExchShadowStreetAddress                             : 
msExchShadowTelephoneAssistant                        : 
msExchShadowTelephoneNumber                           : 
msExchShadowTitle                                     : 
msExchShadowWhenSoftDeletedTime                       : 
msExchShadowWindowsLiveID                             : 
msExchShadowWWWHomePage                               : 
msExchSharingAnonymousIdentities                      : {}
msExchSharingPartnerIdentities                        : {}
msExchSharingPolicyLink                               : 
msExchSignupAddresses                                 : {}
msExchSMTPReceiveDefaultAcceptedDomainBL              : {}
msExchStsRefreshTokensValidFrom                       : 
msExchSupervisionDLBL                                 : {}
msExchSupervisionDLLink                               : {}
msExchSupervisionOneOffBL                             : {}
msExchSupervisionOneOffLink                           : {}
msExchSupervisionUserBL                               : {}
msExchSupervisionUserLink                             : {}
msExchSyncAccountsPolicyDN                            : 
msExchTeamMailboxExpiration                           : 
msExchTeamMailboxOwners                               : {}
msExchTeamMailboxSharePointLinkedBy                   : 
msExchTeamMailboxSharePointUrl                        : 
msExchTeamMailboxShowInClientList                     : {}
msExchTenantCountry                                   : 
msExchTextMessagingState                              : {302120705, 16842751}
msExchThrottlingPolicyDN                              : 
msExchTransportInboundSettings                        : 
msExchTransportOutboundSettings                       : 
msExchTransportRecipientSettingsFlags                 : 
msExchTransportRuleTargetBL                           : {}
msExchTrustedDomainBL                                 : {}
msExchTUIPassword                                     : 
msExchTUISpeed                                        : 
msExchTUIVolume                                       : 
msExchUCVoiceMailSettings                             : {}
msExchUGEventSubscriptionBL                           : {}
msExchUGEventSubscriptionLink                         : {}
msExchUGMemberBL                                      : {}
msExchUGMemberLink                                    : {}
msExchUMAddresses                                     : {}
msExchUMAudioCodec                                    : 
msExchUMAudioCodec2                                   : 
msExchUMCallingLineIDs                                : {}
msExchUMDtmfMap                                       : {reversedPhone:200060577024+, emailAddress:3983454752725, lastNameFirstName:5272534547, fi
                                                        rstNameLastName:3454752725}
msExchUMEnabledFlags                                  : 
msExchUMEnabledFlags2                                 : 
msExchUMFaxId                                         : 
msExchUMListInDirectorySearch                         : 
msExchUMMailboxOVALanguage                            : 
msExchUMMaxGreetingDuration                           : 
msExchUMOperatorNumber                                : 
msExchUMPhoneProvider                                 : 
msExchUMPinChecksum                                   : 
msExchUMRecipientDialPlanLink                         : 
msExchUMServerWritableFlags                           : 
msExchUMSpokenName                                    : 
msExchUMTemplateLink                                  : 
msExchUnifiedMailbox                                  : 
msExchUnmergedAttsPt                                  : 
msExchUsageLocation                                   : CZ
msExchUseOAB                                          : 
msExchUserAccountControl                              : 0
msExchUserBL                                          : {}
msExchUserCulture                                     : 
msExchUserHoldPolicies                                : {}
msExchVersion                                         : 88218628259840
msExchVoiceMailboxID                                  : 
msExchWhenMailboxCreated                              : 12.05.2020 20:50:51
msExchWhenSoftDeletedTime                             : 
msExchWindowsLiveID                                   : 


#>

Function Get-ADUserAllProps {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline)] 
        [PsObject]$Object
    )
    Begin{
        $Out = [System.Collections.Generic.List[Object]]::new()

        Function Get-RelatedClass {
            param( [string]$ClassName )
 
            $Classes = @($ClassName)
 
            $SubClass = Get-ADObject -SearchBase "$((Get-ADRootDSE).SchemaNamingContext)" -Filter {lDAPDisplayName -eq $ClassName} -properties subClassOf |Select-Object -ExpandProperty subClassOf
            if( $Subclass -and $SubClass -ne $ClassName ) {
                $Classes += Get-RelatedClass $SubClass
            }
 
            $auxiliaryClasses = Get-ADObject -SearchBase "$((Get-ADRootDSE).SchemaNamingContext)" -Filter {lDAPDisplayName -eq $ClassName} -properties auxiliaryClass | Select-Object -ExpandProperty auxiliaryClass
            foreach( $auxiliaryClass in $auxiliaryClasses ) {
                $Classes += Get-RelatedClass $auxiliaryClass
            }

            $systemAuxiliaryClasses = Get-ADObject -SearchBase "$((Get-ADRootDSE).SchemaNamingContext)" -Filter {lDAPDisplayName -eq $ClassName} -properties systemAuxiliaryClass | Select-Object -ExpandProperty systemAuxiliaryClass
            foreach( $systemAuxiliaryClass in $systemAuxiliaryClasses ) {
                $Classes += Get-RelatedClass $systemAuxiliaryClass
            }
            Return $Classes 
        }

        $ADUser = $Object|select -First 1
        if($ADUser.SamAccountName){
            $ADUser = Get-ADUser -Identity $ADUser.SamAccountName -Properties objectClass
        }else{
            return $null
        }

        $AllClasses = ( Get-RelatedClass $ADUser.ObjectClass | sort -Unique )

        $AllAttributes = @()
        Foreach( $Class in $AllClasses ) {
            $attributeTypes = 'MayContain','MustContain','systemMayContain','systemMustContain'
            $ClassInfo = Get-ADObject -SearchBase "$((Get-ADRootDSE).SchemaNamingContext)" -Filter {lDAPDisplayName -eq $Class} -properties $attributeTypes
            ForEach ($attribute in $attributeTypes) {
                $AllAttributes += $ClassInfo.$attribute
            }
        }
        
        $AllAttributes = ( $AllAttributes | sort -Unique )

        $AttributesOfInterest = @()
        Foreach( $Attribute in $AllAttributes ) {
            $AttributeInfo = Get-ADObject -SearchBase "$((Get-ADRootDSE).SchemaNamingContext)" -Filter {lDAPDisplayName -eq $Attribute} -properties ldapDisplayName, attributeId, isSingleValued, attributeSyntax, systemOnly, linkId, isDeleted, rangeLower, rangeUpper
            $AttributesOfInterest += $AttributeInfo
        }
        
        $AttributesOfInterest = $AttributesOfInterest | sort ldapDisplayName -Unique
        $global:Props = ($AttributesOfInterest).ldapDisplayName 

    }
    Process{
        foreach($Obj in $Object){
            $ADUserTemp = [System.Collections.Generic.List[Object]]::new()
            $ADUserTemp = Get-ADUser -Identity $Obj.samaccountname -Properties * | select $global:Props
            if($ADUserTemp){
                $Out += $ADUserTemp
            }
        }
        
    }

    End{
        $Out
    }
}


