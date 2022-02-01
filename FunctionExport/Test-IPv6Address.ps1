function Test-IPv6Address
{
    <#
        .SYNOPSIS
            Test if a string contains a valid IP address (IPv6)

        .DESCRIPTION
            Test if a string contains a valid IP address (IPv6)
            Returns [bool]

        .PARAMETER IP
            IP address to test is valid or not

        .PARAMETER IPOnly
            Only return True if input is valid IPv6 address (without prefix)
            Eg. "a:b::c"
            This is default

        .PARAMETER AllowPrefix
            Return true if input valid IPv6 address with or without prefix
            Eg. "a:b::c" or "a:b::c/64"

        .PARAMETER RequirePrefix
            Return true if input valid IPv6 address with prefix
            Eg. "a:b::c/64"

        .EXAMPLE
            Test-IPv6Address -IP a:b::c
            True

        .EXAMPLE
            Test-IPv6Address -IP a:b::c/64
            False

        .EXAMPLE
            Test-IPv6Address -IP a:b::x
            False

        .EXAMPLE
            Test-IPv6Address -IP a:b::c/64
            False

        .EXAMPLE
            Test-IPv6Address -AllowPrefix -IP a:b::c/64
            True

        .EXAMPLE
            Test-IPv6Address -AllowPrefix -IP a:b::c
            True

        .EXAMPLE
            Test-IPv6Address -AllowPrefix -IP a:b::x/64
            False

        .EXAMPLE
            Test-IPv6Address -RequirePrefix -IP a:b::c/64
            True

        .EXAMPLE
            Test-IPv6Address -RequirePrefix -IP a:b::c
            False
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

        [Parameter(Mandatory = $true, ParameterSetName = 'AllowPrefix')]
        [System.Management.Automation.SwitchParameter]
        $AllowPrefix,

        [Parameter(Mandatory = $true, ParameterSetName = 'RequirePrefix')]
        [System.Management.Automation.SwitchParameter]
        $RequirePrefix
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

            # RegEx for IPv6 is just %&(%&¤&(=)%&/%&¤
            # We just try to parse it instead - and don't do RegEx match as we do with IPv4!
            # And yes - there's probably lot's of weird IPv6 syntaxes that doesn't work with this!

            $ipObject = Convert-IPv6Address -IP $IP -Info

            # Return
            ($PSCmdlet.ParameterSetName -eq 'IPOnly'        -and $ipObject.Prefix -eq $null) -or
            ($PSCmdlet.ParameterSetName -eq 'RequirePrefix' -and $ipObject.Prefix -ne $null) -or
            ($PSCmdlet.ParameterSetName -eq 'AllowPrefix')
        }
        catch
        {
            # Never throw, just return false
            $false
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
