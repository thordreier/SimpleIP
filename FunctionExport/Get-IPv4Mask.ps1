function Get-IPv4Mask
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

        #[Parameter()]
        #[ValidateScript({ (Test-ValidIPv4 -Ip $_ -Mask -AllowLength) -or $(throw "$_ is not a valid IPv4 mask") })]
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
            Ip = $Ip
        }
        #if ($Mask -ne '') {$params['Mask'] = $Mask}

        if     ($Length)          {$params['MaskLengthOnly']          = $true}
        elseif ($LengthWithSlash) {$params['MaskLengthWithSlashOnly'] = $true}
        else                      {$params['MaskQuadDotOnly']         = $true}

        Get-IPv4Address @params

        Write-Verbose -Message 'Process end'
    }
}
