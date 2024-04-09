# Requires Pester module to be installed
# Install-Module -Name Pester -Force -Scope CurrentUser

Describe "Write-Log Tests" {
    BeforeAll {
        . $PSScriptRoot\Logger.ps1
        $testPath = "$PSScriptRoot\test-log.txt"
    }

    It "Writes to the specified log file" {
        Write-Log -Message "Test log entry" -Path $testPath
        $content = Get-Content -Path $testPath -ErrorAction SilentlyContinue
        $content | Should -Match "Test log entry"
    }

    It "Creates a log file if it does not exist" {
        Remove-Item -Path $testPath -ErrorAction SilentlyContinue
        Write-Log -Message "Test log entry" -Path $testPath
        Test-Path $testPath | Should -Be $true
    }

    AfterAll {
        Remove-Item -Path $testPath -ErrorAction SilentlyContinue
    }
}
