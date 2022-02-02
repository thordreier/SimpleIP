function Test-IPv6AddressInSameNet
{
    <#
        .SYNOPSIS
            Test if two IP addresses are in the same subnet (IPv6)

        .DESCRIPTION
            Test if two IP addresses are in the same subnet (IPv6)

        .PARAMETER IP
            Input IP is standard IPv6 format with out prefix (eg. "a:b:00c::" or "a:b:00c::0/64")

        .PARAMETER IP2
            Same format as -IP

        .PARAMETER Prefix
            If prefix is not set in IP address, it must be set with this parameter

        .PARAMETER AllowPrefixMismatch
            Return true if hosts with the two IP addresses can communicate with each other directly
            (not routed), even if there's a mismatch in prefix between the two.

        .EXAMPLE
            Test-IPv6AddressInSameNet a:2::/31 a:3::/31
            True

        .EXAMPLE
            Test-IPv6AddressInSameNet a:2::/32 a:3::/32
            False

        .EXAMPLE
            Test-IPv6AddressInSameNet a:2::/31 a:3::/30
            False

        .EXAMPLE
            Test-IPv6AddressInSameNet a:2::/31 a:3::/32 -AllowPrefixMismatch
            False

        .EXAMPLE
            Test-IPv6AddressInSameNet a:2::/31 a:3::/30 -AllowPrefixMismatch
            True
    #>

    [OutputType([System.Boolean])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position=0)]
        [ValidateScript({ (Test-IPv6Address -IP $_ -AllowPrefix) -or $(throw "$_ is not a valid IPv6 address") })]
        [System.String]
        $IP,

        [Parameter(Mandatory = $true, Position=1)]
        [ValidateScript({ (Test-IPv6Address -IP $_ -AllowPrefix) -or $(throw "$_ is not a valid IPv6 address") })]
        [System.String]
        $IP2,

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
            $null = $PSBoundParameters.Remove('IP')
            $null = $PSBoundParameters.Remove('IP2')

            if (
                $Prefix -or
                ((Test-IPv6Address -IP $IP -RequirePrefix) -and (Test-IPv6Address -IP $IP2 -RequirePrefix))
            )
            {
                $info1 = Get-IPv6Address -Info -IP $IP @PSBoundParameters
                $info2 = Get-IPv6Address -Info -IP $IP2 @PSBoundParameters
            }
            elseif (Test-IPv6Address -IP $IP -RequirePrefix)
            {
                $info1 = Get-IPv6Address -Info -IP $IP @PSBoundParameters
                $null = $PSBoundParameters.Remove('Prefix')
                $info2 = Get-IPv6Address -Info -IP $IP2 -Prefix $info1.Prefix @PSBoundParameters
            }
            elseif (Test-IPv6Address -IP $IP2 -RequirePrefix)
            {
                $info2 = Get-IPv6Address -Info -IP $IP2 @PSBoundParameters
                $null = $PSBoundParameters.Remove('Prefix')
                $info1 = Get-IPv6Address -Info -IP $IP -Prefix $info2.Prefix @PSBoundParameters
            }
            else
            {
                throw "No prefix defined for either IP ($IP) or IP2 ($IP2), and -Prefix parameter is not set"
            }

            if ($info1.IP -eq $info2.IP)
            {
                "-IP and -IP2 is the same ($IP)" | Write-Warning
            }

            # Return
            ($info1.Subnet -eq $info2.Subnet -and $info1.Prefix -eq $info2.Prefix) -or
            (
                $AllowPrefixMismatch -and
                $info1.Objects.IP.IPBinary -ge $info2.Objects.FirstIP.IPBinary -and
                $info1.Objects.IP.IPBinary -le $info2.Objects.LastIP.IPBinary -and
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
