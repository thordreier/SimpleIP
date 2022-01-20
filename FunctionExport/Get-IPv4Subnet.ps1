function Get-IPv4Subnet
{
    <#
        .SYNOPSIS
            xxx

        .DESCRIPTION
            xxx

        .PARAMETER xxx
            xxx

        .EXAMPLE
            xxx
    #>

    [OutputType([System.String])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position=0)]
        [ValidateScript({ (Test-ValidIPv4 -Ip $_ -AllowMask) -or $(throw "$_ is not a valid IPv4 address") })]
        [System.String]
        $Ip,

        [Parameter()]
        [ValidateScript({ (Test-ValidIPv4 -Ip $_ -Mask -AllowLength) -or $(throw "$_ is not a valid IPv4 mask") })]
        [System.String]
        $Mask = '',

        [Parameter(ParameterSetName = 'SubnetWithMaskLength')]
        [System.Management.Automation.SwitchParameter]
        $WithMaskLength,

        [Parameter(Mandatory = $true, ParameterSetName = 'SubnetWithMask')]
        [System.Management.Automation.SwitchParameter]
        $WithMask,

        [Parameter(Mandatory = $true, ParameterSetName = 'SubnetIpOnly')]
        [System.Management.Automation.SwitchParameter]
        $IpOnly
    )

    process
    {
        Write-Verbose -Message "Process begin (ErrorActionPreference: $ErrorActionPreference)"
        Get-IPv4Address -Subnet @PSBoundParameters
        Write-Verbose -Message 'Process end'
    }
}
