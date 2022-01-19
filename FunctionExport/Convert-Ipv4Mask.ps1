function Convert-Ipv4Mask
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
    [OutputType([System.String], ParameterSetName = 'QuadDot')]
    [OutputType([System.Byte]  , ParameterSetName = 'Bits')]
    [OutputType([System.String], ParameterSetName = 'BitsWithSlash')]
    [OutputType([System.UInt32], ParameterSetName = 'Integer')]
    [OutputType([System.String], ParameterSetName = 'Binary')]

    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position=0)]
        [System.String]
        $Mask,

        [Parameter(Mandatory = $true, ParameterSetName = 'QuadDot')]
        [System.Management.Automation.SwitchParameter]
        $QuadDot,

        [Parameter(Mandatory = $true, ParameterSetName = 'Bits')]
        [System.Management.Automation.SwitchParameter]
        $Bits,

        [Parameter(Mandatory = $true, ParameterSetName = 'BitsWithSlash')]
        [System.Management.Automation.SwitchParameter]
        $BitsWithSlash,

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

            $quadDotInput = $false
            [System.UInt32] $i = 0
            if ($Mask -match '^/?([0-9]|[12][0-9]|3[0-2])$')
            {
                $i = [System.Convert]::ToUInt32(('1' * $Matches[1] + '0' * (32 - $Matches[1])), 2)
            }
            else
            {
                try
                {
                    if (-not ($Mask | Convert-IPv4Address | Test-ValidIPv4 -Mask)) {throw}
                }
                catch
                {
                    throw "$Mask is not a valid subnet mask"
                }

                if (Test-ValidIPv4 -Ip $Mask) {$quadDotInput = $true}
                $i = Convert-IPv4Address -Ip $Mask -Integer
            }

            if (($output = $PSCmdlet.ParameterSetName) -eq 'Default')
            {
                $output = if ($quadDotInput) {'BitsWithSlash'} else {'QuadDot'}
            }

            # Return
            switch ($output)
            {
                'QuadDot'       {$i | Convert-IPv4Address}
                'Bits'          {[System.Byte] [regex]::Matches(($i | Convert-IPv4Address -Binary), '1').Count}
                'BitsWithSlash' {'/' + [regex]::Matches(($i | Convert-IPv4Address -Binary), '1').Count}
                'Integer'       {$i}
                'Binary'        {$i | Convert-IPv4Address -Binary}
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
