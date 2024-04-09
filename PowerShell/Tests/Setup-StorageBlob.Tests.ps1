Describe "Setup-StorageBlob Tests" {
    BeforeAll {
        . "$PSScriptRoot\Logger.ps1"
        . "$PSScriptRoot\Setup-StorageBlob.ps1"

        $TestResourceGroupName = "TestResourceGroup"
        $TestStorageAccountName = "teststorageaccount"
        $TestSoftDeleteRetentionDays = 7
        $TestLogPath = Join-Path -Path $PSScriptRoot -ChildPath "setup-storageblob-test-log.txt"
    }

    It "Enables blob versioning and sets soft delete retention policy" {
        Mock Update-AzStorageBlobServiceProperty {} -Verifiable
        Mock Enable-AzStorageBlobDeleteRetentionPolicy {} -Verifiable
        Mock Write-Log {}

        Setup-StorageBlob -ResourceGroupName $TestResourceGroupName -StorageAccountName $TestStorageAccountName `
                           -SoftDeleteRetentionDays $TestSoftDeleteRetentionDays -LogPath $TestLogPath
        
        Should -Invoke Update-AzStorageBlobServiceProperty -Times 1 -Exactly -Scope It
        Should -Invoke Enable-AzStorageBlobDeleteRetentionPolicy -Times 1 -Exactly -Scope It
        Should -Invoke Write-Log -Times 1 -Exactly -Scope It
    }

    AfterEach {
        if (Test-Path $TestLogPath) {
            Remove-Item -Path $TestLogPath -Force
        }
    }
}
