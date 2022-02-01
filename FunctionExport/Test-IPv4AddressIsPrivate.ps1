function Test-IPv4AddressIsPrivate
{
    <#
        .SYNOPSIS
            Test if IP address is in a private segment

        .DESCRIPTION
            Test if IP address is in a private segment

        .PARAMETER IP
            Input IP in quad dot format with or without subnet mask

        .PARAMETER xxx
            xxx

        .EXAMPLE
            xxx
    #>

    [OutputType([System.Boolean])]
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param
    (
        [Parameter(Mandatory = $true, Position=1)]
        [ValidateScript({ (Test-IPv4Address -IP $_ -AllowMask) -or $(throw "$_ is not a valid IPv4 address") })]
        [System.String]
        $IP,

        [Parameter(Mandatory = $true, ParameterSetName = 'Rfc1918')]
        [System.Management.Automation.SwitchParameter]
        $Rfc1918,

        [Parameter(Mandatory = $true, ParameterSetName = 'Rfc6598')]
        [System.Management.Automation.SwitchParameter]
        $Rfc6598
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

            $subnets = @()
            if ($PSCmdlet.ParameterSetName -in 'Default','Rfc1918')
            {
                $subnets += '10.0.0.0/8','172.16.0.0/12','192.168.0.0/16'
            }

            if ($PSCmdlet.ParameterSetName -in 'Default','Rfc6598')
            {
                $subnets += '100.64.0.0/10'
            }

            $return = $false

            foreach ($subnet in $subnets)
            {
                if (Test-IPv4AddressInSubnet -Subnet $subnet -IP $IP -AllowMaskMismatch -WarningAction SilentlyContinue)
                {
                    $return = $true
                    break
                }
            }

            # Return
            $return
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
