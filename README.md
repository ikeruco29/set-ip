# Set Ip
Powershell script to set and reset an static IP for any interface

# How to use it
---
First of all, identify the index of the network interface you want to set. This can be done executing this command:
```powershell
Get-NetIPAddress | Format-Table InterfaceIndex,InterfaceAlias
```
Now that you have the `index`, modify the `$interfaceIdx` default parameter inside the script if you
want to always change that interface, or just specify it with a parameter in the command call
with `-interfaceIdx`.

You need to specify the mandatory parameters `mode` (set or reset) and `ipaddr`.

For instance:
```powershell
.\setip.ps1 -mode set -ipaddr 192.168.1.23 -interfaceIdx 4
```
or faster:
```powershell
.\setip.ps1 set 192.168.1.23 4
```

and to reset it:
```powershell
.\setip.ps1 reset 192.168.1.23 4
```