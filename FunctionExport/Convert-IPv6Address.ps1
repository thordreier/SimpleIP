function Convert-IPv6Address
{
    <#
        .SYNOPSIS
            Convert IPv6 address between formats

        .DESCRIPTION
            Convert IPv6 address between formats
            Also compress/compact IPv6 address.
            (IPv6 addresses can be hard to compare ("0::1" -eq "::1"),
            but they are run throug this command, they can be compared)
            Output defaults to compacted IPv6 address (eg. "::1")

        .PARAMETER IP
            Input IP is either
            - Standard IPv6 format with out prefix (eg. "a:b:00c::" or "a:b:00c::0/64")
            - [uint16[]] array with  8 elements
            - Binary (string containinging 128 "0" or "1" - spaces are allowed)

        .PARAMETER Prefix
            If prefix is not set in IP address, it must be set with this parameter

        .PARAMETER Info
            Output object with IP and prefix in different formats

        .EXAMPLE
            Convert-IPv6Address 00ab:00:0:000:00:fff::1
            ab::fff:0:1

        .EXAMPLE
            Convert-IPv6Address 00ab:00:0:000:00:fff::1/64
            ab::fff:0:1/64

        .EXAMPLE
            Convert-IPv6Address -IP a:b:c::/64 -Info
            IP                      : a:b:c::/64
            IPCompact               : a:b:c::
            IPExpanded              : 000a:000b:000c:0000:0000:0000:0000:0000
            IPIntArray              : {10, 11, 12, 0...}
            IPHexArray              : {a, b, c, 0...}
            IPHexArrayExpanded      : {000a, 000b, 000c, 0000...}
            IPBinary                : 0000000000001010 0000000000001011 0000000000001100 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000
            Cidr                    : a:b:c::/64
            CidrExpanded            : 000a:000b:000c:0000:0000:0000:0000:0000/64
            Prefix                  : 64
            PrefixIntArray          : {65535, 65535, 65535, 65535...}
            PrefixHexArray          : {ffff, ffff, ffff, ffff...}
            PrefixHexArrayExpanded  : {ffff, ffff, ffff, ffff...}
            PrefixHexString         : ffff:ffff:ffff:ffff:0:0:0:0
            PrefixHexStringExpanded : ffff:ffff:ffff:ffff:0000:0000:0000:0000
            PrefixBinary            : 1111111111111111 1111111111111111 1111111111111111 1111111111111111 0000000000000000 0000000000000000 0000000000000000 0000000000000000
    #>

    [OutputType([System.String],  ParameterSetName = 'Default')]
    [OutputType([PSCustomObject], ParameterSetName = 'Info')]
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position=0)]
        [System.Object]
        $IP,

        [Parameter()]
        [Nullable[System.Byte]]
        $Prefix,

        [Parameter(Mandatory = $true, ParameterSetName = 'Info')]
        [System.Management.Automation.SwitchParameter]
        $Info
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

            if ($Prefix -ne $null -and $Prefix -gt 128) {throw 'Prefix is higher than 128'}

            [System.UInt16[]] $ipIntArray = @()

            if ($IP -is [System.String] -and ($nospaceIP = $IP -replace ' ') -and $nospaceIP -match '^[01]{128}$')
            {
                $ipIntArray = (0..7).ForEach({ [System.Convert]::ToUInt16($nospaceIP.Substring(($_*16), 16), 2) })
            }
            elseif ($IP -is [System.String])
            {
                if (-not ($IP -match '^([0-9a-f:]+)(/(([1-9]?[0-9])|(1[01][0-9])|(12[0-8])))?$')) {throw "Error parsing IPv6 address $IP"}
                $ipOnly = $Matches[1]
                if ($Prefix -eq $null)
                {
                    $Prefix = $Matches[3]
                }
                elseif ($Matches[3] -ne $null -and $Prefix -ne $Matches[3])
                {
                    "Prefix set to /$($Matches[3]) in -IP but /$Prefix in -Prefix for $IP. Using /$Prefix" | Write-Warning
                }

                try
                {
                    if (
                        $ipOnly -match '[^0-9a-f:]' -or  # Something else than hex or colon
                        $ipOnly -match '::.+::' -or      # two double colon
                        $ipOnly -match ':::' -or         # tripple colon
                        $ipOnly -match '^:[^:]' -or      # start with single colon
                        $ipOnly -match '[^:]:$'          # end with single colon
                    ) {throw}
                    $ipOnly = $ipOnly -replace '::',':*:'
                    $ipSplit = $ipOnly -split ':'| Where-Object -FilterScript {$_ -ne ''}
                    if ($ipSplit.Count -gt 8) {throw}
                    $ipIntArray = $ipSplit | ForEach-Object -Process {
                        if ($_ -eq '*') { [System.UInt16[]] (@(0) * (9 - $ipSplit.Count)) }
                        else            { [System.Convert]::ToUInt16($_, 16)              }
                    }
                    if ($ipIntArray.Count -ne 8) {throw}
                }
                catch
                {
                    throw "Error parsing IPv6 address $IP"
                }
            }
            elseif ($IP -is [array] -and $IP.Count -eq 8)
            {
                try { $ipIntArray = $IP } catch { throw 'Input IP is in unknown format' }
            }
            else
            {
                throw 'Input IP is in unknown format'
            }


            $cidr = $cidrExpanded = $prefixIntArray = $prefixHexArray = $prefixHexArrayExpanded = $prefixHexString = $prefixHexStringExpanded = $prefixBinary = $null
            $ipHexArrayExpanded = $ipIntArray | ForEach-Object -Process { '{0:x4}' -f $_ }
            $ipHexArray         = $ipIntArray | ForEach-Object -Process { '{0:x}'  -f $_ }
            $ipExpanded         = $ipHexArrayExpanded -join ':'
            $ipCompact          = $ipHexArray -join ':'
            foreach ($i in (7..0)) { if ($ipCompact -ne ($ipCompact = $ipCompact -replace "(^|:)0(:0){$i}(:|`$)",'::')) {break} }
            $ipReturn           = $ipCompact
            $ipBinary = ($ipIntArray | ForEach-Object -Process {[System.Convert]::ToString(([System.UInt16] $_), 2).PadLeft(16, '0')}) -join ' '

            if ($Prefix -ne $null)
            {
                $ipReturn = $cidr        = '{0}/{1}' -f $ipCompact, $Prefix
                $cidrExpanded            = '{0}/{1}' -f $ipExpanded, $Prefix
                $prefixBinary            = '1' * $Prefix + '0' * (128 - $Prefix)
                $prefixIntArray          = (0..7).ForEach({ [System.Convert]::ToUInt16($prefixBinary.Substring(($_*16), 16), 2) })
                $prefixHexArrayExpanded  = $prefixIntArray | ForEach-Object -Process { '{0:x4}' -f $_ }
                $prefixHexArray          = $prefixIntArray | ForEach-Object -Process { '{0:x}'  -f $_ }
                $prefixHexString         = $prefixHexArray -join ':'
                $prefixHexStringExpanded = $prefixHexArrayExpanded -join ':'
                $prefixBinary            = ($prefixIntArray | ForEach-Object -Process {[System.Convert]::ToString(([System.UInt16] $_), 2).PadLeft(16, '0')}) -join ' '
            }

            $r = [PSCustomObject] @{
                IP                      = $ipReturn
                IPCompact               = $ipCompact
                IPExpanded              = $ipExpanded
                IPIntArray              = $ipIntArray
                IPHexArray              = $ipHexArray
                IPHexArrayExpanded      = $ipHexArrayExpanded
                IPBinary                = $ipBinary
                Cidr                    = $cidr
                CidrExpanded            = $cidrExpanded
                Prefix                  = $Prefix
                PrefixIntArray          = $prefixIntArray
                PrefixHexArray          = $prefixHexArray
                PrefixHexArrayExpanded  = $prefixHexArrayExpanded
                PrefixHexString         = $prefixHexString
                PrefixHexStringExpanded = $prefixHexStringExpanded
                PrefixBinary            = $prefixBinary
            }

            # Return
            if ($Info) { $r    }
            else       { $r.IP }
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
