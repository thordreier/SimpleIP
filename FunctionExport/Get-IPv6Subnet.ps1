function Get-IPv6Subnet
{
    <#
        .SYNOPSIS
            Get IP subnet for an IPv6 address

        .DESCRIPTION
            Get IP subnet for an IPv6 address

        .PARAMETER Ip
            Input IP is standard IPv6 format with out prefix (eg. "a:b:00c::" or "a:b:00c::0/64")

        .PARAMETER Prefix
            If prefix is not set in IP address, it must be set with this parameter

        .PARAMETER WithPrefix
            Return in "7:6:5::/64" format
            This is default output

        .PARAMETER IpOnly
            Return in "7:6:5::" format

        .EXAMPLE
            Get-IPv6Subnet -Ip 7:6:5::77:88/64
            7:6:5::/64

        .EXAMPLE
            Get-IPv6Subnet -Ip 7:6:5::77:88/64 -IpOnly
            7:6:5::
    #>

    [OutputType([System.String])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position=0)]
        [System.String]
        $Ip,

        [Parameter()]
        [Nullable[System.Byte]]
        $Prefix,

        [Parameter(ParameterSetName = 'SubnetWithPrefix')]
        [System.Management.Automation.SwitchParameter]
        $WithPrefix,

        [Parameter(Mandatory = $true, ParameterSetName = 'SubnetIpOnly')]
        [System.Management.Automation.SwitchParameter]
        $IpOnly
    )

    process
    {
        Write-Verbose -Message "Process begin (ErrorActionPreference: $ErrorActionPreference)"
        Get-IPv6Address -Subnet @PSBoundParameters
        Write-Verbose -Message 'Process end'
    }
}
