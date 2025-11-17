# Set Ip

Powershell script to set and reset an static IP for any interface

# How to use it

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

# Parameters
### -all
Used with `reset` value in 'mode'. Resets the IP of ethernet and wifi interfaces.
```bash
.\setip.ps1 reset -all
```

### -mode
Set the mode of the command. It can be `set` or `reset`.

### -ipaddr
Select the ip address the command will work with.
`.\setip.ps1 set -ipaddr 192.168.1.12` → set the ip address 192.168.1.12 to the default interface.

### -interfaceIdx
Set the interface index it will work with.

