function Get-IPv4Subnet
{
    <#
        .SYNOPSIS
            Get IP subnet for an IP address

        .DESCRIPTION
            Get IP subnet for an IP address

        .PARAMETER IP
            Input IP in quad dot format with subnet mask, either:
            - IP + mask in quad dot, eg. "127.0.0.1 255.0.0.0"
            - IP + mask length,      eg. "127.0.0.1/8"
            If input is IP without subnet mask (eg. "127.0.0.1") then -Mask parameter must be set

        .PARAMETER Mask
            If input IP is in format without subnet mask, this parameter must be set to either
            - Quad dot format,        eg. "255.255.255.0"
            - Mask length (0-32),     eg. "24"
            - Mask length with slash, eg. "/24"

        .PARAMETER WithMaskLength
            Return in "127.0.0.0/8" format
            This is default output

        .PARAMETER WithMask
            Return in "127.0.0.0 255.0.0.0" format

        .PARAMETER IPOnly
            Return in "127.0.0.1" format

        .EXAMPLE
            Get-IPv4Subnet 127.0.0.1/8
            127.0.0.0/8

        .EXAMPLE
            Get-IPv4Subnet -IP 10.20.30.40/28 -WithMask
            10.20.30.32 255.255.255.240

        .EXAMPLE
            Get-IPv4Subnet -IP '10.20.30.40 255.255.255.240' -IPOnly
            10.20.30.32
    #>

    [OutputType([System.String])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position=0)]
        [ValidateScript({ (Test-ValidIPv4 -IP $_ -AllowMask) -or $(throw "$_ is not a valid IPv4 address") })]
        [System.String]
        $IP,

        [Parameter()]
        [ValidateScript({ (Test-ValidIPv4 -IP $_ -Mask -AllowLength) -or $(throw "$_ is not a valid IPv4 mask") })]
        [System.String]
        $Mask = '',

        [Parameter(ParameterSetName = 'SubnetWithMaskLength')]
        [System.Management.Automation.SwitchParameter]
        $WithMaskLength,

        [Parameter(Mandatory = $true, ParameterSetName = 'SubnetWithMask')]
        [System.Management.Automation.SwitchParameter]
        $WithMask,

        [Parameter(Mandatory = $true, ParameterSetName = 'SubnetIPOnly')]
        [System.Management.Automation.SwitchParameter]
        $IPOnly
    )

    process
    {
        Write-Verbose -Message "Process begin (ErrorActionPreference: $ErrorActionPreference)"
        Get-IPv4Address -Subnet @PSBoundParameters
        Write-Verbose -Message 'Process end'
    }
}
