Azure Recovery Services Application Documentation


I. Overview

Simple C# console app which uses Azure Recovery Services vault. 
I tried researchign a lot and may be went in too complicated way..

But wanted to show at least my thought process, certain design principles - single responsibility principle, separation of concern etc.

II.Models

AzureConfigModel.cs
It connects to appsettings.json, using Azure subscription info, resource group names, and more into one package.
It keeps configs  in a model which simplifies accessing these settings throughout the app and gives us a single point of truth for configuration stuff.

III.Services

ResourceManagementService.cs
This service is related to Azure resource management. It ensures resource groups and Recovery Services vaults are set up and ready to be used.
By breaking out resource management into its service, we stick to the Single Responsibility Principle, keeping things separate.

BackupManagementService.cs
Here's where the backup should happen. It's responsible for making sure Recovery Services vaults are properly configured for backups, managing policies, schedules, and the works. There are some limitations in this regard from Azure .NET SDK so external scripts/cli can be leveraged.
Backup management is specific, so having its dedicated service keeps our architecture clean and makes this functionality easily reusable.

LoggingService.cs
Logging of application events, errors, and operational insights. Whether it's to console, file, or cloud, this service takes care of that( of course can be greatly improved)
It is goo to have a separate logging service which we can use when needed without touching the business logic with logging code.


IV. Root folder

Here we have the Program.cs and App.cs

Program.cs
Starts of the app, It sets up services, dependency injection etc.
The program entry point that orchestrates the initial setup and configuration of the app.

App.cs
 It uses the services to manage Azure resources for backups, keeping the main logic centralized and manageable.
This approach allows  to maintain a modular structure, makink the app easier to manage and extend.

There were challenges , may be I could have put everythign in one simple C# Program.cs and do it.
But I'd review such code I'd have my own opinion so I decided to instead( even if it made stuff more challenging) to focus on design and show my thought process.