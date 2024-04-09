param (
    [string]$ResourceGroupName,
    [string]$StorageAccountName,
    [int]$SoftDeleteRetentionDays,
    [string]$LogPath
)

. .\Logger.ps1

try {
    Update-AzStorageBlobServiceProperty -ResourceGroupName $ResourceGroupName -AccountName $StorageAccountName -IsVersioningEnabled $true
    Enable-AzStorageBlobDeleteRetentionPolicy -ResourceGroupName $ResourceGroupName -AccountName $StorageAccountName -RetentionDays $SoftDeleteRetentionDays

    Write-Log -Message "Blob versioning and soft delete have been enabled for $StorageAccountName with a soft delete retention of $SoftDeleteRetentionDays days." -Path $LogPath
}
catch {
    Write-Log -Message "An error occurred while configuring blob storage: $_" -Path $LogPath
    exit 1
}