using AzRecoveryServiceApp;
using AzRecoveryServiceApp.Models;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.Extensions.Options;

class Program
{
    static async Task Main(string[] args)
    {
        var serviceCollection = new ServiceCollection();
        ConfigureServices(serviceCollection);

        var serviceProvider = serviceCollection.BuildServiceProvider();

        // Resolve the App service using the configured ServiceProvider
        var app = serviceProvider.GetService<App>();
        if (app == null) throw new InvalidOperationException("App service could not be resolved.");

        await app.RunAsync();
    }

    private static void ConfigureServices(IServiceCollection services)
    {
        // Build configuration
        IConfiguration configuration = new ConfigurationBuilder()
            .SetBasePath(Directory.GetCurrentDirectory())
            .AddJsonFile("appsettings.json", false, true)
            .Build();

        // Bind and configure AzureConfigModel
        services.Configure<AzureConfigModel>(configuration.GetSection("AzureAd"));
        services.Configure<AzureConfigModel>(configuration.GetSection("Resource"));

        // Add services to the DI container
        services.AddSingleton<IConfiguration>(configuration);
        services.AddTransient<App>();

        // Example of how to inject the AzureConfigModel into the App service
        // This demonstrates the injection of configurations into your services
        services.AddTransient(provider =>
        {
            var azureConfig = provider.GetRequiredService<IOptions<AzureConfigModel>>().Value;
            return new App(azureConfig);
        });
    }
}
