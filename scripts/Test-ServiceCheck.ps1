# ============================================================================
# Service Check Diagnostic Script
# ============================================================================
# This script replicates the exact service check logic from the main script
# Use this to diagnose why services might be reported incorrectly
# ============================================================================

# CONFIGURE YOUR DC NAME HERE
$dc = "dc01.HomeLAN.internal"  # Change to your actual DC hostname

# Services to check (same as main script)
$criticalServices = @(
    "NTDS",
    "DNS",
    "Kdc",
    "Netlogon",
    "DFSR",
    "W32Time"
)

Write-Host "============================================" -ForegroundColor Cyan
Write-Host " Service Check Diagnostic" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Target DC: $dc" -ForegroundColor Yellow
Write-Host ""

# Test 1: Check connectivity
Write-Host "[Test 1] Testing connectivity..." -NoNewline
try {
    $ping = Test-Connection -ComputerName $dc -Count 1 -Quiet -ErrorAction Stop
    if ($ping) {
        Write-Host " PASS" -ForegroundColor Green
    } else {
        Write-Host " FAIL - Cannot ping DC" -ForegroundColor Red
        exit
    }
} catch {
    Write-Host " ERROR - $($_.Exception.Message)" -ForegroundColor Red
    exit
}

# Test 2: Check WinRM
Write-Host "[Test 2] Testing WinRM..." -NoNewline
try {
    $winrm = Test-WSMan -ComputerName $dc -ErrorAction Stop
    Write-Host " PASS" -ForegroundColor Green
} catch {
    Write-Host " FAIL - WinRM not accessible" -ForegroundColor Red
    Write-Host "  Error: $($_.Exception.Message)" -ForegroundColor Yellow
    Write-Host "  Run 'Enable-PSRemoting -Force' on the DC" -ForegroundColor Yellow
    exit
}

# Test 3: Run the actual service check (same code as main script)
Write-Host "[Test 3] Checking services (exact script logic)..." -ForegroundColor Cyan
Write-Host ""

try {
    $services = Invoke-Command -ComputerName $dc -ScriptBlock {
        param($serviceList)
        $results = @()
        foreach ($svcName in $serviceList) {
            try {
                $svc = Get-Service -Name $svcName -ErrorAction Stop
                $results += [PSCustomObject]@{
                    Name = $svc.Name
                    DisplayName = $svc.DisplayName
                    Status = $svc.Status.ToString()  # Convert enum to string
                    StartType = $svc.StartType.ToString()  # Convert enum to string
                }
            } catch {
                # Service doesn't exist
                $results += [PSCustomObject]@{
                    Name = $svcName
                    DisplayName = "Not Found"
                    Status = "NotInstalled"
                    StartType = "Unknown"
                }
            }
        }
        return $results
    } -ArgumentList (,$criticalServices) -ErrorAction Stop
    
    Write-Host "Services retrieved: $($services.Count)" -ForegroundColor Gray
    Write-Host ""
    
    # Display all services
    Write-Host "Service Status:" -ForegroundColor White
    Write-Host "---------------" -ForegroundColor White
    foreach ($svc in $services) {
        $color = switch ($svc.Status) {
            "Running" { "Green" }
            "Stopped" { "Red" }
            "NotInstalled" { "Yellow" }
            default { "Gray" }
        }
        Write-Host "  $($svc.Name.PadRight(15)) Status: $($svc.Status.PadRight(15)) StartType: $($svc.StartType)" -ForegroundColor $color
    }
    
    Write-Host ""
    Write-Host "Analysis:" -ForegroundColor White
    Write-Host "---------" -ForegroundColor White
    
    # Count stopped and not installed (same logic as main script)
    $stoppedServices = $services | Where-Object { $_.Status -ne "Running" -and $_.Status -ne "NotInstalled" }
    $notInstalledServices = $services | Where-Object { $_.Status -eq "NotInstalled" }
    $runningServices = $services | Where-Object { $_.Status -eq "Running" }
    
    Write-Host "  Running:       $($runningServices.Count)" -ForegroundColor Green
    Write-Host "  Stopped:       $($stoppedServices.Count)" -ForegroundColor $(if ($stoppedServices.Count -gt 0) { "Red" } else { "Gray" })
    Write-Host "  Not Installed: $($notInstalledServices.Count)" -ForegroundColor $(if ($notInstalledServices.Count -gt 0) { "Yellow" } else { "Gray" })
    Write-Host ""
    
    # Determine status (same logic as main script)
    if ($stoppedServices.Count -gt 0) {
        $serviceStatus = "FAIL"
        $statusColor = "Red"
    } elseif ($notInstalledServices.Count -gt 0) {
        $serviceStatus = "WARN"
        $statusColor = "Yellow"
    } else {
        $serviceStatus = "PASS"
        $statusColor = "Green"
    }
    
    Write-Host "Final Status: $serviceStatus" -ForegroundColor $statusColor
    Write-Host ""
    
    # Show details if not PASS
    if ($serviceStatus -eq "FAIL") {
        Write-Host "Stopped Services:" -ForegroundColor Red
        foreach ($svc in $stoppedServices) {
            Write-Host "  - $($svc.Name): $($svc.Status) (StartType: $($svc.StartType))" -ForegroundColor Red
        }
    }
    
    if ($notInstalledServices.Count -gt 0) {
        Write-Host "Services Not Installed:" -ForegroundColor Yellow
        foreach ($svc in $notInstalledServices) {
            Write-Host "  - $($svc.Name)" -ForegroundColor Yellow
        }
    }
    
    if ($serviceStatus -eq "PASS") {
        Write-Host "✅ All services are running correctly!" -ForegroundColor Green
    }
    
} catch {
    Write-Host "ERROR during service check:" -ForegroundColor Red
    Write-Host "  $($_.Exception.Message)" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Full Error:" -ForegroundColor Gray
    Write-Host $_.Exception -ForegroundColor Gray
}

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host " Diagnostic Complete" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "If this shows PASS but the main script shows FAIL," -ForegroundColor Yellow
Write-Host "please share both outputs for further investigation." -ForegroundColor Yellow
