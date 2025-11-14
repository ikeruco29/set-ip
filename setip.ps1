param (
    [ValidateSet("set", "reset")]
    [Parameter(Mandatory = $true)]
    [string]$mode,
    
    [Parameter(Mandatory = $false)]
    [string]$ipaddr,

    [Parameter(Mandatory = $false)]
    [switch]$all,
    
    [Parameter(Mandatory = $false)]
    [int]$interfaceIdx = 4
    )

    
if($null -eq $mode){
    throw "Needs to specify mode`nExample:`n    setip.ps1 set"
} elseif (-not $ipaddr -and -not $all ) {
    throw "Target IP address needs to be specified. `nUse -ipaddr to specify it, or use -all with the mode 'reset' to reset all static IP configured in either Wi-Fi or Ethernet network interfaces."
} elseif ($mode -eq "set" -and $all) {
    throw "Cannot use -all with 'set' mode."
}
else {
    if($mode -eq "set"){
        Set-NetIPInterface -InterfaceIndex $interfaceIdx -Dhcp Disabled
        New-NetIPAddress -InterfaceIndex $interfaceIdx -IPAddress $ipaddr
        Set-NetIPAddress -InterfaceIndex $interfaceIdx -IPAddress $ipaddr -PrefixLength 24 
    } else {
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