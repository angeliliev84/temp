using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AzRecoveryServiceApp.Services
{
    public class LoggingService
    {
        private readonly string _logFilePath;

        public LoggingService(string logFilePath)
        {
            _logFilePath = logFilePath;

            // Ensure the log file directory exists
            var logDirectory = Path.GetDirectoryName(_logFilePath);
            if (!Directory.Exists(logDirectory))
            {
                Directory.CreateDirectory(logDirectory ?? string.Empty);
            }
        }

        public async Task LogAsync(string message)
        {
            // Create log message with timestamp
            string logMessage = $"{DateTime.UtcNow:yyyy-MM-dd HH:mm:ss} [INFO] {message}\n";

            // Append the log message to the log file asynchronously
            await File.AppendAllTextAsync(_logFilePath, logMessage);
        }

        public void Log(string message)
        {
            // Create log message with timestamp
            string logMessage = $"{DateTime.UtcNow:yyyy-MM-dd HH:mm:ss} [INFO] {message}\n";

            // Append the log message to the log file
            File.AppendAllText(_logFilePath, logMessage);
        }
    }
}



