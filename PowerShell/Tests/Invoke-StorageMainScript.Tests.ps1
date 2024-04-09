Describe "Invoke-StorageMainScript Execution" {
    BeforeAll {
        Mock Connect-AzAccount {}
        Mock Get-AzConsumptionBudget { return $null }
        Mock New-AzConsumptionBudget {}
        Mock Get-AzResourceGroup { return $null }
        Mock New-AzResourceGroup {}
        Mock Get-AzStorageAccount { return $null }
        Mock New-AzStorageAccount {}
        Mock Get-AzResourceLock { return $null }
        Mock New-AzResourceLock {}
        Mock Update-AzStorageBlobServiceProperty {}
        Mock Enable-AzStorageBlobDeleteRetentionPolicy {}
        Mock Get-AzADGroup { return @{Id = "testGroupId"} }
        Mock Get-AzRoleAssignment { return $null }
        Mock New-AzRoleAssignment {}
        Mock Write-Log {}
    }

    It "Performs all setup tasks without error" {
        # Assuming Invoke-StorageMainScript.ps1 is adjusted to dot-source scripts that define these functions.
        . "$scriptPath\Invoke-StorageMainScript.ps1"

        # Verifying Azure login attempt
        Should -Invoke Connect-AzAccount -Times 1 -Exactly

        # Verifying resource group setup
        Should -Invoke Get-AzResourceGroup -Times 1 -Exactly
        Should -Invoke New-AzResourceGroup -Times 1 -Exactly

        # Verifying storage account setup
        Should -Invoke Get-AzStorageAccount -Times 1 -Exactly
        Should -Invoke New-AzStorageAccount -Times 1 -Exactly

        # Verifying storage lock setup
        Should -Invoke Get-AzResourceLock -Times 1 -Exactly
        Should -Invoke New-AzResourceLock -Times 1 -Exactly

        # Verifying blob storage configuration
        Should -Invoke Update-AzStorageBlobServiceProperty -Times 1 -Exactly
        Should -Invoke Enable-AzStorageBlobDeleteRetentionPolicy -Times 1 -Exactly

        # Verifying storage permissions setup
        Should -Invoke Get-AzADGroup -Times 1 -Exactly
        Should -Invoke Get-AzRoleAssignment -Times 1 -Exactly
        Should -Invoke New-AzRoleAssignment -Times 1 -Exactly

        # Verifying budget setup
        Should -Invoke Get-AzConsumptionBudget -Times 1 -Exactly
        Should -Invoke New-AzConsumptionBudget -Times 1 -Exactly

        # Verifying logging
        Should -Invoke Write-Log -AtLeast -Times 1
    }

}
