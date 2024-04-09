Describe "Setup-ResourceGroup Tests" {
    BeforeAll {
        # Ensure Logger.ps1 and Setup-ResourceGroup.ps1 are dot-sourced correctly
        . "$PSScriptRoot\Logger.ps1"
        . "$PSScriptRoot\Setup-ResourceGroup.ps1"
        
        # Explicitly define and initialize $LogPath for the test environment
        $TestLogPath = Join-Path -Path $PSScriptRoot -ChildPath "setup-resourcegroup-test-log.txt"
    }

    It "Creates a new resource group if it does not exist" {
        Mock Get-AzResourceGroup { return $null }
        Mock New-AzResourceGroup { }
        Mock Write-Log { }
        
        # Ensure $TestLogPath is passed as an argument
        Setup-ResourceGroup -ResourceGroupName "TestResourceGroup" -Location "West Europe" -LogPath $TestLogPath
        
        # Verification logic remains the same
    }

    # Include additional tests and logic as needed...

    AfterAll {
        # Clean up the test log file, if it exists
        if (Test-Path $TestLogPath) {
            Remove-Item -Path $TestLogPath -Force
        }
    }
}