Describe "Setup-StoragePermissions Tests" {
    BeforeAll {
        . "$PSScriptRoot\Logger.ps1"
        . "$PSScriptRoot\Setup-StoragePermissions.ps1"

        $TestStorageAccountName = "teststorageaccount"
        $TestGroupName = "testGroup"
        $TestRoleDefinitionName = "Contributor"
        $TestLogPath = Join-Path -Path $PSScriptRoot -ChildPath "setup-storagepermissions-test-log.txt"
    }

    It "Assigns role to group if not already assigned" {
        Mock Get-AzADGroup { return @{Id = "testGroupId"} }
        Mock Get-AzStorageAccount { return @{Id = "testStorageAccountId"} }
        Mock Get-AzRoleAssignment { return $null } # Simulate no existing role assignment
        Mock New-AzRoleAssignment {} -Verifiable
        Mock Write-Log {}

        Setup-StoragePermissions -StorageAccountName $TestStorageAccountName -GroupName $TestGroupName `
                                 -RoleDefinitionName $TestRoleDefinitionName -LogPath $TestLogPath

        Should -Invoke New-AzRoleAssignment -Times 1 -Exactly -Scope It
        Should -Invoke Write-Log -Times 1 -Exactly -Scope It
    }

    It "Does not assign role to group if already assigned" {
        Mock Get-AzADGroup { return @{Id = "testGroupId"} }
        Mock Get-AzStorageAccount { return @{Id = "testStorageAccountId"} }
        Mock Get-AzRoleAssignment { return @(@{Id = "existingRoleAssignmentId"}) } # Simulate existing role assignment
        Mock Write-Log {}

        Setup-StoragePermissions -StorageAccountName $TestStorageAccountName -GroupName $TestGroupName `
                                 -RoleDefinitionName $TestRoleDefinitionName -LogPath $TestLogPath

        Should -Not -Invoke New-AzRoleAssignment -Scope It
        Should -Invoke Write-Log -Times 1 -Exactly -Scope It
    }

    AfterEach {
        if (Test-Path $TestLogPath) {
            Remove-Item -Path $TestLogPath -Force
        }
    }
}