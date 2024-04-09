param (
    [string]$ResourceGroupName,
    [string]$Location,
    [string]$LogPath
)

. .\Logger.ps1

try {
    $resourceGroup = Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue
    if (-not $resourceGroup) {
        New-AzResourceGroup -Name $ResourceGroupName -Location $Location
        Write-Log -Message "Resource group $ResourceGroupName created." -Path $LogPath
    } else {
        Write-Log -Message "Resource group $ResourceGroupName already exists." -Path $LogPath
    }
}
catch {
    Write-Log -Message "An error occurred: $_" -Path $LogPath
    exit 1
}
