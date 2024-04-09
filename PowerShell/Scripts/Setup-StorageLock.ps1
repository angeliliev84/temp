param (
    [string]$ResourceGroupName,
    [string]$StorageAccountName,
    [string]$LockName,
    [string]$LogPath
)

. .\Logger.ps1

try {
    $lock = Get-AzResourceLock -ResourceGroupName $ResourceGroupName -ResourceName $StorageAccountName -ResourceType "Microsoft.Storage/storageAccounts" -ErrorAction SilentlyContinue
    if (-not $lock) {
        New-AzResourceLock -LockName $LockName -LockLevel CanNotDelete -ResourceGroupName $ResourceGroupName -ResourceType "Microsoft.Storage/storageAccounts" -ResourceName $StorageAccountName -Force
        Write-Log -Message "Applied CanNotDelete lock to the Storage Account $StorageAccountName." -Path $LogPath
    } else {
        Write-Log -Message "Lock $LockName already exists on Storage Account $StorageAccountName." -Path $LogPath
    }
}
catch {
    Write-Log -Message "An error occurred while applying lock: $_" -Path $LogPath
    exit 1
}