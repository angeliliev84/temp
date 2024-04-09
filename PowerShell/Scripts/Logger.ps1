function Write-Log {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)]
        [string]$Message,
        
        [Parameter(Mandatory=$true)]
        [string]$Path
    )
    
    $logMessage = "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss"): $Message"
    Add-Content -Path $Path -Value $logMessage
}