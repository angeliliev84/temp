using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AzRecoveryServiceApp.Models
{
    public class AzureConfigModel
    {
        // Azure AD Settings
        public string ClientId { get; set; }
        public string ClientSecret { get; set; }
        public string TenantId { get; set; }
        public string SubscriptionId { get; set; }

        // Resource Settings
        public string GroupName { get; set; }
        public string VaultName { get; set; }
        public string StorageAccountId { get; set; }
        public string Location { get; set; }
    }
}

