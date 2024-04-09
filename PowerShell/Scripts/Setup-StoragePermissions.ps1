param (
    [string]$StorageAccountName,
    [string]$GroupName,
    [string]$RoleDefinitionName,
    [string]$LogPath
)

. .\Logger.ps1

try {
    $group = Get-AzADGroup -DisplayName $GroupName
    if (-not $group) {
        Write-Log -Message "Azure AD group $GroupName not found." -Path $LogPath
    } else {
        $storageAccount = Get-AzStorageAccount -Name $StorageAccountName
        $storageAccountId = $storageAccount.Id
        $groupObjectId = $group.Id

        # Attempt to retrieve an existing role assignment for the group on the storage account.
        $roleAssignments = Get-AzRoleAssignment -Scope $storageAccountId -ObjectId $groupObjectId -RoleDefinitionName $RoleDefinitionName  -ErrorAction SilentlyContinue
        if (-not $roleAssignments) {
            # No existing role assignment found, proceed to create a new one.
            New-AzRoleAssignment -ObjectId $groupObjectId -Scope $storageAccountId -RoleDefinitionName $RoleDefinitionName
            Write-Log -Message "Assigned $RoleDefinitionName role to group $GroupName on $StorageAccountName." -Path $LogPath
        } else {
            Write-Log -Message "Role $RoleDefinitionName already assigned to group $GroupName on $StorageAccountName." -Path $LogPath
        }
    }
}
catch {
    Write-Log -Message "An error occurred while assigning blob permissions: $_" -Path $LogPath
    exit 1
}