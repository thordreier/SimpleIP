function Test-IPv4Subnet
{
    <#
        .SYNOPSIS
            Test if IP address is a valid subnet address

        .DESCRIPTION
            Test if IP address is a valid subnet address

        .PARAMETER Subnet
            Input IP in quad dot format with subnet mask, either:
            - IP + mask in quad dot, eg. "127.0.0.0 255.0.0.0"
            - IP + mask length,      eg. "127.0.0.0/8"
            If input is IP without subnet mask (eg. "127.0.0.0") then -Mask parameter must be set

        .PARAMETER Mask
            If input IP is in format without subnet mask, this parameter must be set to either
            - Quad dot format,        eg. "255.255.255.0"
            - Mask length (0-32),     eg. "24"
            - Mask length with slash, eg. "/24"

        .EXAMPLE
            Test-IPv4Subnet -Subnet 10.20.30.0/24
            True

        .EXAMPLE
            Test-IPv4Subnet -Subnet 10.20.30.0/255.255.0.0
            True
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
        $Mask = ''
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
            $info = Get-IPv4Address -Info -IP $Subnet @PSBoundParameters
            
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
