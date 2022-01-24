function Get-IPv6Address
{
    <#
        .SYNOPSIS
            Get subnet, prefix, ... for an IPv6 address

        .DESCRIPTION
            Get subnet, prefix, ... for an IPv6 address

        .PARAMETER IP
            Input IP is standard IPv6 format with out prefix (eg. "a:b:00c::" or "a:b:00c::0/64")

        .PARAMETER Prefix
            If prefix is not set in IP address, it must be set with this parameter

        .PARAMETER Subnet
            Return subnet
            If input is "7:6:5::77:88/56", then "7:6:5::/56" is returned

        .PARAMETER WithPrefix
            Return in "7:6:5::/64" format
            This is default output

        .PARAMETER IPOnly
            Return in "7:6:5::" format

        .PARAMETER Info
            Return object with different info

        .EXAMPLE
            Get-IPv6Address -IP 7:6:5::77:88/64 -Subnet
            7:6:5::/64

        .EXAMPLE
            Get-IPv6Address -IP 7:6:5::77:88/64 -Info
            IP           : 7:6:5::77:88/64
            Subnet       : 7:6:5::/64
            FirstIP4Real : 7:6:5::/64
            FirstIP      : 7:6:5::1/64
            LastIP       : 7:6:5::ffff:ffff:ffff:fffe/64
            LastIP4Real  : 7:6:5::ffff:ffff:ffff:ffff/64
    #>

    [OutputType([System.String])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position=0)]
        [System.String]
        $IP,

        [Parameter()]
        [Nullable[System.Byte]]
        $Prefix,

        [Parameter(Mandatory = $true, ParameterSetName = 'SubnetWithPrefix')]
        [Parameter(Mandatory = $true, ParameterSetName = 'SubnetIPOnly')]
        [System.Management.Automation.SwitchParameter]
        $Subnet,

        #[Parameter(Mandatory = $true, ParameterSetName = 'BroadcastWithPrefix')]
        #[Parameter(Mandatory = $true, ParameterSetName = 'BroadcastIPOnly')]
        #[System.Management.Automation.SwitchParameter]
        #$Broadcast,

        #[Parameter(Mandatory = $true, ParameterSetName = 'FirstWithPrefix')]
        #[Parameter(Mandatory = $true, ParameterSetName = 'FirstIPOnly')]
        #[System.Management.Automation.SwitchParameter]
        #$First,

        #[Parameter(Mandatory = $true, ParameterSetName = 'LastWithPrefix')]
        #[Parameter(Mandatory = $true, ParameterSetName = 'LastIPOnly')]
        #[System.Management.Automation.SwitchParameter]
        #$Last,

        #[Parameter(Mandatory = $true, ParameterSetName = 'AllWithPrefix')]
        #[Parameter(Mandatory = $true, ParameterSetName = 'AllIPOnly')]
        #[System.Management.Automation.SwitchParameter]
        #$All,

        #[Parameter()]
        #[System.Management.Automation.SwitchParameter]
        #$Pool,

        [Parameter(ParameterSetName = 'SubnetWithPrefix')]
        #[Parameter(ParameterSetName = 'BroadcastWithPrefix')]
        #[Parameter(ParameterSetName = 'FirstWithPrefix')]
        #[Parameter(ParameterSetName = 'LastWithPrefix')]
        #[Parameter(ParameterSetName = 'AllWithPrefix')]
        [System.Management.Automation.SwitchParameter]
        $WithPrefix,

        [Parameter(Mandatory = $true, ParameterSetName = 'SubnetIPOnly')]
        #[Parameter(Mandatory = $true, ParameterSetName = 'BroadcastIPOnly')]
        #[Parameter(Mandatory = $true, ParameterSetName = 'FirstIPOnly')]
        #[Parameter(Mandatory = $true, ParameterSetName = 'LastIPOnly')]
        #[Parameter(Mandatory = $true, ParameterSetName = 'AllIPOnly')]
        [System.Management.Automation.SwitchParameter]
        $IPOnly,

        #[Parameter(Mandatory = $true, ParameterSetName = 'PrefixOnly')]
        #[System.Management.Automation.SwitchParameter]
        #$PrefixOnly,

        #[Parameter(Mandatory = $true, ParameterSetName = 'PrefixWithSlashOnly')]
        #[System.Management.Automation.SwitchParameter]
        #$PrefixWithSlashOnly,

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

            $prefixParam = if ($Prefix -eq $null) { @{} } else { @{Prefix = $Prefix} }
            $ipInfo = Convert-IPv6Address -Info -IP $IP @prefixParam

            if ($ipInfo.Prefix -eq $null) {throw "No prefix defined for $IP"}
            $Prefix = $ipInfo.Prefix

            # Yeah yeah, I know that there's now broadcast IP in IPv6 and that every IP can be used!
            [uint16[]] $ipInt        = $ipInfo.IPIntArray
            [uint16[]] $prefixInt    = $ipInfo.PrefixIntArray

            # Why the f**k does binary operators not work properly with uint16
            # For IPv4 it's just  "$ip -band $mask"  and  "$ip -bor (-bnot $mask)"
            [uint16[]] $subnetInt    = (0..7).ForEach({ [uint16] (([uint32]$ipInt[$_]) -band ([uint32]$prefixInt[$_])) })
            [uint16[]] $broadcastInt = (0..7).ForEach({ [uint16] ((([uint32]$ipInt[$_]) -bor (-bnot ([uint32]$prefixInt[$_]))) -band [uint16]::MaxValue)})
            [uint16[]] $firstInt     = $subnetInt.Clone()
            [uint16[]] $lastInt      = $broadcastInt.Clone()
            if ($Prefix -ne 128)
            {
                ++$firstInt[7]
                --$lastInt[7]
            }

            if ($Info)
            {
                [PSCustomObject] @{
                    IP           = Convert-IPv6Address -IP $ipInt        -Prefix $Prefix
                    Subnet       = Convert-IPv6Address -IP $subnetInt    -Prefix $Prefix
                    FirstIP4Real = Convert-IPv6Address -IP $subnetInt    -Prefix $Prefix
                    FirstIP      = Convert-IPv6Address -IP $firstInt     -Prefix $Prefix
                    LastIP       = Convert-IPv6Address -IP $lastInt      -Prefix $Prefix
                    LastIP4Real  = Convert-IPv6Address -IP $broadcastInt -Prefix $Prefix
                }
            }
            else
            {
                $createScript =
                    if     ($Subnet)    { {,@($subnetInt)} }
                    #elseif ($Broadcast) { {$broadcastInt} }
                    #elseif ($First)     { {$firstInt} }
                    #elseif ($Last)      { {$lastInt} }
                    #elseif ($All)       { {for ([uint32] $i = $firstInt; $i -le $lastInt; $i++) {$i}} }
                    #else                { {$ipInt} }
                    else                { throw 'Unknown error' }

                $outputScript =
                    if     ($IPOnly)              { {(Convert-IPv6Address -IP $_ -Prefix $Prefix -Info).IPCompact} }
                    #elseif ($PrefixOnly)          { {} }
                    #elseif ($PrefixWithSlashOnly) { {} }
                    else                          { {Convert-IPv6Address -IP $_ -Prefix $Prefix} }

                $createScript.Invoke() | ForEach-Object -Process $outputScript
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
