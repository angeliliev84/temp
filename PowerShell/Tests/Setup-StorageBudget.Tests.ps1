Describe "Setup-StorageBudget Tests" {
    BeforeAll {
        . "$PSScriptRoot\Logger.ps1"
        . "$PSScriptRoot\Setup-StorageBudget.ps1"

        $TestResourceGroupName = "TestResourceGroup"
        $TestBudgetAmount = 100.00
        $TestBudgetThreshold = 80
        $TestAlertReceiver = "alert@example.com"
        $TestLogPath = Join-Path -Path $PSScriptRoot -ChildPath "setup-storagebudget-test-log.txt"
    }

    It "Creates a new budget if it does not exist" {
        Mock Get-AzConsumptionBudget { return $null } -Verifiable
        Mock New-AzConsumptionBudget {} -Verifiable
        Mock Write-Log {}

        Setup-StorageBudget -ResourceGroupName $TestResourceGroupName -BudgetAmount $TestBudgetAmount `
                             -BudgetThreshold $TestBudgetThreshold -AlertReceiver $TestAlertReceiver -LogPath $TestLogPath

        Should -Invoke Get-AzConsumptionBudget -Times 1 -Exactly -Scope It
        Should -Invoke New-AzConsumptionBudget -Times 1 -Exactly -Scope It
        Should -Invoke Write-Log -Times 1 -Exactly -Scope It
    }

    It "Does not create a new budget if it already exists" {
        Mock Get-AzConsumptionBudget { return @{ Name = "BlobStorageBudget" } } -Verifiable
        Mock Write-Log {}

        Setup-StorageBudget -ResourceGroupName $TestResourceGroupName -BudgetAmount $TestBudgetAmount `
                             -BudgetThreshold $TestBudgetThreshold -AlertReceiver $TestAlertReceiver -LogPath $TestLogPath

        Should -Invoke Get-AzConsumptionBudget -Times 1 -Exactly -Scope It
        Should -Not -Invoke New-AzConsumptionBudget -Scope It
        Should -Invoke Write-Log -Times 1 -Exactly -Scope It
    }

    AfterEach {
        if (Test-Path $TestLogPath) {
            Remove-Item -Path $TestLogPath -Force
        }
    }
}
