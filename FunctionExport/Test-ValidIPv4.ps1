function Test-ValidIPv4
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

    [OutputType([System.Boolean])]
    [CmdletBinding(DefaultParameterSetName = 'IpOnly')]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position=0)]
        [System.String]
        $Ip,

        [Parameter(ParameterSetName = 'IpOnly')]
        [System.Management.Automation.SwitchParameter]
        $IpOnly,

        [Parameter(Mandatory = $true, ParameterSetName = 'Subnet')]
        [System.Management.Automation.SwitchParameter]
        $Subnet,

        [Parameter(Mandatory = $true, ParameterSetName = 'AllowSubnet')]
        [System.Management.Automation.SwitchParameter]
        $AllowSubnet,

        [Parameter(Mandatory = $true, ParameterSetName = 'RequireSubnet')]
        [System.Management.Automation.SwitchParameter]
        $RequireSubnet
    )

    begin
    {
        Write-Verbose -Message "Begin (ErrorActionPreference: $ErrorActionPreference)"
        $origErrorActionPreference = $ErrorActionPreference
        $verbose = $PSBoundParameters.ContainsKey('Verbose') -or ($VerbosePreference -ne 'SilentlyContinue')
    }

    process
    {
        Write-Verbose -Message "Process begin (ErrorActionPreference: $ErrorActionPreference)"

        try
        {
            # Make sure that we don't continue on error, and that we catches the error
            $ErrorActionPreference = 'Stop'

            $i = '(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)'
            $s = '(((255\.){3}(255|254|252|248|240|224|192|128|0+))|((255\.){2}(255|254|252|248|240|224|192|128|0+)\.0)|((255\.)(255|254|252|248|240|224|192|128|0+)(\.0+){2})|((255|254|252|248|240|224|192|128|0+)(\.0+){3}))'
            $b = '[0-9]|[12][0-9]|3[0-2]'
            $matchIp     = "^($i)$"
            $matchSubnet = "^($s)$"
            $matchAll    = "^($i)[/ ](($s)|($b))$"

            (
                ($PSCmdlet.ParameterSetName -eq 'IpOnly'        -and $Ip -match $matchIp    ) -or
                ($PSCmdlet.ParameterSetName -eq 'Subnet'        -and $Ip -match $matchSubnet) -or
                ($PSCmdlet.ParameterSetName -eq 'AllowSubnet'   -and $Ip -match $matchIp    ) -or
                ($PSCmdlet.ParameterSetName -eq 'AllowSubnet'   -and $Ip -match $matchAll   ) -or
                ($PSCmdlet.ParameterSetName -eq 'RequireSubnet' -and $Ip -match $matchAll   )
            )
        }
        catch
        {
            # If error was encountered inside this function then stop doing more
            # But still respect the ErrorAction that comes when calling this function
            # And also return the line number where the original error occured
            $msg = $_.ToString() + "`r`n" + $_.InvocationInfo.PositionMessage.ToString()
            Write-Verbose -Message "Encountered an error: $msg"
            Write-Error -ErrorAction $origErrorActionPreference -Exception $_.Exception -Message $msg
        }
        finally
        {
            $ErrorActionPreference = $origErrorActionPreference
        }

        Write-Verbose -Message 'Process end'
    }

    end
    {
        Write-Verbose -Message 'End'
    }
}
