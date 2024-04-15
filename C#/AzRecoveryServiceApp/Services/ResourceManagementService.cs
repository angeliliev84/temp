using Azure.Identity;
using Azure.ResourceManager;
using Azure.ResourceManager.RecoveryServices;
using AzRecoveryServiceApp.Models;
using Microsoft.Extensions.Options;
using System;
using System.Threading.Tasks;
using Azure.Core;
using Azure.ResourceManager.Resources;
using Azure;

public class ResourceManagementService
{
    private readonly AzureConfigModel _azureConfig;
    private readonly ArmClient _armClient;

    public ResourceManagementService(IOptions<AzureConfigModel> azureConfigOptions)
    {
        _azureConfig = azureConfigOptions.Value;
        _armClient = new ArmClient(new DefaultAzureCredential(), _azureConfig.SubscriptionId);
    }

    public async Task<ResourceGroupResource> EnsureResourceGroupAsync(string resourceGroupName, string location)
    {
        Console.WriteLine($"Ensuring Resource Group: {resourceGroupName} in {location}");

        // Obtain the default subscription to create the resource group in.
        SubscriptionResource subscription = await _armClient.GetDefaultSubscriptionAsync();
        var resourceGroupData = new ResourceGroupData(location);

        // Check if the resource group already exists
        Response<ResourceGroupResource> resourceGroupResponse = await subscription.GetResourceGroups().CreateOrUpdateAsync(WaitUntil.Completed, resourceGroupName, resourceGroupData);
        Console.WriteLine($"Resource Group ensured: {resourceGroupResponse.Value.Data.Name}");
        return resourceGroupResponse.Value;
    }

    public async Task<RecoveryServicesVaultResource> EnsureRecoveryServicesVaultAsync(string resourceGroupName, string vaultName, string location)
    {
        Console.WriteLine($"Ensuring Recovery Services Vault: {vaultName} in {location}");

        // Get the resource group where the vault will be created.
        var resourceGroup = await _armClient.GetResourceGroup(new ResourceIdentifier($"/subscriptions/{_azureConfig.SubscriptionId}/resourceGroups/{resourceGroupName}"));

        // Prepare the data for the Recovery Services vault.
        var vaultData = new RecoveryServicesVaultData(location);

        // Check if the vault already exists.
        RecoveryServicesVaultResource vault = await resourceGroup.GetRecoveryServicesVaults().GetIfExistsAsync(vaultName);

        if (vault == null)
        {
            // Create the vault if it doesn't exist.
            Console.WriteLine($"Creating Recovery Services Vault: {vaultName}");
            vault = await resourceGroup.GetRecoveryServicesVaults().CreateOrUpdate(WaitUntil.Completed, vaultName, vaultData).ConfigureAwait(false);
            Console.WriteLine($"Recovery Services Vault created: {vault.Data.Name}");
        }
        else
        {
            Console.WriteLine($"Recovery Services Vault already exists: {vault.Data.Name}");
        }

        return vault;
    }
}
