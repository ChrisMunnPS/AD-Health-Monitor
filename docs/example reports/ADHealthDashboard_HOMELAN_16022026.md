# Active Directory Health Report

**Generated:** 16 February 2026 11:41

**Summary:** 2 domain controllers | 0 critical issues | 1 warnings

---

## Domain Controller Information

| Server | Site | IPv4 | CPU% | Mem% | Disk Free | Uptime (h) | AD DB (GB) |
|--------|------|------|------|------|-----------|------------|------------|
| dc01.HomeLAN.internal | Default-First-Site-Name | 10.0.0.10 | 3% | 62.5% | 35.93 GB (61.6%) | 13.5 | 0.04 |
| dc02.HomeLAN.internal | Default-First-Site-Name | 10.0.0.11 | 2% | 58.8% | 37.84 GB (64.8%) | 13.5 | 0.04 |

## DC Health Scores

- 🟢 **dc01.HomeLAN.internal**: 96% → Stable
- 🟢 **dc02.HomeLAN.internal**: 100% → Stable

## Health Overview

| Test | dc01.HomeLAN.internal | dc02.HomeLAN.internal |
|------|------|------|
| Advertising | ✅ | ✅ |
| CheckSDRefDom | ✅ | ✅ |
| Connectivity | ✅ | ✅ |
| CrossRefValidation | ✅ | ✅ |
| DFSREvent | ✅ | ✅ |
| DiskSpace | ✅ | ✅ |
| DNSZones | ✅ | ✅ |
| FrsEvent | ✅ | ✅ |
| FSMORoles | 5 | 0 |
| GPOReplication | ✅ | ✅ |
| Intersite | ✅ | ✅ |
| KccEvent | ✅ | ✅ |
| KnowsOfRoleHolders | ✅ | ✅ |
| LocatorCheck | ✅ | ✅ |
| MachineAccount | ✅ | ✅ |
| NCSecDesc | ✅ | ✅ |
| NetLogons | ✅ | ✅ |
| ObjectsReplicated | ✅ | ✅ |
| Ping | ✅ | ✅ |
| Replication | ✅ | ✅ |
| Replications | ✅ | ✅ |
| RidManager | ✅ | ✅ |
| SecurityBaseline | ✅ | ✅ |
| Services | ✅ | ✅ |
| SystemErrors24h | ⚠️ (ERROR) | ✅ (3) |
| SystemLog | ✅ | ✅ |
| SysVolCheck | ✅ | ✅ |
| VerifyReferences | ✅ | ✅ |

## Issues Detected

### dc01.HomeLAN.internal

**SystemErrors24h:**
```nError checking system event log:
Error: Failed to query event log: No matches found

Possible causes:
- Event log service not running or inaccessible
- Insufficient permissions to read event logs
- Event log is corrupted or very large
- WinRM timeout or connection issue

Troubleshooting:
1. Verify Event Log service is running:
   Get-Service -ComputerName dc01.HomeLAN.internal -Name EventLog

2. Check WinRM connectivity:
   Test-WSMan -ComputerName dc01.HomeLAN.internal

3. Test manual event log access:
   Get-EventLog -ComputerName dc01.HomeLAN.internal -LogName System -Newest 10

4. Try alternate method:
   Invoke-Command -ComputerName dc01.HomeLAN.internal { Get-EventLog -LogName System -Newest 10 }

```n

