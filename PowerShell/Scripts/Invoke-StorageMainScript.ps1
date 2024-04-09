# Vars
$scriptPath = "C:\temp\scripts\Buhler-task"
$ResourceGroupName = "rgangeltest"
$StorageAccountName = "saangeltest4321"
$Location = "westeurope"
$AlertReceiver = "angeliliev84@gmail.com"
$GroupName = "StorageBlobMgmt"
$BudgetAmount = 100
$BudgetThreshold = 80
$RoleDefinitionName = "Storage Blob Data Contributor"
$LogPath = "$scriptPath\log.txt"
$LockName = "NoDeleteLock"
$SoftDeleteRetentionDays = 7

# tags
$Tags = @{
    ResourceOwner = "Angel ILIEV"
    ResourceOwnerType = "infrastructure"
    ResourceDescription = "Blob Storage Backup"
    Environment = "dev"
}

# Import Logger Function
. "$scriptPath\Logger.ps1"

# Login to Azure

try { 
     Connect-AzAccount

}
catch {
    Write-Log -Message "An error occurred while logging to Azure: $_" -Path $LogPath
}



# Resource Group Setup
. "$scriptPath\Setup-ResourceGroup.ps1" -ResourceGroupName $ResourceGroupName -Location $Location -LogPath $LogPath


. "$scriptPath\Setup-StorageAccount.ps1" -ResourceGroupName $ResourceGroupName -StorageAccountName $StorageAccountName -Location $Location -Tags $Tags -LogPath $LogPath

# Apply Lock to Storage Account
. "$scriptPath\Setup-StorageLock.ps1" -ResourceGroupName $ResourceGroupName -StorageAccountName $StorageAccountName -LockName $LockName -LogPath $LogPath

# Configure Blob Storage
. "$scriptPath\Setup-StorageBlob.ps1" -ResourceGroupName $ResourceGroupName -StorageAccountName $StorageAccountName -SoftDeleteRetentionDays $SoftDeleteRetentionDays -LogPath $LogPath

# Assign Blob Permissions to AD Group
. "$scriptPath\Setup-StoragePermissions.ps1" -StorageAccountName $StorageAccountName -GroupName $GroupName -RoleDefinitionName $RoleDefinitionName -LogPath $LogPath

# Setup Budget for Resource Group
. "$scriptPath\Setup-StorageBudget.ps1" -ResourceGroupName $ResourceGroupName -BudgetAmount $BudgetAmount -BudgetThreshold $BudgetThreshold -AlertReceiver $AlertReceiver -LogPath $LogPath

Write-Log -Message "All setup tasks completed successfully." -Path $LogPath
