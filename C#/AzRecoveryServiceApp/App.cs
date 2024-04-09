using AzRecoveryServiceApp.Models;
using AzRecoveryServiceApp.Services;
using Microsoft.Extensions.Options;
using System;
using System.Threading.Tasks;

namespace AzRecoveryServiceApp
{
    public class App
    {
        private readonly AzureConfigModel _azureConfig;
        private readonly ResourceManagementService _resourceManagementService;
        private readonly BackupManagementService _backupManagementService;

        public App(IOptions<AzureConfigModel> azureConfig,
                   ResourceManagementService resourceManagementService,
                   BackupManagementService backupManagementService)
        {
            _azureConfig = azureConfig.Value;
            _resourceManagementService = resourceManagementService;
            _backupManagementService = backupManagementService;
        }

        public async Task RunAsync()
        {
            try
            {
                // Ensure the Resource Group exists
                Console.WriteLine($"Ensuring Resource Group: {_azureConfig.GroupName}");
                await _resourceManagementService.EnsureResourceGroupAsync(_azureConfig.GroupName, _azureConfig.Location);

                // Create or get existing Recovery Services Vault
                Console.WriteLine($"Ensuring Recovery Services Vault: {_azureConfig.VaultName}");
                var vault = await _backupManagementService.EnsureRecoveryServicesVaultAsync(_azureConfig.GroupName, _azureConfig.VaultName, _azureConfig.Location);
                Console.WriteLine($"Vault ensured: {vault.Data.Name}");

                // Placeholder for further operations, like enabling backup
                // Depending on the capabilities of BackupManagementService,
                //  a method can be called here to setup backup policies or enable backup for certain resources.
                // There are some limitations of Azure SDK so could be done via Az cli or external Powershell

                Console.WriteLine("Operation completed successfully.");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"An error occurred: {ex.Message}");
            }
        }
    }
}
