param (
    [string]$ResourceGroupName,
    [string]$StorageAccountName,
    [string]$Location,
    [hashtable]$Tags,
    [string]$LogPath
)

. .\Logger.ps1

try {
    $storageAccount = Get-AzStorageAccount -ResourceGroupName $ResourceGroupName -Name $StorageAccountName -ErrorAction SilentlyContinue
    if (-not $storageAccount) {
        New-AzStorageAccount -ResourceGroupName $ResourceGroupName -Name $StorageAccountName `
                             -Location $Location -SkuName "Standard_LRS" -Kind "StorageV2" -EnableHttpsTrafficOnly $true `
                             -Tag $Tags
        Write-Log -Message "Storage Account $StorageAccountName created with HTTPS required." -Path $LogPath
    } else {
        Write-Log -Message "Storage Account $StorageAccountName already exists." -Path $LogPath
    }
}
catch {
    Write-Log -Message "An error occurred: $_" -Path $LogPath
    exit 1
}