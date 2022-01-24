function Get-IPv4Mask
{
    <#
        .SYNOPSIS
            Get IP subnet mask for an IP address

        .DESCRIPTION
            Get IP subnet mask for an IP address

        .PARAMETER IP
            Input IP in quad dot format with subnet mask, either:
            - IP + mask in quad dot, eg. "127.0.0.1 255.0.0.0"
            - IP + mask length,      eg. "127.0.0.1/8"

        .PARAMETER QuadDot
            Return subnet mask in "255.0.0.0" format

        .PARAMETER Length
            Return subnet mask in "8" format

        .PARAMETER LengthWithSlash
            Return subnet mask in "/8" format

        .EXAMPLE
            Get-IPv4Mask 9.8.7.6/22 -QuadDot
            255.255.252.0
    #>

    [OutputType([System.String])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position=0)]
        [ValidateScript({ (Test-ValidIPv4 -IP $_ -AllowMask) -or $(throw "$_ is not a valid IPv4 address") })]
        [System.String]
        $IP,

        #[Parameter()]
        #[ValidateScript({ (Test-ValidIPv4 -IP $_ -Mask -AllowLength) -or $(throw "$_ is not a valid IPv4 mask") })]
        #[System.String]
        #$Mask = '',
        
        [Parameter(ParameterSetName = 'QuadDot')]
        [System.Management.Automation.SwitchParameter]
        $QuadDot,

        [Parameter(Mandatory = $true, ParameterSetName = 'Length')]
        [System.Management.Automation.SwitchParameter]
        $Length,

        [Parameter(Mandatory = $true, ParameterSetName = 'LengthWithSlash')]
        [System.Management.Automation.SwitchParameter]
        $LengthWithSlash
    )

    process
    {
        Write-Verbose -Message "Process begin (ErrorActionPreference: $ErrorActionPreference)"

        $params = @{
            IP = $IP
        }
        #if ($Mask -ne '') {$params['Mask'] = $Mask}

        if     ($Length)          {$params['MaskLengthOnly']          = $true}
        elseif ($LengthWithSlash) {$params['MaskLengthWithSlashOnly'] = $true}
        else                      {$params['MaskQuadDotOnly']         = $true}

        Get-IPv4Address @params

        Write-Verbose -Message 'Process end'
    }
}
