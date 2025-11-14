param (
    [ValidateSet("set", "reset")]
    [Parameter(Mandatory = $true)]
    [string]$mode,
    
    [Parameter(Mandatory = $true)]
    [string]$ipaddr,
    
    [Parameter(Mandatory = $false)]
    [int]$interfaceIdx = 4
    )

    
if($null -eq $mode){
    Write-Output "Needs to specify mode"
    Write-Output "Example:"
    Write-Output "      setip.ps1 set/reset"
} else {
    if($mode -eq "set"){
        New-NetIPAddress -InterfaceIndex $interfaceIdx -IPAddress $ipaddr
        Set-NetIPAddress -InterfaceIndex $interfaceIdx -IPAddress $ipaddr -PrefixLength 24 
    } else {
        Remove-NetIPAddress -InterfaceIndex $interfaceIdx -IPAddress $ipaddr -Confirm:$false
        Set-NetIPInterface -InterfaceIndex $interfaceIdx -Dhcp Enabled
    }
    Write-Output "Done..."
    Get-NetIPAddress | Where-Object { $_.InterfaceIndex -eq $interfaceIdx } | Format-Table
}