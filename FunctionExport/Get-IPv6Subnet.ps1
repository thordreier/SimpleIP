function Get-IPv6Subnet
{
    <#
        .SYNOPSIS
            Get IP subnet for an IPv6 address

        .DESCRIPTION
            Get IP subnet for an IPv6 address

        .PARAMETER IP
            Input IP is standard IPv6 format with out prefix (eg. "a:b:00c::" or "a:b:00c::0/64")

        .PARAMETER Prefix
            If prefix is not set in IP address, it must be set with this parameter

        .PARAMETER WithPrefix
            Return in "7:6:5::/64" format
            This is default output

        .PARAMETER IPOnly
            Return in "7:6:5::" format

        .EXAMPLE
            Get-IPv6Subnet -IP 7:6:5::77:88/64
            7:6:5::/64

        .EXAMPLE
            Get-IPv6Subnet -IP 7:6:5::77:88/64 -IPOnly
            7:6:5::
    #>

    [OutputType([System.String])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position=0)]
        [System.String]
        $IP,

        [Parameter()]
        [Nullable[System.Byte]]
        $Prefix,

        [Parameter(ParameterSetName = 'SubnetWithPrefix')]
        [System.Management.Automation.SwitchParameter]
        $WithPrefix,

        [Parameter(Mandatory = $true, ParameterSetName = 'SubnetIPOnly')]
        [System.Management.Automation.SwitchParameter]
        $IPOnly
    )

    process
    {
        Write-Verbose -Message "Process begin (ErrorActionPreference: $ErrorActionPreference)"
        Get-IPv6Address -Subnet @PSBoundParameters
        Write-Verbose -Message 'Process end'
    }
}
