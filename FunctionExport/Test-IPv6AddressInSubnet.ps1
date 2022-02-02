function Test-IPv6AddressInSubnet
{
    <#
        .SYNOPSIS
            Test if two IP addresses are in the same subnet (IPv6)

        .DESCRIPTION
            Test if two IP addresses are in the same subnet (IPv6)

        .PARAMETER Subnet
            Input IP is standard IPv6 format with out prefix (eg. "a:b:00c::" or "a:b:00c::0/64")

        .PARAMETER IP
            Same format as -Subnet

        .PARAMETER Prefix
            If prefix is not set in subnet address, it must be set with this parameter

        .PARAMETER AllowPrefixMismatch
            Return true if hosts with the two IP addresses can communicate with each other directly
            (not routed), even if there's a mismatch in prefix between the two.

        .EXAMPLE
            Test-IPv6AddressInSubnet -Subnet a:2::/31 -IP a:3::/31
            True

        .EXAMPLE
            Test-IPv6AddressInSubnet -Subnet a:2::/32 -IP a:3::/32
            False

        .EXAMPLE
            Test-IPv6AddressInSubnet -Subnet a:2::/31 -IP a:3::/30
            False

        .EXAMPLE
            Test-IPv6AddressInSubnet -Subnet a:2::/32 -IP a:3::/31 -AllowPrefixMismatch
            False

        .EXAMPLE
            Test-IPv6AddressInSubnet -Subnet a:2::/31 -IP a:3::/32 -AllowPrefixMismatch
            True
    #>

    [OutputType([System.Boolean])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position=0)]
        [ValidateScript({ (Test-IPv6Address -IP $_ -AllowPrefix) -or $(throw "$_ is not a valid IPv6 address") })]
        [System.String]
        $Subnet,

        [Parameter(Mandatory = $true, Position=1)]
        [ValidateScript({ (Test-IPv6Address -IP $_ -AllowPrefix) -or $(throw "$_ is not a valid IPv6 address") })]
        [System.String]
        $IP,

        [Parameter()]
        [Nullable[System.Byte]]
        $Prefix,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AllowPrefixMismatch
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

            $null = $PSBoundParameters.Remove('AllowPrefixMismatch')
            $null = $PSBoundParameters.Remove('Subnet')
            $null = $PSBoundParameters.Remove('IP')

            if (-not (Test-IPv6Subnet -Subnet $Subnet @PSBoundParameters))
            {
                throw "$Subnet (prefix $Prefix) is not a subnet"
            }
            elseif (
                $Prefix -or
                ((Test-IPv6Address -IP $Subnet -RequirePrefix) -and (Test-IPv6Address -IP $IP -RequirePrefix))
            )
            {
                $info1 = Get-IPv6Address -Info -IP $Subnet @PSBoundParameters
                $info2 = Get-IPv6Address -Info -IP $IP @PSBoundParameters
            }
            elseif (Test-IPv6Address -IP $Subnet -RequirePrefix)
            {
                $info1 = Get-IPv6Address -Info -IP $Subnet @PSBoundParameters
                $null = $PSBoundParameters.Remove('Prefix')
                $info2 = Get-IPv6Address -Info -IP $IP -Prefix $info1.Prefix @PSBoundParameters
            }
            else
            {
                throw "No prefix defined for Subnet ($Subnet), and -Prefix parameter is not set"
            }

            if ($info1.IP -eq $info2.IP)
            {
                "-Subnet and -IP is the same ($IP)" | Write-Warning
            }

            # Return
            ($info1.Subnet -eq $info2.Subnet -and $info1.Prefix -eq $info2.Prefix) -or
            (
                $AllowPrefixMismatch -and
                $info2.Objects.IP.IPBinary -ge $info1.Objects.FirstIP.IPBinary -and
                $info2.Objects.IP.IPBinary -le $info1.Objects.LastIP.IPBinary
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
