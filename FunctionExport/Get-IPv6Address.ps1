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

        .PARAMETER SameIP
            Return same IP as input IP (why? maybe in a different format back)
            If input is "7:6:5::77:88/56", then "7:6:5::77:88/56" is returned

        .PARAMETER Subnet
            Return subnet
            If input is "7:6:5::77:88/56", then "7:6:5::/56" is returned

        .PARAMETER WithPrefix
            Return in "7:6:5::/64" format
            This is default output

        .PARAMETER IPOnly
            Return in "7:6:5::" format

        .PARAMETER PrefixOnly
            Only return prefix in "64" format

        .PARAMETER PrefixWithSlashOnly
            Only return prefix in "/64" format

        .PARAMETER Info
            Return object with different info

        .EXAMPLE
            Get-IPv6Address -IP 007:6:5::77:88/64 -Subnet
            7:6:5::/64

        .EXAMPLE
            Get-IPv6Address -IP 007:6:5::77:88/64 -Subnet -IPOnly
            7:6:5::

        .EXAMPLE
            Get-IPv6Address -IP 007:6:5::77:88/64 -IPOnly
            7:6:5::77:88

        .EXAMPLE
            Get-IPv6Address -IP 007:6:5::77:88/64 -Info
            IP            : 7:6:5::77:88/64
            Subnet        : 7:6:5::/64
            FirstIP       : 7:6:5::/64
            SecondIP      : 7:6:5::1/64
            PenultimateIP : 7:6:5::ffff:ffff:ffff:fffe/64
            LastIP        : 7:6:5::ffff:ffff:ffff:ffff/64
            Objects       : @{IP=; Subnet=; FirstIP=; SecondIP=; PenultimateIP=; LastIP=}
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

        [Parameter(ParameterSetName = 'SubnetWithPrefix')]
        [Parameter(ParameterSetName = 'SameIPIPOnly')]
        [System.Management.Automation.SwitchParameter]
        $SameIP,

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

        [Parameter(ParameterSetName = 'SameIPWithPrefix')]
        [Parameter(ParameterSetName = 'SubnetWithPrefix')]
        #[Parameter(ParameterSetName = 'BroadcastWithPrefix')]
        #[Parameter(ParameterSetName = 'FirstWithPrefix')]
        #[Parameter(ParameterSetName = 'LastWithPrefix')]
        #[Parameter(ParameterSetName = 'AllWithPrefix')]
        [System.Management.Automation.SwitchParameter]
        $WithPrefix,

        [Parameter(Mandatory = $true, ParameterSetName = 'SameIPIPOnly')]
        [Parameter(Mandatory = $true, ParameterSetName = 'SubnetIPOnly')]
        #[Parameter(Mandatory = $true, ParameterSetName = 'BroadcastIPOnly')]
        #[Parameter(Mandatory = $true, ParameterSetName = 'FirstIPOnly')]
        #[Parameter(Mandatory = $true, ParameterSetName = 'LastIPOnly')]
        #[Parameter(Mandatory = $true, ParameterSetName = 'AllIPOnly')]
        [System.Management.Automation.SwitchParameter]
        $IPOnly,

        [Parameter(Mandatory = $true, ParameterSetName = 'PrefixOnly')]
        [System.Management.Automation.SwitchParameter]
        $PrefixOnly,

        [Parameter(Mandatory = $true, ParameterSetName = 'PrefixWithSlashOnly')]
        [System.Management.Automation.SwitchParameter]
        $PrefixWithSlashOnly,

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
            [uint16[]] $subnetInt      = (0..7).ForEach({ [uint16] (([uint32]$ipInt[$_]) -band ([uint32]$prefixInt[$_])) })
            [uint16[]] $lastInt        = (0..7).ForEach({ [uint16] ((([uint32]$ipInt[$_]) -bor (-bnot ([uint32]$prefixInt[$_]))) -band [uint16]::MaxValue)})
            [uint16[]] $firstInt       = $subnetInt.Clone()
            [uint16[]] $secondInt      = $firstInt.Clone()
            [uint16[]] $penultimateInt = $lastInt.Clone()
            if ($Prefix -ne 128)
            {
                # FIXXXME - should we do something else if it's /128? Set to $null?
                ++$secondInt[7]
                --$penultimateInt[7]
            }

            if ($Info)
            {
                $objects = [PSCustomObject] @{
                    IP            = Convert-IPv6Address -IP $ipInt          -Prefix $Prefix -Info
                    Subnet        = Convert-IPv6Address -IP $subnetInt      -Prefix $Prefix -Info
                    FirstIP       = Convert-IPv6Address -IP $firstInt       -Prefix $Prefix -Info
                    SecondIP      = Convert-IPv6Address -IP $secondInt      -Prefix $Prefix -Info
                    PenultimateIP = Convert-IPv6Address -IP $penultimateInt -Prefix $Prefix -Info
                    LastIP        = Convert-IPv6Address -IP $lastInt        -Prefix $Prefix -Info
                }
                [PSCustomObject] @{
                    IP            = $objects.IP.IP
                    Subnet        = $objects.Subnet.IP
                    FirstIP       = $objects.FirstIP.IP
                    SecondIP      = $objects.SecondIP.IP
                    PenultimateIP = $objects.PenultimateIP.IP
                    LastIP        = $objects.LastIP.IP
                    Prefix        = $Prefix
                    Objects       = $objects
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
                    else                { {,@($ipInt)} }

                $outputScript =
                    if     ($IPOnly)              { {(Convert-IPv6Address -IP $_ -Prefix $Prefix -Info).IPCompact} }
                    elseif ($PrefixOnly)          { {'{0}' -f $Prefix} }
                    elseif ($PrefixWithSlashOnly) { {'/{0}' -f $Prefix} }
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
