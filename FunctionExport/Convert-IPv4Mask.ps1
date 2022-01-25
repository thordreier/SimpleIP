function Convert-IPv4Mask
{
    <#
        .SYNOPSIS
            Convert IP subnet mask between different formats

        .DESCRIPTION
            Convert IP subnet mask between different formats
            - Quad dot                eg. "255.255.128.0"
            - Mask length (0-32)      eg. "17"
            - Mask length with slash  eg. "/17"
            - Integer (uint32)        eg. "4294934528"
            - Binary (32 long string) eg. "11111111111111111000000000000000"

            If input is in quad dot format ("255.0.0.0"), output defaults to mask length with a leading slash ("/8")
            - else output defaults to quad dot format
            Output can be forced to be in specific format with switches

        .PARAMETER Mask
            Input subnet mask is either:
            - Quad dot                eg. "255.255.128.0"
            - Mask length (0-32)      eg. "17"
            - Mask length with slash  eg. "/17"
            - Integer (uint32)        eg. "4294934528"
            - Binary (32 long string) eg. "11111111111111111000000000000000"

        .PARAMETER QuadDot
            Output in quad dot format, eg. "255.255.128.0"

        .PARAMETER Length
            Output is in mask length, eg "17"

        .PARAMETER LengthWithSlash
            Output is in mask length with leading slash, eg "/17"

        .PARAMETER Integer
            Output integer (uint32), eg 4294934528

        .PARAMETER Binary
            Output in binary (32 long string), eg. "11111111111111111000000000000000"

        .EXAMPLE
            Convert-IPv4Mask -Mask 255.255.128.0
            /17

        .EXAMPLE
            Convert-IPv4Mask -Mask /17 -Length
            17

        .EXAMPLE
            Convert-IPv4Mask -Mask /17
            255.255.128.0

        .EXAMPLE
            Convert-IPv4Mask -Mask 17
            255.255.128.0

        .EXAMPLE
            Convert-IPv4Mask -Mask 17 -Binary
            11111111111111111000000000000000
    #>

    [OutputType([System.String], ParameterSetName = 'Default')]
    [OutputType([System.String], ParameterSetName = 'QuadDot')]
    [OutputType([System.Byte]  , ParameterSetName = 'Length')]
    [OutputType([System.String], ParameterSetName = 'LengthWithSlash')]
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

        [Parameter(Mandatory = $true, ParameterSetName = 'Length')]
        [System.Management.Automation.SwitchParameter]
        $Length,

        [Parameter(Mandatory = $true, ParameterSetName = 'LengthWithSlash')]
        [System.Management.Automation.SwitchParameter]
        $LengthWithSlash,

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

                if (Test-ValidIPv4 -IP $Mask) {$quadDotInput = $true}
                $i = Convert-IPv4Address -IP $Mask -Integer
            }

            if (($output = $PSCmdlet.ParameterSetName) -eq 'Default')
            {
                $output = if ($quadDotInput) {'LengthWithSlash'} else {'QuadDot'}
            }

            # Return
            switch ($output)
            {
                'QuadDot'         {$i | Convert-IPv4Address}
                'Length'          {[System.Byte] [regex]::Matches(($i | Convert-IPv4Address -Binary), '1').Count}
                'LengthWithSlash' {'/' + [regex]::Matches(($i | Convert-IPv4Address -Binary), '1').Count}
                'Integer'         {$i}
                'Binary'          {$i | Convert-IPv4Address -Binary}
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
