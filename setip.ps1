
param (
    [Alias("show-interfaces")]
    [Parameter(Mandatory = $false)]
    [switch]$showNetInterfaces,

    [ValidateSet("set", "reset")]
    [Parameter(Mandatory = $false)]
    [string]$mode,
    
    [Parameter(Mandatory = $false)]
    [string]$ipaddr,

    [Parameter(Mandatory = $false)]
    [switch]$all,
    
    [Parameter(Mandatory = $false)]
    [int]$interfaceIdx = 4,

    [Parameter(Mandatory = $false)]
    [switch]$help
    )

function Show-Help {
    Write-Host ""
    Write-Host "Usage:"
    Write-Host "  setip.ps1 [options]"
    Write-Host ""
    Write-Host "Options:"
    Write-Host "    -help                 Shows help"
    Write-Host "    -mode <set|reset>     Select the mode: set to set an IP and reset to reset that IP"
    Write-Host "    -ipaddr <string>      IP address to set or reset, depending on the selected mode"  
    Write-Host "    -all                  Can be used with mode 'reset' to reset all manual modified interfaces"
    Write-Host "    -interfaceIdx <int>   Affected interface index"
    Write-Host ""
}

if($PSBoundParameters.Count -eq 0 -or $help){
    Show-Help
    return
}
if($showNetInterfaces -eq $null){
    if($null -eq $mode){
        throw "Needs to specify mode`nExample:`n    setip.ps1 set"
    } elseif (-not $ipaddr -and -not $all ) {
        throw "Target IP address needs to be specified. `nUse -ipaddr to specify it, or use -all with the mode 'reset' to reset all static IP configured in either Wi-Fi or Ethernet network interfaces."
    } elseif ($mode -eq "set" -and $all) {
        throw "Cannot use -all with 'set' mode."
    }
} else {
    if($showNetInterfaces){
        Get-NetIPAddress | Format-Table InterfaceIndex,InterfaceAlias
        return
    }
    else{
        if ($mode -eq "set"){
            Set-NetIPInterface -InterfaceIndex $interfaceIdx -Dhcp Disabled
            New-NetIPAddress -InterfaceIndex $interfaceIdx -IPAddress $ipaddr
            Set-NetIPAddress -InterfaceIndex $interfaceIdx -IPAddress $ipaddr -PrefixLength 24 
        } elseif ($mode -eq "reset") {
            if($all){   # IF -all has been setted
                # Get ethernet and wifi interfaces that are not in DHCP
                $networkInterfaces = Get-NetIPAddress | Where-Object { $_.PrefixOrigin -like "manual" -and ($_.InterfaceAlias -eq "Ethernet" -or $_.InterfaceAlias -eq "Wi-Fi") }
                
                foreach ($networkInterface in $networkInterfaces) { # For each one, reset the IPAddress and enable de DHCP
                    Remove-NetIPAddress -InterfaceIndex $networkInterface.InterfaceIndex -IPAddress $networkInterface.IPAddress -Confirm:$false
                    Set-NetIPInterface -InterfaceIndex $networkInterface.InterfaceIndex -Dhcp Enabled
                }
            } else {
                Remove-NetIPAddress -InterfaceIndex $interfaceIdx -IPAddress $ipaddr -Confirm:$false
                Set-NetIPInterface -InterfaceIndex $interfaceIdx -Dhcp Enabled
            }
        }
        Write-Output "Done..."
        Get-NetIPAddress | Where-Object { $_.InterfaceIndex -eq $interfaceIdx } | Format-Table
    }
}