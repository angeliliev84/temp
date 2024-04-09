Describe "Setup-StorageLock Tests" {
    BeforeAll {
        . "$PSScriptRoot\Logger.ps1"
        . "$PSScriptRoot\Setup-StorageLock.ps1"

        $TestResourceGroupName = "TestResourceGroup"
        $TestStorageAccountName = "teststorageaccount"
        $TestLockName = "TestLock"
        $TestLogPath = Join-Path -Path $PSScriptRoot -ChildPath "setup-storagelock-test-log.txt"
    }

    It "Applies a CanNotDelete lock to the storage account if not already locked" {
        Mock Get-AzResourceLock { return $null } -Verifiable
        Mock New-AzResourceLock {} -Verifiable
        Mock Write-Log {}

        Setup-StorageLock -ResourceGroupName $TestResourceGroupName -StorageAccountName $TestStorageAccountName `
                           -LockName $TestLockName -LogPath $TestLogPath

        Should -Invoke Get-AzResourceLock -Times 1 -Exactly -Scope It
        Should -Invoke New-AzResourceLock -Times 1 -Exactly -Scope It
        Should -Invoke Write-Log -Times 1 -Exactly -Scope It
    }

    It "Does not apply a CanNotDelete lock if one already exists" {
        Mock Get-AzResourceLock { return @{ LockName = $TestLockName } } -Verifiable
        Mock Write-Log {}

        Setup-StorageLock -ResourceGroupName $TestResourceGroupName -StorageAccountName $TestStorageAccountName `
                           -LockName $TestLockName -LogPath $TestLogPath

        Should -Invoke Get-AzResourceLock -Times 1 -Exactly -Scope It
        Should -Not -Invoke New-AzResourceLock -Scope It
        Should -Invoke Write-Log -Times 1 -Exactly -Scope It
    }

    AfterEach {
        if (Test-Path $TestLogPath) {
            Remove-Item -Path $TestLogPath -Force
        }
    }
}
