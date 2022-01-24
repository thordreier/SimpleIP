function Convert-IPv4Address
{
    <#
        .SYNOPSIS
            Convert IP address between formats

        .DESCRIPTION
            Convert IP address between formats

        .PARAMETER IP
            Input IP is either:
            - Quad dot (without mask) eg. "192.168.1.2"
            - Integer (uint32)        eg. 3232235778
            - Binary (32 long string) eg. "11000000101010000000000100000010"

        .PARAMETER QuadDot
            Output in quad dot format, eg. "192.168.1.2"
            This is default output

        .PARAMETER Integer
            Output integer (uint32), eg 3232235778

        .PARAMETER Binary
            Output in binary (32 long string), eg. "11000000101010000000000100000010"

        .EXAMPLE
            Convert-IPv4Address -IP 192.168.1.2 -Integer
            3232235778

        .EXAMPLE
            Convert-IPv4Address -IP 192.168.1.2 -Binary
            11000000101010000000000100000010

        .EXAMPLE
            Convert-IPv4Address -IP 11000000101010000000000100000010 -QuadDot
            192.168.1.2

        .EXAMPLE
            3232235778 | Convert-IPv4Address
            192.168.1.2
    #>

    [OutputType([System.String], ParameterSetName = 'QuadDot')]
    [OutputType([System.UInt32], ParameterSetName = 'Integer')]
    [OutputType([System.String], ParameterSetName = 'Binary')]
    [CmdletBinding(DefaultParameterSetName = 'QuadDot')]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position=0)]
        [System.String]
        $IP,

        [Parameter(ParameterSetName = 'QuadDot')]
        [System.Management.Automation.SwitchParameter]
        $QuadDot,

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
            if (Test-ValidIPv4 -IP $IP)
            {
                $IP -split '\.' | ForEach-Object -Process {
                    $i = $i * 256 + $_
                }
            }
            elseif ($IP -match '^[01]{32}$')
            {
                $i = [System.Convert]::ToUInt32($IP, 2)
            }
            else
            {
                try
                {
                    $i = $IP
                }
                catch
                {
                    throw "$IP is not a valid IPv4 address"
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
