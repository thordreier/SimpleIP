function Test-IPv6Subnet
{
    <#
        .SYNOPSIS
            Test if IP address is a valid subnet address (IPv6)

        .DESCRIPTION
            Test if IP address is a valid subnet address (IPv6)

        .PARAMETER Subnet
            Input IP is standard IPv6 format with out prefix (eg. "a:b:00c::" or "a:b:00c::0/64")

        .PARAMETER Prefix
            If prefix is not set in subnet address, it must be set with this parameter

        .EXAMPLE
            Test-IPv6Subnet -Subnet a:0:0:b::/64
            True

        .EXAMPLE
            Test-IPv6Subnet -Subnet a:0:0:0:b::/64
            False
    #>

    [OutputType([System.Boolean])]
    [CmdletBinding(DefaultParameterSetName = 'IPOnly')]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position=0)]
        [System.String]
        $Subnet,

        [Parameter()]
        [System.String]
        $Prefix = ''
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

            $null = $PSBoundParameters.Remove('Subnet')
            $info = Get-IPv6Address -Info -IP $Subnet @PSBoundParameters
            
            # Return
            $info.IP -eq $info.Subnet
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
