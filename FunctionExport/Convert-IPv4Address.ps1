function Convert-IPv4Address
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

    [OutputType([System.String], ParameterSetName = 'Default')]
    [OutputType([System.UInt32], ParameterSetName = 'Integer')]
    [OutputType([System.String], ParameterSetName = 'Binary')]
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position=0)]
        [System.String]
        $Ip,

        [Parameter(Mandatory = $true, ParameterSetName = 'Integer')]
        [System.Management.Automation.SwitchParameter]
        $Integer,

        [Parameter(Mandatory = $true, ParameterSetName = 'Binary')]
        [System.Management.Automation.SwitchParameter]
        $Binary
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

            [System.UInt32] $i = 0
            if (Test-ValidIPv4 -Ip $Ip)
            {
                $Ip -split '\.' | ForEach-Object -Process {
                    $i = $i * 256 + $_
                }
            }
            elseif ($Ip -match '^[01]{32}$')
            {
                $i = [System.Convert]::ToUInt32($Ip, 2)
            }
            else
            {
                try
                {
                    $i = $Ip
                }
                catch
                {
                    throw "$Ip is not a valid IPv4 address"
                }
            }

            # Return
            if ($Integer)
            {
                $i
            }
            else
            {
                $b = [System.Convert]::ToString(([System.UInt32] $i), 2).PadLeft(32, '0')
                if ($Binary)
                {
                    $b
                }
                else
                {
                    (0..3 | ForEach-Object -Process {[System.Convert]::ToByte($b[(8*$_)..(8*$_+7)] -join '', 2)}) -join '.'
                }
            }
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
