# ============================================================================
# Kerberos Delegation Investigation Script (Fixed DC Detection)
# ============================================================================

Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host " Kerberos Delegation Investigation" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# Get domain controllers with multiple name formats
Write-Host "Step 1: Identifying Domain Controllers..." -ForegroundColor Yellow
$allDCObjects = Get-ADDomainController -Filter *
$allDCNames = @()
foreach ($dcObj in $allDCObjects) {
    $allDCNames += $dcObj.Name.ToLower()
    $allDCNames += $dcObj.HostName.ToLower()
    $allDCNames += ($dcObj.HostName -split '\.')[0].ToLower()
}

Write-Host "  Found $($allDCObjects.Count) Domain Controller(s):" -ForegroundColor Green
foreach ($dcObj in $allDCObjects) {
    Write-Host "    - $($dcObj.HostName)" -ForegroundColor Gray
}
Write-Host ""

# Find all accounts with delegation
Write-Host "Step 2: Finding Accounts with Kerberos Delegation..." -ForegroundColor Yellow
$delegationAccounts = Get-ADObject -Filter {(UserAccountControl -band 0x80000) -or (UserAccountControl -band 0x1000000)} `
    -Properties Name, ObjectClass, UserAccountControl, servicePrincipalName, 'msDS-AllowedToDelegateTo'

if (-not $delegationAccounts) {
    Write-Host "  ✓ No delegation found in the domain" -ForegroundColor Green
    Write-Host ""
    Write-Host "This is unusual but could indicate a very restrictive environment." -ForegroundColor Yellow
    exit
}

Write-Host "  Found $($delegationAccounts.Count) account(s) with delegation" -ForegroundColor Green
Write-Host ""

# Categorize accounts
$dcAccounts = @()
$serviceAccounts = @()
$userAccounts = @()

foreach ($acct in $delegationAccounts) {
    $isDC = $allDCNames -contains $acct.Name.ToLower()
    
    if ($isDC) {
        $dcAccounts += $acct
    } elseif ($acct.ObjectClass -eq "user") {
        $userAccounts += $acct
    } else {
        $serviceAccounts += $acct
    }
}

# Display results
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host " DELEGATION SUMMARY" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "Total Accounts with Delegation: $($delegationAccounts.Count)" -ForegroundColor White
Write-Host "  ├─ Domain Controllers: $($dcAccounts.Count) " -NoNewline
if ($dcAccounts.Count -gt 0) { Write-Host "✓ Expected" -ForegroundColor Green } else { Write-Host "" }
Write-Host "  ├─ Service Accounts: $($serviceAccounts.Count) " -NoNewline
if ($serviceAccounts.Count -eq 0) { Write-Host "✓ None" -ForegroundColor Green } elseif ($serviceAccounts.Count -le 5) { Write-Host "⚠️ Review" -ForegroundColor Yellow } else { Write-Host "⚠️ High Count" -ForegroundColor Yellow }
Write-Host "  └─ User Accounts: $($userAccounts.Count) " -NoNewline
if ($userAccounts.Count -eq 0) { Write-Host "✓ None" -ForegroundColor Green } else { Write-Host "🚨 HIGH RISK" -ForegroundColor Red }
Write-Host ""

# ============================================================================
# DOMAIN CONTROLLERS (Expected)
# ============================================================================
if ($dcAccounts.Count -gt 0) {
    Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host " ✅ DOMAIN CONTROLLERS (Expected Delegation)" -ForegroundColor Green
    Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host ""
    Write-Host "Domain Controllers REQUIRE unconstrained delegation for AD to function." -ForegroundColor Green
    Write-Host "This is NORMAL and EXPECTED. No action required." -ForegroundColor Green
    Write-Host ""
    
    foreach ($dc in $dcAccounts) {
        $isUnconstrained = $dc.UserAccountControl -band 0x80000
        Write-Host "✓ $($dc.Name)" -ForegroundColor Green
        Write-Host "  Type: $($dc.ObjectClass)" -ForegroundColor Gray
        Write-Host "  Delegation: $(if ($isUnconstrained) { 'Unconstrained (Required for DCs)' } else { 'Constrained' })" -ForegroundColor Gray
        Write-Host ""
    }
}

# ============================================================================
# SERVICE ACCOUNTS (Review)
# ============================================================================
if ($serviceAccounts.Count -gt 0) {
    Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Yellow
    Write-Host " ⚠️ SERVICE ACCOUNTS WITH DELEGATION" -ForegroundColor Yellow
    Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "These accounts may be legitimate (SQL, Exchange, IIS, etc.)" -ForegroundColor Yellow
    Write-Host "Review to ensure they are documented and necessary." -ForegroundColor Yellow
    Write-Host ""
    
    foreach ($svc in $serviceAccounts) {
        $isUnconstrained = $svc.UserAccountControl -band 0x80000
        $delegateTo = $svc.'msDS-AllowedToDelegateTo'
        
        if ($isUnconstrained) {
            Write-Host "⚠️  $($svc.Name) [UNCONSTRAINED - HIGH RISK]" -ForegroundColor Red
        } else {
            Write-Host "ℹ️  $($svc.Name) [Constrained]" -ForegroundColor Yellow
        }
        
        Write-Host "  Type: $($svc.ObjectClass)" -ForegroundColor Gray
        
        if ($delegateTo) {
            Write-Host "  Delegates to:" -ForegroundColor Gray
            $delegateTo | Select-Object -First 5 | ForEach-Object {
                Write-Host "    - $_" -ForegroundColor Gray
            }
            if ($delegateTo.Count -gt 5) {
                Write-Host "    ... and $($delegateTo.Count - 5) more" -ForegroundColor DarkGray
            }
        } else {
            Write-Host "  Delegates to: ANY SERVICE (⚠️ High Risk!)" -ForegroundColor Red
        }
        
        if ($svc.servicePrincipalName) {
            Write-Host "  SPNs: $($svc.servicePrincipalName.Count) registered" -ForegroundColor DarkGray
        }
        Write-Host ""
    }
    
    Write-Host "═══ RECOMMENDED ACTIONS ═══" -ForegroundColor Yellow
    Write-Host "1. Verify these are legitimate service accounts" -ForegroundColor White
    Write-Host "2. For UNCONSTRAINED delegation: Change to CONSTRAINED" -ForegroundColor White
    Write-Host "3. Document business justification" -ForegroundColor White
    Write-Host "4. Ensure least privilege access" -ForegroundColor White
    Write-Host ""
}

# ============================================================================
# USER ACCOUNTS (High Risk)
# ============================================================================
if ($userAccounts.Count -gt 0) {
    Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Red
    Write-Host " 🚨 USER ACCOUNTS WITH DELEGATION (HIGH RISK!)" -ForegroundColor Red
    Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Red
    Write-Host ""
    Write-Host "REGULAR USER ACCOUNTS SHOULD NEVER HAVE DELEGATION!" -ForegroundColor Red
    Write-Host "This is a serious security risk." -ForegroundColor Red
    Write-Host ""
    
    foreach ($usr in $userAccounts) {
        $isUnconstrained = $usr.UserAccountControl -band 0x80000
        $delegateTo = $usr.'msDS-AllowedToDelegateTo'
        
        Write-Host "🚨 $($usr.Name)" -ForegroundColor Red
        if ($isUnconstrained) {
            Write-Host "  Delegation: UNCONSTRAINED (CRITICAL RISK!)" -ForegroundColor Red
            Write-Host "  Can impersonate users to ANY service!" -ForegroundColor Red
        } else {
            Write-Host "  Delegation: Constrained (HIGH RISK)" -ForegroundColor Yellow
            if ($delegateTo) {
                Write-Host "  Delegates to:" -ForegroundColor Yellow
                $delegateTo | Select-Object -First 3 | ForEach-Object {
                    Write-Host "    - $_" -ForegroundColor Gray
                }
                if ($delegateTo.Count -gt 3) {
                    Write-Host "    ... and $($delegateTo.Count - 3) more" -ForegroundColor DarkGray
                }
            }
        }
        Write-Host ""
    }
    
    Write-Host "═══ IMMEDIATE ACTIONS REQUIRED ═══" -ForegroundColor Red
    Write-Host "1. REMOVE delegation immediately" -ForegroundColor White
    Write-Host "2. If delegation is needed, create a SERVICE ACCOUNT" -ForegroundColor White
    Write-Host "3. Audit account activity for security incidents" -ForegroundColor White
    Write-Host "4. Review account permissions and access" -ForegroundColor White
    Write-Host ""
    Write-Host "To remove delegation from a user account:" -ForegroundColor Yellow
    Write-Host "  Set-ADUser USERNAME -Replace @{userAccountControl=512}" -ForegroundColor Gray
    Write-Host ""
}

# ============================================================================
# FINAL VERDICT
# ============================================================================
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host " VERDICT" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

if ($serviceAccounts.Count -eq 0 -and $userAccounts.Count -eq 0) {
    Write-Host "✅ ALL DELEGATION IS ON DOMAIN CONTROLLERS ONLY" -ForegroundColor Green
    Write-Host ""
    Write-Host "Your environment is HEALTHY. All delegation is expected and safe." -ForegroundColor Green
    Write-Host "The security baseline warnings can be safely ignored." -ForegroundColor Green
} elseif ($userAccounts.Count -eq 0 -and $serviceAccounts.Count -gt 0) {
    Write-Host "⚠️ Non-DC delegation found on service accounts" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Review the service accounts above and verify they are legitimate." -ForegroundColor Yellow
    Write-Host "Document business justification and ensure proper controls." -ForegroundColor Yellow
} else {
    Write-Host "🚨 HIGH RISK: User accounts have delegation!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Take immediate action to remove delegation from user accounts." -ForegroundColor Red
    Write-Host "This poses a significant security risk to your environment." -ForegroundColor Red
}

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
