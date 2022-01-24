function Test-ValidIPv4
{
    <#
        .SYNOPSIS
            Test if a string contains a valid IP address

        .DESCRIPTION
            Test if a string contains a valid IP address
            Uses regex to test
            Returns [bool]

        .PARAMETER IP
            IP address (or subnet mask) to test is valid or not

        .PARAMETER IPOnly
            Only return True if input is valid IPv4 in quad dot format (without subnet mask)
            Eg. "127.0.0.1"
            This is default

        .PARAMETER Mask
            Only return True if input is valid IPv4 subnet mask in quad dot format
            Eg. "255.255.255.0"

        .PARAMETER AllowLength
            Used along with -Mask
            Only return true if input is subnet mask in:
            - Quad dot format,        eg. "255.255.255.0"
            - Mask length (0-32),     eg. "24"
            - Mask length with slash, eg. "/24"

        .PARAMETER AllowMask
            Return true if input is either
            - IP in quad dot,        eg. "127.0.0.1"
            - IP + mask in quad dot, eg. "127.0.0.1 255.0.0.0"
            - IP + mask length,      eg. "127.0.0.1/8"

        .PARAMETER RequireMask
            Return true if input is IP with mask, either
            - IP + mask in quad dot, eg. "127.0.0.1 255.0.0.0"
            - IP + mask length,      eg. "127.0.0.1/8"

        .EXAMPLE
            Test-ValidIPv4 -IP 127.0.0.1
            True

        .EXAMPLE
            Test-ValidIPv4 -IP 127.0.0.256
            False

        .EXAMPLE
            Test-ValidIPv4 -IP 127.0.0.1/32
            False

        .EXAMPLE
            Test-ValidIPv4 -IP 127.0.0.1/32 -AllowMask
            True

        .EXAMPLE
            Test-ValidIPv4 -IP "127.0.0.1 255.255.255.255" -AllowMask
            True

        .EXAMPLE
            Test-ValidIPv4 -IP 127.0.0.1 -RequireMask
            False

        .EXAMPLE
            Test-ValidIPv4 -IP 255.255.0.0 -Mask
            True

        .EXAMPLE
            Test-ValidIPv4 -IP 255.0.255.0 -Mask
            False

        .EXAMPLE
            Test-ValidIPv4 -IP 32 -Mask
            False

        .EXAMPLE
            Test-ValidIPv4 -IP 32 -Mask -AllowLength
            True

        .EXAMPLE
            Test-ValidIPv4 -IP /32 -Mask -AllowLength
            True
    #>

    [OutputType([System.Boolean])]
    [CmdletBinding(DefaultParameterSetName = 'IPOnly')]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position=0)]
        [System.String]
        $IP,

        [Parameter(ParameterSetName = 'IPOnly')]
        [System.Management.Automation.SwitchParameter]
        $IPOnly,

        [Parameter(Mandatory = $true, ParameterSetName = 'Mask')]
        [System.Management.Automation.SwitchParameter]
        $Mask,

        [Parameter(ParameterSetName = 'Mask')]
        [System.Management.Automation.SwitchParameter]
        $AllowLength,

        [Parameter(Mandatory = $true, ParameterSetName = 'AllowMask')]
        [System.Management.Automation.SwitchParameter]
        $AllowMask,

        [Parameter(Mandatory = $true, ParameterSetName = 'RequireMask')]
        [System.Management.Automation.SwitchParameter]
        $RequireMask
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
            $matchIP            = "^($i)$"
            $matchMask          = "^($s)$"
            $matchMaskAndLength = "^(($s)|(/?($b)))$"
            $matchAll           = "^($i)[/ ](($s)|($b))$"

            (
                ($PSCmdlet.ParameterSetName -eq 'IPOnly'      -and $IP -match $matchIP                                  ) -or
                ($PSCmdlet.ParameterSetName -eq 'Mask'        -and $IP -match $matchMask          -and -not $AllowLength) -or
                ($PSCmdlet.ParameterSetName -eq 'Mask'        -and $IP -match $matchMaskAndLength -and      $AllowLength) -or
                ($PSCmdlet.ParameterSetName -eq 'AllowMask'   -and $IP -match $matchIP                                  ) -or
                ($PSCmdlet.ParameterSetName -eq 'AllowMask'   -and $IP -match $matchAll                                 ) -or
                ($PSCmdlet.ParameterSetName -eq 'RequireMask' -and $IP -match $matchAll                                 )
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
