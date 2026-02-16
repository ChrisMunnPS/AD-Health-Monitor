# ============================================================================
# Event Log Diagnostic Script
# ============================================================================
# Use this to troubleshoot "SystemErrors24h" ERROR issues
# ============================================================================

param(
    [string]$ComputerName = "dc01.HomeLAN.internal"  # Change to your DC
)

Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host " Event Log Diagnostic for $ComputerName" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# Test 1: Ping
Write-Host "[Test 1] Testing connectivity..." -NoNewline
try {
    $ping = Test-Connection -ComputerName $ComputerName -Count 1 -Quiet -ErrorAction Stop
    if ($ping) {
        Write-Host " PASS" -ForegroundColor Green
    } else {
        Write-Host " FAIL - Cannot ping" -ForegroundColor Red
        exit
    }
} catch {
    Write-Host " ERROR - $($_.Exception.Message)" -ForegroundColor Red
    exit
}

# Test 2: WinRM
Write-Host "[Test 2] Testing WinRM..." -NoNewline
try {
    $winrm = Test-WSMan -ComputerName $ComputerName -ErrorAction Stop
    Write-Host " PASS" -ForegroundColor Green
} catch {
    Write-Host " FAIL" -ForegroundColor Red
    Write-Host "  Error: $($_.Exception.Message)" -ForegroundColor Yellow
    Write-Host "  Run 'Enable-PSRemoting -Force' on the target DC" -ForegroundColor Yellow
    exit
}

# Test 3: Event Log Service
Write-Host "[Test 3] Checking Event Log service..." -NoNewline
try {
    $eventLogService = Get-Service -ComputerName $ComputerName -Name EventLog -ErrorAction Stop
    if ($eventLogService.Status -eq "Running") {
        Write-Host " PASS (Running)" -ForegroundColor Green
    } else {
        Write-Host " FAIL (Status: $($eventLogService.Status))" -ForegroundColor Red
        Write-Host "  Start the service: Start-Service -Name EventLog" -ForegroundColor Yellow
    }
} catch {
    Write-Host " ERROR" -ForegroundColor Red
    Write-Host "  $($_.Exception.Message)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "─────────────────────────────────────────────────────────" -ForegroundColor Gray
Write-Host ""

# Test 4: Get-EventLog (Legacy Method)
Write-Host "[Test 4] Testing Get-EventLog (legacy)..." -ForegroundColor Yellow
Write-Host "  Retrieving last 10 system errors..." -NoNewline
try {
    $legacyErrors = Invoke-Command -ComputerName $ComputerName -ScriptBlock {
        Get-EventLog -LogName System -EntryType Error -Newest 10 -ErrorAction Stop |
        Select-Object TimeGenerated, EventID, Source
    } -ErrorAction Stop
    
    Write-Host " SUCCESS" -ForegroundColor Green
    Write-Host ""
    Write-Host "  Sample errors retrieved:" -ForegroundColor Green
    $legacyErrors | Format-Table TimeGenerated, EventID, Source -AutoSize | Out-String | ForEach-Object { Write-Host $_ -ForegroundColor Gray }
} catch {
    Write-Host " FAILED" -ForegroundColor Red
    Write-Host ""
    Write-Host "  Error: $($_.Exception.Message)" -ForegroundColor Yellow
    Write-Host ""
}

# Test 5: Get-EventLog with Date Filter (What the script uses)
Write-Host "[Test 5] Testing Get-EventLog with 24h filter (script method)..." -ForegroundColor Yellow
Write-Host "  Retrieving system errors from last 24 hours..." -NoNewline
try {
    $scriptMethodErrors = Invoke-Command -ComputerName $ComputerName -ScriptBlock {
        Get-EventLog -LogName System -After (Get-Date).AddHours(-24) -EntryType Error -ErrorAction Stop |
        Select-Object TimeGenerated, EventID, Source
    } -ErrorAction Stop
    
    Write-Host " SUCCESS" -ForegroundColor Green
    Write-Host "  Found $($scriptMethodErrors.Count) error(s) in last 24 hours" -ForegroundColor Green
    Write-Host ""
    
    if ($scriptMethodErrors.Count -gt 0) {
        Write-Host "  Most recent errors:" -ForegroundColor Green
        $scriptMethodErrors | Select-Object -First 5 | Format-Table TimeGenerated, EventID, Source -AutoSize | Out-String | ForEach-Object { Write-Host $_ -ForegroundColor Gray }
    }
} catch {
    Write-Host " FAILED" -ForegroundColor Red
    Write-Host ""
    Write-Host "  Error: $($_.Exception.Message)" -ForegroundColor Yellow
    Write-Host "  Error Type: $($_.Exception.GetType().FullName)" -ForegroundColor DarkYellow
    Write-Host ""
}

# Test 6: Get-WinEvent (Modern Method)
Write-Host "[Test 6] Testing Get-WinEvent (modern)..." -ForegroundColor Yellow
Write-Host "  Retrieving system errors from last 24 hours..." -NoNewline
try {
    $modernErrors = Invoke-Command -ComputerName $ComputerName -ScriptBlock {
        $startTime = (Get-Date).AddHours(-24)
        Get-WinEvent -FilterHashtable @{
            LogName = 'System'
            Level = 2  # Error
            StartTime = $startTime
        } -ErrorAction Stop |
        Select-Object TimeCreated, Id, ProviderName -First 10
    } -ErrorAction Stop
    
    Write-Host " SUCCESS" -ForegroundColor Green
    Write-Host "  Found $($modernErrors.Count) error(s) (showing first 10)" -ForegroundColor Green
    Write-Host ""
    Write-Host "  Sample errors retrieved:" -ForegroundColor Green
    $modernErrors | Format-Table TimeCreated, Id, ProviderName -AutoSize | Out-String | ForEach-Object { Write-Host $_ -ForegroundColor Gray }
} catch {
    Write-Host " FAILED" -ForegroundColor Red
    Write-Host ""
    Write-Host "  Error: $($_.Exception.Message)" -ForegroundColor Yellow
    Write-Host ""
}

# Test 7: Event Log Size and Stats
Write-Host "[Test 7] Checking event log statistics..." -ForegroundColor Yellow
try {
    $logInfo = Invoke-Command -ComputerName $ComputerName -ScriptBlock {
        $log = Get-EventLog -List | Where-Object { $_.Log -eq "System" }
        [PSCustomObject]@{
            LogName = $log.Log
            MaximumKB = $log.MaximumKilobytes
            OverflowAction = $log.OverflowAction
            MinimumRetentionDays = $log.MinimumRetentionDays
            EntryCount = $log.Entries.Count
        }
    } -ErrorAction Stop
    
    Write-Host "  Log: $($logInfo.LogName)" -ForegroundColor Green
    Write-Host "  Max Size: $($logInfo.MaximumKB) KB" -ForegroundColor Gray
    Write-Host "  Overflow Action: $($logInfo.OverflowAction)" -ForegroundColor Gray
    Write-Host "  Retention Days: $($logInfo.MinimumRetentionDays)" -ForegroundColor Gray
    Write-Host "  Total Entries: $($logInfo.EntryCount)" -ForegroundColor Gray
    Write-Host ""
    
    if ($logInfo.EntryCount -gt 100000) {
        Write-Host "  ⚠️  Large event log detected ($($logInfo.EntryCount) entries)" -ForegroundColor Yellow
        Write-Host "  This may cause performance issues with event log queries" -ForegroundColor Yellow
        Write-Host ""
    }
} catch {
    Write-Host "  ERROR: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
}

# Summary and Recommendations
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host " DIAGNOSTIC SUMMARY" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

$testsPassed = 0
$testsFailed = 0

Write-Host "Results:" -ForegroundColor White
Write-Host ""

# Determine which tests passed
if (Test-Connection -ComputerName $ComputerName -Count 1 -Quiet) {
    Write-Host "  ✓ Connectivity" -ForegroundColor Green
    $testsPassed++
} else {
    Write-Host "  ✗ Connectivity" -ForegroundColor Red
    $testsFailed++
}

try {
    Test-WSMan -ComputerName $ComputerName -ErrorAction Stop | Out-Null
    Write-Host "  ✓ WinRM" -ForegroundColor Green
    $testsPassed++
} catch {
    Write-Host "  ✗ WinRM" -ForegroundColor Red
    $testsFailed++
}

try {
    $svc = Get-Service -ComputerName $ComputerName -Name EventLog -ErrorAction Stop
    if ($svc.Status -eq "Running") {
        Write-Host "  ✓ Event Log Service" -ForegroundColor Green
        $testsPassed++
    } else {
        Write-Host "  ✗ Event Log Service (not running)" -ForegroundColor Red
        $testsFailed++
    }
} catch {
    Write-Host "  ✗ Event Log Service (error)" -ForegroundColor Red
    $testsFailed++
}

Write-Host ""

if ($testsFailed -eq 0) {
    Write-Host "✅ All basic connectivity tests passed" -ForegroundColor Green
    Write-Host ""
    Write-Host "If the monitoring script still shows ERROR for SystemErrors24h:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Possible issues:" -ForegroundColor White
    Write-Host "  1. Very large event log causing timeout" -ForegroundColor Gray
    Write-Host "  2. Temporary WinRM issue during script execution" -ForegroundColor Gray
    Write-Host "  3. Permissions issue (script running as different user)" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Solutions:" -ForegroundColor White
    Write-Host "  • Clear old event logs: wevtutil.exe cl System" -ForegroundColor Gray
    Write-Host "  • Increase event log max size if needed" -ForegroundColor Gray
    Write-Host "  • Run the updated monitoring script (uses Get-WinEvent with fallback)" -ForegroundColor Gray
    Write-Host "  • Ensure running as Domain Admin" -ForegroundColor Gray
} else {
    Write-Host "⚠️  Some tests failed" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Fix the failed tests above before running the monitoring script." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
