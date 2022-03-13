---
title: "Import"
date: 2022-03-12T17:05:28+08:00
draft: true
---

## FULL Path
 Import full path

## Only File Path

```powershell
import-module XMLHelpers
```

 
`$home/WindowsPowerShell/Modules/XMLHelpers/`

`C:\Windows\System32\WindowsPowerShell\v1.0\Modules`

the full path would be

`$home/WindowsPowerShell/Modules/XMLHelpers/XMLHelpers.psm1`

## Current Folder

`Import-Module (Resolve-Path('XMLHelpers'))`