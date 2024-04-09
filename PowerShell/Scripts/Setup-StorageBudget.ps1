param (
    [string]$ResourceGroupName,
    [float]$BudgetAmount,
    [int]$BudgetThreshold, 
    [string]$AlertReceiver, 
    [string]$LogPath
)

. .\Logger.ps1

try {
    $budgetName = "BlobStorageBudget"
    $notificationKey = "BudgetNotification"
    $startDate = (Get-Date).AddMonths(-1).ToString("yyyy-MM-01")
    $endDate = (Get-Date).AddYears(1).ToString("yyyy-MM-01")
    $contactEmails = @($AlertReceiver)

    # Check if a budget already exists
    $existingBudget = Get-AzConsumptionBudget -ResourceGroupName $ResourceGroupName -Name $budgetName -ErrorAction SilentlyContinue
    if (-not $existingBudget) {
        New-AzConsumptionBudget -ResourceGroupName $ResourceGroupName -Name $budgetName -Amount $BudgetAmount -Category Cost -TimeGrain Monthly `
                                -StartDate $startDate -EndDate $endDate `
                                -NotificationKey $notificationKey -NotificationEnabled `
                                -NotificationThreshold $BudgetThreshold -ContactEmail $contactEmails

        Write-Log -Message "Budget for $ResourceGroupName created with a threshold of $BudgetThreshold%." -Path $LogPath
    } else {
        Write-Log -Message "Budget for $ResourceGroupName already exists." -Path $LogPath
    }
}
catch {
    Write-Log -Message "An error occurred while setting up the budget: $_" -Path $LogPath
    exit 1
}