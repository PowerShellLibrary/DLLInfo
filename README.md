# DLLInfo

This is a PowerShell module for reading DLLs information.

It can be used to find out what's the build configuration, target CPU and more.


# Installation
Module is available on [Powershell Gallery][gallery]

### Install
```powershell
PS> Install-Module -Name DLLInfo
```

### Import
```powershell
PS> Import-Module DLLInfo
```
# Usage


```powershell
PS> Get-BuildConfiguration "C:\dll\SiteMetadata.dll"
Release

PS> Get-TargetCPU "C:\dll\SiteMetadata.dll"
AnyCPU

PS> Get-JitOptimized "C:\dll\SiteMetadata.dll"
True
```

[gallery]: https://www.powershellgallery.com/packages/DLLInfo