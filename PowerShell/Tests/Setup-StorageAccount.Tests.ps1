Describe "Setup-StorageAccount Tests" {
    BeforeAll {
        . "$PSScriptRoot\Logger.ps1"
        . "$PSScriptRoot\Setup-StorageAccount.ps1"

        $TestResourceGroupName = "TestResourceGroup"
        $TestStorageAccountName = "teststorageaccount"
        $TestLocation = "West Europe"
        $TestTags = @{
            "Environment" = "Test"
        }
        $TestLogPath = Join-Path -Path $PSScriptRoot -ChildPath "setup-storageaccount-test-log.txt"
    }

    It "Creates a new storage account if it does not exist" {
        Mock Get-AzStorageAccount { return $null } -Verifiable
        Mock New-AzStorageAccount {} -Verifiable
        Mock Write-Log {}

        Setup-StorageAccount -ResourceGroupName $TestResourceGroupName -StorageAccountName $TestStorageAccountName `
                             -Location $TestLocation -Tags $TestTags -LogPath $TestLogPath
        
        Should -Invoke Get-AzStorageAccount -Times 1 -Exactly -Scope It
        Should -Invoke New-AzStorageAccount -Times 1 -Exactly -Scope It
        Should -Invoke Write-Log -Times 1 -Exactly -Scope It
    }

    It "Does not create a storage account if it already exists" {
        Mock Get-AzStorageAccount { return @{ Name = $TestStorageAccountName } } -Verifiable
        Mock Write-Log {}

        Setup-StorageAccount -ResourceGroupName $TestResourceGroupName -StorageAccountName $TestStorageAccountName `
                             -Location $TestLocation -Tags $TestTags -LogPath $TestLogPath
        
        Should -Invoke Get-AzStorageAccount -Times 1 -Exactly -Scope It
        Should -Not -Invoke New-AzStorageAccount -Scope It
        Should -Invoke Write-Log -Times 1 -Exactly -Scope It
    }

    AfterEach {
        if (Test-Path $TestLogPath) {
            Remove-Item -Path $TestLogPath -Force
        }
    }
}
