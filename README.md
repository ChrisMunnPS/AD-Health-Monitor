# Enhanced Active Directory Health Monitor

[![PowerShell Version](https://img.shields.io/badge/PowerShell-5.1%2B-blue.svg)](https://github.com/PowerShell/PowerShell)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Windows%20Server-brightgreen.svg)](https://www.microsoft.com/windows-server)
[![Active Directory](https://img.shields.io/badge/Active%20Directory-2008%20R2%2B-orange.svg)](https://docs.microsoft.com/windows-server/identity/ad-ds/)
[![Status](https://img.shields.io/badge/Status-Production%20Ready-success.svg)]()
[![Maintenance](https://img.shields.io/badge/Maintained-Yes-green.svg)](https://github.com/ChrisMunnPS/AD-Health-Monitor/graphs/commit-activity)

> **Enterprise-grade Active Directory health monitoring with advanced analytics, historical trending, security auditing, and executive reporting.**

![AD Health Dashboard](https://via.placeholder.com/800x400/2a2a3d/00ffff?text=AD+Health+Dashboard+Preview)

---

## 📋 Table of Contents

- [Executive Summary](#executive-summary)
- [Health Score Calculation](#health-score-calculation)
- [Features](#features)
- [Technical Overview](#technical-overview)
- [Requirements](#requirements)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
- [Report Formats](#report-formats)
- [Health Checks](#health-checks)
- [Performance Metrics](#performance-metrics)
- [Security Auditing](#security-auditing)
- [Screenshots](#screenshots)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)
- [Credits](#credits)

---

## 🎯 Executive Summary

The **Enhanced Active Directory Health Monitor** is a comprehensive PowerShell-based monitoring solution designed for enterprise Active Directory environments. It provides real-time health assessment, historical trending analysis, security baseline auditing, and multi-format reporting capabilities.

### **Key Value Propositions:**

- **🔍 Comprehensive Monitoring** - 10 distinct health checks covering all critical AD components
- **📊 Visual Dashboards** - Interactive HTML reports with charts and trend indicators
- **📈 Historical Trending** - Track health scores over time to identify degradation patterns
- **🔐 Security Auditing** - Kerberos delegation analysis, privileged account monitoring, password hygiene
- **⚡ Performance Tracking** - CPU, memory, disk, network, and database size metrics
- **📧 Automated Delivery** - Email reports with multiple format attachments
- **👔 Executive Summaries** - One-page PDF-ready reports for management
- **🛡️ Smart Alerting** - Critical and warning alerts with configurable thresholds

### **Use Cases:**

- **Daily Operations** - Monitor domain controller health and identify issues proactively
- **Change Management** - Validate environment health before/after changes
- **Compliance Reporting** - Security baseline audits for regulatory requirements
- **Capacity Planning** - Track performance trends to predict resource needs
- **Executive Reporting** - High-level summaries for management stakeholders
- **Troubleshooting** - Detailed diagnostics for incident response

---

## 📐 Health Score Calculation

The health score is calculated as a **percentage of passed tests** for each domain controller, providing an at-a-glance assessment of overall health.

### **Calculation Formula:**

```
Health Score = (Passed Tests / Total Tests) × 100
```

### **Test Weighting:**

All tests are **equally weighted** to ensure balanced assessment:

| Test Category | Weight | Description |
|---------------|--------|-------------|
| Connectivity | 10% | Ping status |
| DCDiag | 10% | Native diagnostic tests |
| Replication | 10% | AD replication health |
| FSMO Roles | 10% | Role holder verification |
| Disk Space | 10% | Storage capacity |
| Services | 10% | Critical services running |
| Event Logs | 10% | System error count |
| GPO Replication | 10% | SYSVOL/NETLOGON health |
| DNS Zones | 10% | DNS integrity |
| Security Baseline | 10% | Security posture |

### **Score Interpretation:**

```
┌─────────────────────────────────────────────────────────┐
│  90-100%  │  🟢 HEALTHY    │  All systems operational  │
│  70-89%   │  🟡 WARNING    │  Minor issues detected    │
│  0-69%    │  🔴 CRITICAL   │  Immediate attention req. │
└─────────────────────────────────────────────────────────┘
```

### **Special Cases:**

- **WARN Status** - Counted as failed (reduces score) but less severe than FAIL
- **ERROR Status** - Counted as failed (indicates test couldn't complete)
- **System Errors** - Threshold-based (>10 errors = WARN)
- **FSMO Roles** - Informational (shows count, not pass/fail)

### **Trending Analysis:**

Health scores are compared with historical data to show:

- **↑ Improved** - Score increased by >5% since last run
- **↓ Degraded** - Score decreased by >5% since last run
- **→ Stable** - Score changed by ≤5%

---

## ✨ Features

### **Core Monitoring**

- ✅ **10 Comprehensive Health Checks** - Full AD infrastructure coverage
- ✅ **Multi-DC Support** - Monitors all domain controllers automatically
- ✅ **Real-time Diagnostics** - Immediate issue identification
- ✅ **Error Correlation** - Links related failures across DCs

### **Advanced Analytics**

- 📊 **Historical Trending** (Phase 1)
  - 90-day retention (configurable)
  - Automatic trend calculation
  - Score comparison with previous runs
  - Pattern detection for proactive alerts

- ⚡ **Performance Metrics** (Phase 1)
  - CPU utilization percentage
  - Memory usage and availability
  - Network throughput (Mbps)
  - AD database size (NTDS.dit)
  - SYSVOL size tracking
  - Disk space monitoring

- 🔔 **Smart Alerting** (Phase 1)
  - Critical vs. Warning severity levels
  - Configurable alert conditions
  - Console and email notifications
  - Alert aggregation and deduplication

### **Security & Compliance**

- 🔐 **Kerberos Delegation Audit** (Phase 2)
  - Unconstrained vs. constrained delegation
  - Automatic DC exclusion (expected delegation)
  - Service account categorization
  - Risk level assessment
  - Detailed remediation guidance

- 🛡️ **Security Baseline Monitoring** (Phase 2)
  - Privileged group membership tracking
  - Inactive admin account detection
  - Password age monitoring
  - "Password never expires" auditing
  - Delegation security analysis

- 🌐 **DNS Health Checks** (Phase 2)
  - Zone AD integration verification
  - Built-in zone filtering
  - Critical zone validation (_msdcs)
  - Resolution functionality testing

- 📁 **GPO Replication Health** (Phase 2)
  - SYSVOL share validation
  - NETLOGON share verification
  - DFSR service status

### **Reporting & Visualization**

- 📄 **5 Report Formats**
  - Interactive HTML Dashboard (with Chart.js)
  - Executive Summary (PDF-ready)
  - Markdown (documentation-friendly)
  - CSV (Excel/data analysis)
  - JSON (programmatic integration)

- 📊 **Visual Elements**
  - Health score bar charts
  - Issue distribution doughnut charts
  - Color-coded status indicators
  - Trend arrows and percentages
  - Summary cards with metrics

- 👔 **Executive Summary**
  - One-page PDF-ready format
  - High-level status dashboard
  - Key findings & recommendations
  - Prioritized action items
  - Management-friendly language

### **Automation & Integration**

- 📧 **Email Delivery**
  - SMTP/TLS support
  - Multiple recipients
  - Attachment support (all formats)
  - HTML email bodies
  - Secure authentication

- 🔄 **Historical Data Management**
  - Automatic data storage
  - Configurable retention period
  - Old file cleanup
  - JSON-based storage
  - Trend calculation

- ⚙️ **Flexible Configuration**
  - Customizable thresholds
  - Toggleable report formats
  - Adjustable alert conditions
  - Service list customization
  - Email settings

---

## 🔬 Technical Overview

### **Architecture**

```
┌─────────────────────────────────────────────────────────────┐
│                   Enhanced-ADHealthMonitor.ps1              │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐       │
│  │   Discovery  │  │ Health Checks│  │   Reporting  │       │
│  ├──────────────┤  ├──────────────┤  ├──────────────┤       │
│  │ • Get DCs    │  │ • Ping       │  │ • HTML       │       │
│  │ • DC Info    │  │ • DCDiag     │  │ • Executive  │       │
│  │ • Roles      │  │ • Replication│  │ • Markdown   │       │
│  │ • Perf Data  │  │ • FSMO       │  │ • CSV/JSON   │       │
│  └──────────────┘  │ • Disk Space │  │ • Email      │       │
│                    │ • Services   │  └──────────────┘       │
│  ┌──────────────┐  │ • Event Logs │                         │
│  │  Historical  │  │ • GPO Replic │  ┌──────────────┐       │
│  │   Trending   │  │ • DNS Zones  │  │   Alerting   │       │
│  ├──────────────┤  │ • Security   │  ├──────────────┤       │
│  │ • Load Data  │  └──────────────┘  │ • Critical   │       │
│  │ • Compare    │                    │ • Warning    │       │
│  │ • Calculate  │  ┌──────────────┐  │ • Console    │       │
│  │ • Save       │  │  Delegation  │  │ • Email      │       │
│  │ • Cleanup    │  │    Audit     │  └──────────────┘       │
│  └──────────────┘  ├──────────────┤                         │
│                    │ • DC Filter  │                         │
│                    │ • Categorize │                         │
│                    │ • Risk Assess│                         │
│                    │ • Report     │                         │
│                    └──────────────┘                         │
└─────────────────────────────────────────────────────────────┘
```

### **Execution Flow**

1. **Initialization**
   - Import Active Directory module
   - Load configuration settings
   - Initialize data structures
   - Setup historical trending

2. **Discovery Phase**
   - Enumerate domain controllers
   - Gather DC information (OS, IP, roles)
   - Collect performance metrics (CPU, memory, disk)
   - Check DNS service status

3. **Health Check Phase** (Per DC)
   - Ping test
   - DCDiag tests
   - AD replication status
   - FSMO role verification
   - Disk space checks
   - Critical services status
   - System event log errors
   - GPO replication health
   - DNS zone integrity
   - Security baseline audit

4. **Domain-wide Audits**
   - Kerberos delegation analysis
   - Privileged account monitoring
   - Security baseline assessment

5. **Analysis Phase**
   - Calculate health scores
   - Performance threshold checks
   - Alert generation
   - Trend comparison
   - Historical data save

6. **Reporting Phase**
   - Generate HTML dashboard
   - Create executive summary
   - Export Markdown/CSV/JSON
   - Send email (if configured)
   - Display summary

### **Technology Stack**

- **Core:** PowerShell 5.1+ (Windows PowerShell)
- **AD Module:** Active Directory PowerShell Module (RSAT)
- **Remote Execution:** PowerShell Remoting (WinRM)
- **Visualization:** Chart.js 4.4.0
- **Storage:** JSON file-based persistence
- **Email:** .NET SMTP Client

### **Performance Characteristics**

- **Execution Time:** 1-3 minutes per DC (typical)
- **Resource Usage:** <100 MB memory, <5% CPU
- **Network Impact:** Minimal (WMI, LDAP queries only)
- **Scalability:** Tested with 50+ DCs
- **Concurrency:** Sequential DC processing (parallel in future)

---

## 📋 Requirements

### **Operating System**

- Windows Server 2008 R2 or later (for DCs)
- Windows 10/11 or Server 2012+ (for script execution)

### **PowerShell**

- PowerShell 5.1 or later (included in Windows Server 2016+)
- PowerShell 7.x compatible (but not required)

### **Active Directory**

- Active Directory Domain Services functional level 2008 R2+
- RSAT: Active Directory PowerShell Module
- Domain Admin or equivalent permissions

### **Network & Services**

- Network connectivity to all domain controllers
- PowerShell Remoting (WinRM) enabled on all DCs
- DNS resolution for DC FQDNs
- Firewall rules allowing WinRM (TCP 5985/5986)

### **RSAT Tools Installation**

**Windows Server:**
```powershell
Install-WindowsFeature RSAT-AD-PowerShell
```

**Windows 10/11:**
```powershell
Add-WindowsCapability -Online -Name Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0
```

### **Enable PowerShell Remoting (on DCs)**

```powershell
Enable-PSRemoting -Force
Set-Item WSMan:\localhost\Client\TrustedHosts * -Force
```

---

## 🚀 Installation

### **Method 1: Clone Repository**

```powershell
# Clone the repository
git clone https://github.com/ChrisMunnPS/AD-Health-Monitor.git
cd AD-Health-Monitor

# Verify installation
.\Enhanced-ADHealthMonitor.ps1 -WhatIf
```

### **Method 2: Direct Download**

1. Download `Enhanced-ADHealthMonitor.ps1`
2. Save to `C:\Scripts\` (or preferred location)
3. Unblock the file:

```powershell
Unblock-File -Path "C:\Scripts\Enhanced-ADHealthMonitor.ps1"
```

### **Method 3: PowerShell Gallery** (Future)

```powershell
Install-Script -Name Enhanced-ADHealthMonitor
```

---

## ⚡ Quick Start

### **Basic Usage**

```powershell
# Run with default settings
.\Enhanced-ADHealthMonitor.ps1

# Open the generated HTML dashboard
# (automatically opens in browser)
```

### **First Run Checklist**

- [ ] RSAT-AD-PowerShell module installed
- [ ] Running as Domain Admin
- [ ] PowerShell Remoting enabled on all DCs
- [ ] Network connectivity to all DCs
- [ ] Execution policy allows script execution

### **Expected Output**

```
═══════════════════════════════════════════════════════════
  Enhanced Active Directory Health Monitor
═══════════════════════════════════════════════════════════

Found 2 domain controllers

Gathering domain controller information...
  [1/2] dc01.HomeLAN.internal... Done
  [2/2] dc02.HomeLAN.internal... Done

[1/2] Checking dc01.HomeLAN.internal...
  ├─ Ping test... PASS
  ├─ Running DCDiag tests... Done
  ├─ Checking AD replication... PASS
  ├─ Verifying FSMO roles... 5 role(s)
  ├─ Checking disk space... PASS
  ├─ Checking critical services... PASS (all 6 services running)
  ├─ Checking system errors (24h)... 3 error(s)
  ├─ Checking GPO replication... PASS
  ├─ Checking DNS zones... PASS
  └─ Auditing security baseline... PASS

Calculating health scores...
  Overall: 0 critical issues, 0 warnings

Generating reports...
  ├─ CSV exported: ADHealthDashboard_HOMELAN_160226.csv
  ├─ JSON exported: ADHealthDashboard_HOMELAN_160226.json
  ├─ Markdown report: ADHealthDashboard_HOMELAN_160226.md
  ├─ HTML dashboard: ADHealthDashboard_HOMELAN_160226.html
  └─ Executive summary: ADHealthSummary_Executive_HOMELAN_160226.html

═══════════════════════════════════════════════════════════
  Monitoring Complete!
═══════════════════════════════════════════════════════════

Execution time: 45.2 seconds
```

---

## ⚙️ Configuration

### **Report Generation**

```powershell
$reportConfig = @{
    GenerateHTML        = $true    # Interactive dashboard
    GenerateMarkdown    = $true    # Documentation format
    GenerateCSV         = $true    # Excel-friendly
    GenerateJSON        = $true    # API integration
    GenerateExecutive   = $true    # Management summary
}
```

### **Historical Trending**

```powershell
$historyConfig = @{
    EnableTrending      = $true     # Enable trend analysis
    HistoryRetentionDays = 90       # Keep 90 days of data
    HistoryPath         = ".\ADHealthHistory"  # Storage location
}
```

### **Smart Alerting**

```powershell
$alertConfig = @{
    EnableAlerts = $true
    
    Critical = @{
        Conditions = @(
            "DC Offline",
            "Replication Failed", 
            "FSMO Role Holder Unreachable",
            "Critical Service Stopped",
            "Disk Space Critical"
        )
        NotifyMethods = @("Email", "Console")
    }
    
    Warning = @{
        Conditions = @(
            "High Replication Delay",
            "Disk Space Low",
            "High Error Count",
            "Performance Degradation",
            "Security Baseline Violation"
        )
        NotifyMethods = @("Email", "Console")
    }
}
```

### **Email Delivery**

```powershell
$emailConfig = @{
    Enabled      = $true
    SmtpServer   = "smtp.yourdomain.com"
    SmtpPort     = 587
    UseSsl       = $true
    From         = "ad-monitoring@yourdomain.com"
    To           = @("itteam@yourdomain.com", "manager@yourdomain.com")
    Subject      = "AD Health Report - {DATE}"
    Username     = "ad-monitoring@yourdomain.com"
    Password     = "YourSecurePassword"  # Consider Get-Credential
}
```

### **Thresholds**

```powershell
$thresholds = @{
    # Disk Space
    DiskSpaceWarningGB  = 30    # Warn if <30 GB free
    DiskSpaceCriticalGB = 20    # Critical if <20 GB free
    
    # Replication
    ReplicationDelayMin = 60    # Warn if delay >60 minutes
    
    # Event Logs
    MaxSystemErrors     = 10    # Warn if >10 errors/24h
    
    # Performance (Phase 1)
    CPUWarningPercent      = 80    # Warn if CPU >80%
    CPUCriticalPercent     = 95    # Critical if CPU >95%
    MemoryWarningPercent   = 85    # Warn if memory >85%
    MemoryCriticalPercent  = 95    # Critical if memory >95%
    
    # DNS (Phase 2)
    DNSQueryTimeoutMs      = 1000  # DNS timeout threshold
    
    # Security (Phase 2)
    MaxInactiveAdminDays   = 90    # Warn if admin inactive >90 days
    MaxPasswordAgeDays     = 365   # Warn if password >365 days old
}
```

### **Monitored Services**

```powershell
$criticalServices = @(
    "NTDS",           # Active Directory Domain Services
    "DNS",            # DNS Server
    "Kdc",            # Kerberos Key Distribution Center
    "Netlogon",       # Netlogon
    "DFSR",           # DFS Replication
    "W32Time"         # Windows Time
)
```

---

## 📊 Report Formats

### **1. HTML Dashboard** (`ADHealthDashboard_*.html`)

**Features:**
- Interactive Chart.js visualizations
- Color-coded health indicators
- Responsive design (mobile-friendly)
- Dark theme optimized for readability
- Click-to-sort tables
- Embedded CSS/JavaScript (no dependencies)

**Sections:**
- Summary Cards (DCs, Critical Issues, Warnings, Overall Health)
- Active Alerts (if any)
- DC Performance Metrics Table
- DC Details Table
- Health Score Chart (bar)
- Issue Distribution Chart (doughnut)
- Detailed Health Matrix
- Kerberos Delegation Details
- Issue Details & Diagnostics
- Footer with generation time

### **2. Executive Summary** (`ADHealthSummary_Executive_*.html`)

**Features:**
- One-page PDF-ready format
- Print-optimized styling
- Management-friendly language
- No technical jargon
- Visual status dashboard
- Key findings & recommendations
- Prioritized action items

**Target Audience:** C-level, management, non-technical stakeholders

### **3. Markdown Report** (`ADHealthDashboard_*.md`)

**Features:**
- GitHub/GitLab compatible
- Documentation-friendly
- Plain text tables
- Emoji indicators
- Code blocks for details
- Easy to version control

**Use Cases:** Documentation, wiki, change management

### **4. CSV Export** (`ADHealthDashboard_*.csv`)

**Features:**
- Excel-compatible
- Flat data structure
- All metrics included
- Performance data
- Timestamp column
- Easy filtering/sorting

**Use Cases:** Data analysis, trending in Excel, reporting tools

### **5. JSON Export** (`ADHealthDashboard_*.json`)

**Features:**
- Hierarchical structure
- API-friendly format
- Complete metadata
- Programmatic parsing
- Integration-ready

**Use Cases:** SIEM integration, ticketing systems, monitoring platforms

---

## 🔍 Health Checks

### **Test 1: Ping Status**
- **Purpose:** Verify basic network connectivity
- **Method:** ICMP echo request
- **Pass Criteria:** DC responds to ping
- **Failure Impact:** Skips remaining tests for unreachable DC

### **Test 2: DCDiag Tests**
- **Purpose:** Run native AD diagnostic tests
- **Method:** Execute `dcdiag` and parse output
- **Tests Included:** Connectivity, Replications, NCSecDesc, NetLogons, Services, etc.
- **Pass Criteria:** All dcdiag tests pass
- **Failure Impact:** Identifies specific AD component failures

### **Test 3: AD Replication**
- **Purpose:** Verify replication health across the domain
- **Method:** `Get-ADReplicationPartnerMetadata`, `Get-ADReplicationFailure`
- **Pass Criteria:** No replication failures, delay <60 minutes
- **Warning:** Delay >60 minutes but no failures
- **Failure Impact:** Data inconsistency across DCs

### **Test 4: FSMO Roles**
- **Purpose:** Document which DC holds which roles
- **Method:** Query `Get-ADDomain` and `Get-ADForest`
- **Roles Checked:** PDC, RID, Infrastructure, Schema, Domain Naming
- **Pass Criteria:** Informational (shows count)
- **Note:** Not a pass/fail test, just informational

### **Test 5: Disk Space**
- **Purpose:** Ensure adequate storage capacity
- **Method:** WMI query for logical disks
- **Warning:** <30 GB free
- **Critical:** <20 GB free
- **Failure Impact:** Service degradation, log truncation, database growth issues

### **Test 6: Critical Services**
- **Purpose:** Verify essential AD services are running
- **Method:** Remote service status check via Invoke-Command
- **Services:** NTDS, DNS, Kdc, Netlogon, DFSR, W32Time
- **Pass Criteria:** All installed services running
- **Warning:** Services not installed (e.g., DNS on non-DNS DC)
- **Failure Impact:** AD functionality impaired

### **Test 7: System Event Log Errors**
- **Purpose:** Identify recent system-level issues
- **Method:** `Get-WinEvent` / `Get-EventLog` for last 24 hours
- **Pass Criteria:** ≤10 error events
- **Warning:** >10 error events
- **Failure Impact:** Indicators of underlying system problems

### **Test 8: GPO Replication** (Phase 2)
- **Purpose:** Verify Group Policy distribution
- **Method:** Check SYSVOL, NETLOGON shares, DFSR service
- **Pass Criteria:** All shares accessible, DFSR running
- **Failure Impact:** GPO changes not replicated

### **Test 9: DNS Zone Health** (Phase 2)
- **Purpose:** Ensure DNS integrity for AD operations
- **Method:** Query DNS zones, test resolution
- **Checks:** Domain zone AD-integrated, _msdcs zone exists, DNS resolution works
- **Pass Criteria:** All zones healthy, resolution successful
- **Failure Impact:** Authentication failures, name resolution issues

### **Test 10: Security Baseline** (Phase 2)
- **Purpose:** Audit security configuration
- **Method:** Query privileged groups, check delegation, password policies
- **Checks:**
  - Inactive admin accounts (>90 days)
  - Password never expires
  - Old passwords (>365 days)
  - Kerberos delegation (unconstrained/constrained)
- **Pass Criteria:** No security issues detected
- **Warning:** Security issues found (not critical but requires review)

---

## ⚡ Performance Metrics

Collected for each domain controller:

| Metric | Collection Method | Purpose |
|--------|------------------|---------|
| **CPU Usage %** | WMI: `Win32_Processor.LoadPercentage` | Identify overloaded DCs |
| **Memory Usage %** | WMI: `Win32_OperatingSystem` memory calculations | Detect memory pressure |
| **Memory Available (GB)** | WMI: `Win32_OperatingSystem.FreePhysicalMemory` | Capacity planning |
| **Network Utilization (Mbps)** | WMI: `Win32_PerfFormattedData_Tcpip_NetworkInterface` | Network saturation detection |
| **AD Database Size (GB)** | File size: `C:\Windows\NTDS\ntds.dit` | Database growth tracking |
| **SYSVOL Size (GB)** | Folder size: `C:\Windows\SYSVOL` | SYSVOL bloat detection |
| **Disk Free Space (GB)** | WMI: `Win32_LogicalDisk.FreeSpace` | Storage capacity monitoring |
| **Disk Free (%)** | Calculated from total/free | Threshold-based alerting |
| **Uptime (hours)** | `Win32_OperatingSystem.LastBootUpTime` | Reboot tracking |

### **Thresholds & Alerts**

- **CPU:** Warning at 80%, Critical at 95%
- **Memory:** Warning at 85%, Critical at 95%
- **Disk:** Warning at <30 GB, Critical at <20 GB

---

## 🔐 Security Auditing

### **Kerberos Delegation Analysis**

**What It Checks:**
- Accounts with unconstrained delegation (high risk)
- Accounts with constrained delegation (medium risk)
- Automatic DC filtering (DCs require delegation)

**Categories:**
- ✅ **Domain Controllers** - Expected, safe
- ⚠️ **Service Accounts** - Review required (SQL, Exchange, IIS)
- 🚨 **User Accounts** - High risk, immediate action

**Risk Assessment:**
- **Unconstrained Delegation** - Can impersonate to ANY service
- **Constrained Delegation** - Limited to specific SPNs
- **DC Delegation** - Required for AD functionality

### **Privileged Account Monitoring**

**Groups Monitored:**
- Domain Admins
- Enterprise Admins
- Schema Admins
- Administrators

**Checks:**
- Inactive admin accounts (configurable threshold)
- "Password never expires" flag
- Password age exceeding policy
- Delegation permissions

---

## 📸 Screenshots

### HTML Dashboard
![Dashboard Overview](https://raw.githubusercontent.com/ChrisMunnPS/AD-Health-Monitor/main/docs/images/dashboard.png)




### Executive Summary
![Executive Summary](https://raw.githubusercontent.com/ChrisMunnPS/AD-Health-Monitor/main/docs/images/executive-summary.png)


---

## 🔧 Troubleshooting

### **Common Issues**

#### **Issue: "Module ActiveDirectory not found"**

**Solution:**
```powershell
# Install RSAT on Windows Server
Install-WindowsFeature RSAT-AD-PowerShell

# Install RSAT on Windows 10/11
Add-WindowsCapability -Online -Name Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0
```

#### **Issue: "Access Denied" when checking services**

**Solution:**
- Run PowerShell as Administrator
- Ensure running as Domain Admin
- Verify WinRM is enabled on target DC

#### **Issue: "SystemErrors24h: ERROR"**

**Causes:**
- Large event log causing timeout
- Event Log service not running
- WinRM connectivity issue

**Solution:**
```powershell
# Run diagnostic script
.\Test-EventLogAccess.ps1 -ComputerName dc01

# Clear large event logs
wevtutil.exe cl System

# Restart Event Log service
Restart-Service -Name EventLog -Force
```

#### **Issue: Services show FAIL but are running**

**Solution:**
- Update to latest script version (fixes enum-to-string comparison)
- Verify services manually: `Get-Service NTDS, DNS, Kdc -ComputerName dc01`

#### **Issue: "DNS Health: Non-AD-integrated zones"**

**Cause:** Script flagging built-in zones (0.in-addr.arpa, 127.in-addr.arpa)

**Solution:**
- Update to latest script (automatically filters built-in zones)
- These zones are expected to be file-based

#### **Issue: False delegation warnings**

**Cause:** DCs not being recognized properly

**Solution:**
- Update to latest script (improved DC detection)
- DCs should show as "Expected" in Kerberos Delegation section

### **Diagnostic Scripts**

**Test Event Log Access:**
```powershell
.\Test-EventLogAccess.ps1 -ComputerName dc01.HomeLAN.internal
```

**Test Service Checks:**
```powershell
.\Test-ServiceCheck.ps1
```

**Investigate Kerberos Delegation:**
```powershell
.\Investigate-KerberosDelegation.ps1
```

---

## 🤝 Contributing

Contributions are welcome! Please follow these guidelines:

### **Reporting Issues**

1. Check existing issues first
2. Provide detailed reproduction steps
3. Include PowerShell version and OS details
4. Attach relevant error messages or logs

### **Submitting Pull Requests**

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### **Development Guidelines**

- Follow PowerShell best practices
- Add comments for complex logic
- Test on multiple DC configurations
- Update README for new features
- Maintain backwards compatibility

### **Testing Checklist**

- [ ] Tested on Windows Server 2016+
- [ ] Tested on Windows Server 2012 R2
- [ ] Tested with 2+ domain controllers
- [ ] Tested with PowerShell 5.1
- [ ] Tested email delivery
- [ ] Tested all report formats
- [ ] No syntax errors (`PSScriptAnalyzer`)

---

## 📜 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2025 Christopher Munn

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## 🙏 Credits

### **Author**

**Christopher Munn**  
- Website: [ChrisMunnPS.github.io](https://ChrisMunnPS.github.io)
- GitHub: [@ChrisMunnPS](https://github.com/ChrisMunnPS)

### **Acknowledgments**

- **Chart.js Team** - Excellent visualization library
- **PowerShell Community** - Feedback and suggestions
- **Active Directory Community** - Best practices and guidance

### **Technologies Used**

- [PowerShell](https://github.com/PowerShell/PowerShell) - Automation engine
- [Chart.js](https://www.chartjs.org/) - JavaScript charting library
- [Active Directory Module](https://docs.microsoft.com/powershell/module/activedirectory/) - AD cmdlets

---

## 📞 Support

### **Community Support**

- **GitHub Issues:** [Report bugs or request features](https://github.com/ChrisMunnPS/AD-Health-Monitor/issues)
- **Discussions:** [Ask questions or share ideas](https://github.com/ChrisMunnPS/AD-Health-Monitor/discussions)

### **Professional Support**

For enterprise support, custom development, or consulting:
- Contact via [ChrisMunnPS.github.io](https://ChrisMunnPS.github.io)

---

## 🗺️ Roadmap

### **Phase 3: Automation & Integration** (Planned)

- [ ] Task Scheduler automation templates
- [ ] Parallel DC processing for faster execution
- [ ] REST API for programmatic access
- [ ] SIEM integration (Splunk, ELK)
- [ ] ServiceNow/Jira ticketing integration
- [ ] Teams/Slack webhook alerts
- [ ] PowerBI dashboard templates

### **Phase 4: Advanced Features** (Future)

- [ ] Machine learning-based anomaly detection
- [ ] Capacity forecasting
- [ ] Change correlation analysis
- [ ] Multi-forest support
- [ ] Compliance report templates (SOX, HIPAA, PCI-DSS)
- [ ] Mobile-optimized dashboards
- [ ] Real-time monitoring daemon

### **Community Requests**

Vote for features in [GitHub Discussions](https://github.com/ChrisMunnPS/AD-Health-Monitor/discussions)!

---

## 📊 Statistics

![GitHub stars](https://img.shields.io/github/stars/ChrisMunnPS/AD-Health-Monitor?style=social)
![GitHub forks](https://img.shields.io/github/forks/ChrisMunnPS/AD-Health-Monitor?style=social)
![GitHub watchers](https://img.shields.io/github/watchers/ChrisMunnPS/AD-Health-Monitor?style=social)

---

<div align="center">

**⭐ If this project helped you, please consider giving it a star! ⭐**

Made with ❤️ by [Christopher Munn](https://ChrisMunnPS.github.io)

[Report Bug](https://github.com/ChrisMunnPS/AD-Health-Monitor/issues) · [Request Feature](https://github.com/ChrisMunnPS/AD-Health-Monitor/issues) · [Documentation](https://github.com/ChrisMunnPS/AD-Health-Monitor/wiki)

</div>
