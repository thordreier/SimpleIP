function Get-IPv4Address
{
    <#
        .SYNOPSIS
            Get IP subnet, mask, broadcast for an IP address

        .DESCRIPTION
            Get IP subnet, mask, broadcast for an IP address

        .PARAMETER IP
            Input IP in quad dot format with subnet mask, either:
            - IP + mask in quad dot, eg. "127.0.0.1 255.0.0.0"
            - IP + mask length,      eg. "127.0.0.1/8"
            If input is IP without subnet mask (eg. "127.0.0.1") then -Mask parameter must be set

        .PARAMETER Mask
            If input IP is in format without subnet mask, this parameter must be set to either
            - Quad dot format,        eg. "255.255.255.0"
            - Mask length (0-32),     eg. "24"
            - Mask length with slash, eg. "/24"

        .PARAMETER SameIP
            Return same IP as input IP (why? maybe in a different format back)
            If input is "10.11.12.13/24", then "10.11.12.13/24" is returned

        .PARAMETER Subnet
            Return subnet
            If input is "10.11.12.13/24", then "10.11.12.0/24" is returned

        .PARAMETER Broadcast
            Return broadcast
            If input is "10.11.12.13/24", then "10.11.12.255/24" is returned

        .PARAMETER First
            Return first usable IP in subnet
            If input is "10.11.12.13/24", then "10.11.12.1/24" is returned

        .PARAMETER Last
            Return last usable IP in subnet
            If input is "10.11.12.13/24", then "10.11.12.254/24" is returned

        .PARAMETER All
            Return all usable IPs in subnet
            If input is "10.11.12.13/24", then an array with IP addresses from "10.11.12.1/24" to "10.11.12.254/24" is returned

        .PARAMETER Pool
            Treat subnet and broadcast adddresses as usable
            First IP will be same as subnet and last IP will be the same as broadcast

        .PARAMETER WithMaskLength
            Return in "127.0.0.1/8" format
            This is default output

        .PARAMETER WithMask
            Return in "127.0.0.1 255.0.0.0" format

        .PARAMETER IPOnly
            Return in "127.0.0.1" format

        .PARAMETER MaskQuadDotOnly
            Only return subnet mask in "255.0.0.0" format

        .PARAMETER MaskLengthOnly
            Only return subnet mask in "8" format

        .PARAMETER MaskLengthWithSlashOnly
            Only return subnet mask in "/8" format

        .PARAMETER Info
            Return object with different info

        .EXAMPLE
            Get-IPv4Address -IP 127.0.0.1/8 -Subnet
            127.0.0.0/24

        .EXAMPLE
            Get-IPv4Address -IP 127.0.0.1/8 -Subnet -WithMask
            127.0.0.0 255.0.0.0

        .EXAMPLE
            Get-IPv4Address -IP 127.0.0.1/8 -Broadcast -WithMask
            127.255.255.255 255.0.0.0

        .EXAMPLE
            Get-IPv4Address -IP 127.0.0.1/8 -Broadcast -IPOnly
            127.255.255.255

        .EXAMPLE
            Get-IPv4Address -IP 10.100.200.201 -Mask /30 -All -WithMask
            10.100.200.201 255.255.255.252
            10.100.200.202 255.255.255.252

        .EXAMPLE
            Get-IPv4Address -IP 192.168.0.150/255.255.255.128 -Info
            IP          : 192.168.0.150
            Subnet      : 192.168.0.128
            FirstIP     : 192.168.0.129
            LastIP      : 192.168.0.254
            Broadcast   : 192.168.0.255
            Integer     : @{IP=3232235670; Subnet=3232235648; FirstIP=3232235...
            Binary      : @{IP=11000000101010000000000010010110; Subnet=11000...
            MaskQuadDot : 255.255.255.128
            MaskLength  : 25
    #>

    [OutputType([System.String])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position=0)]
        [ValidateScript({ (Test-IPv4Address -IP $_ -AllowMask) -or $(throw "$_ is not a valid IPv4 address") })]
        [System.String]
        $IP,

        [Parameter()]
        [ValidateScript({ (Test-IPv4Address -IP $_ -Mask -AllowLength) -or $(throw "$_ is not a valid IPv4 mask") })]
        [System.String]
        $Mask = '',

        [Parameter(ParameterSetName = 'SameIPWithMaskLength')]
        [Parameter(ParameterSetName = 'SameIPWithMask')]
        [Parameter(ParameterSetName = 'SameIPIPOnly')]
        [System.Management.Automation.SwitchParameter]
        $SameIP,

        [Parameter(Mandatory = $true, ParameterSetName = 'SubnetWithMaskLength')]
        [Parameter(Mandatory = $true, ParameterSetName = 'SubnetWithMask')]
        [Parameter(Mandatory = $true, ParameterSetName = 'SubnetIPOnly')]
        [System.Management.Automation.SwitchParameter]
        $Subnet,

        [Parameter(Mandatory = $true, ParameterSetName = 'BroadcastWithMaskLength')]
        [Parameter(Mandatory = $true, ParameterSetName = 'BroadcastWithMask')]
        [Parameter(Mandatory = $true, ParameterSetName = 'BroadcastIPOnly')]
        [System.Management.Automation.SwitchParameter]
        $Broadcast,

        [Parameter(Mandatory = $true, ParameterSetName = 'FirstWithMaskLength')]
        [Parameter(Mandatory = $true, ParameterSetName = 'FirstWithMask')]
        [Parameter(Mandatory = $true, ParameterSetName = 'FirstIPOnly')]
        [System.Management.Automation.SwitchParameter]
        $First,

        [Parameter(Mandatory = $true, ParameterSetName = 'LastWithMaskLength')]
        [Parameter(Mandatory = $true, ParameterSetName = 'LastWithMask')]
        [Parameter(Mandatory = $true, ParameterSetName = 'LastIPOnly')]
        [System.Management.Automation.SwitchParameter]
        $Last,

        [Parameter(Mandatory = $true, ParameterSetName = 'AllWithMaskLength')]
        [Parameter(Mandatory = $true, ParameterSetName = 'AllWithMask')]
        [Parameter(Mandatory = $true, ParameterSetName = 'AllIPOnly')]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Pool,

        [Parameter(ParameterSetName = 'SameIPWithMaskLength')]
        [Parameter(ParameterSetName = 'SubnetWithMaskLength')]
        [Parameter(ParameterSetName = 'BroadcastWithMaskLength')]
        [Parameter(ParameterSetName = 'FirstWithMaskLength')]
        [Parameter(ParameterSetName = 'LastWithMaskLength')]
        [Parameter(ParameterSetName = 'AllWithMaskLength')]
        [System.Management.Automation.SwitchParameter]
        $WithMaskLength,

        [Parameter(Mandatory = $true, ParameterSetName = 'SameIPWithMask')]
        [Parameter(Mandatory = $true, ParameterSetName = 'SubnetWithMask')]
        [Parameter(Mandatory = $true, ParameterSetName = 'BroadcastWithMask')]
        [Parameter(Mandatory = $true, ParameterSetName = 'FirstWithMask')]
        [Parameter(Mandatory = $true, ParameterSetName = 'LastWithMask')]
        [Parameter(Mandatory = $true, ParameterSetName = 'AllWithMask')]
        [System.Management.Automation.SwitchParameter]
        $WithMask,

        [Parameter(Mandatory = $true, ParameterSetName = 'SameIPIPOnly')]
        [Parameter(Mandatory = $true, ParameterSetName = 'SubnetIPOnly')]
        [Parameter(Mandatory = $true, ParameterSetName = 'BroadcastIPOnly')]
        [Parameter(Mandatory = $true, ParameterSetName = 'FirstIPOnly')]
        [Parameter(Mandatory = $true, ParameterSetName = 'LastIPOnly')]
        [Parameter(Mandatory = $true, ParameterSetName = 'AllIPOnly')]
        [System.Management.Automation.SwitchParameter]
        $IPOnly,

        [Parameter(Mandatory = $true, ParameterSetName = 'MaskQuadDotOnly')]
        [System.Management.Automation.SwitchParameter]
        $MaskQuadDotOnly,

        [Parameter(Mandatory = $true, ParameterSetName = 'MaskLengthOnly')]
        [System.Management.Automation.SwitchParameter]
        $MaskLengthOnly,

        [Parameter(Mandatory = $true, ParameterSetName = 'MaskLengthWithSlashOnly')]
        [System.Management.Automation.SwitchParameter]
        $MaskLengthWithSlashOnly,

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

            if ($Mask -eq '')
            {
                if (Test-IPv4Address -IP $IP) {throw "No mask defined for $IP"}
            }
            else
            {
                $Mask = $Mask | Convert-IPv4Mask -Length
            }

            if (-not (Test-IPv4Address -IP $IP))
            {
                ($IP, $m) = $IP -split '[/ ]'
                $m = $m | Convert-IPv4Mask -Length
                if ($Mask -eq '')
                {
                    $Mask = $m
                }
                elseif ($Mask -ne $m)
                {
                    "Mask set to /$m in -IP but /$Mask in -Mask for $IP. Using /$Mask" | Write-Warning
                }
            }

            [System.String] $maskQuadDot  = $Mask | Convert-IPv4Mask -QuadDot
            [System.UInt32] $maskInt      = $Mask | Convert-IPv4Mask -Integer
            [System.UInt32] $ipInt        = $IP | Convert-IPv4Address -Integer
            [System.UInt32] $subnetInt    = $ipInt -band $maskInt
            [System.UInt32] $broadcastInt = $ipInt -bor (-bnot $maskInt)
            [System.UInt32] $firstInt     = $subnetInt
            [System.UInt32] $lastInt      = $broadcastInt
            if (-not ($Pool -or $Mask -eq 31 -or $Mask -eq 32))
            {
                ++$firstInt
                --$lastInt
            }

            if ($Info)
            {
                [PSCustomObject] @{
                    IP          = $ipInt        | Convert-IPv4Address
                    Subnet      = $subnetInt    | Convert-IPv4Address
                    FirstIP     = $firstInt     | Convert-IPv4Address
                    LastIP      = $lastInt      | Convert-IPv4Address
                    Broadcast   = $broadcastInt | Convert-IPv4Address
                    Integer     = [PSCustomObject] @{
                        IP          = $ipInt
                        Subnet      = $subnetInt
                        FirstIP     = $firstInt
                        LastIP      = $lastInt
                        Broadcast   = $broadcastInt
                    }
                    Binary     = [PSCustomObject] @{
                        IP          = $ipInt        | Convert-IPv4Address -Binary
                        Subnet      = $subnetInt    | Convert-IPv4Address -Binary
                        FirstIP     = $firstInt     | Convert-IPv4Address -Binary
                        LastIP      = $lastInt      | Convert-IPv4Address -Binary
                        Broadcast   = $broadcastInt | Convert-IPv4Address -Binary
                    }
                    MaskQuadDot = $maskQuadDot
                    MaskLength  = $Mask
                }
            }
            else
            {
                $createScript =
                    if     ($Subnet)    { {$subnetInt} }
                    elseif ($Broadcast) { {$broadcastInt} }
                    elseif ($First)     { {$firstInt} }
                    elseif ($Last)      { {$lastInt} }
                    elseif ($All)       { {for ([uint32] $i = $firstInt; $i -le $lastInt; $i++) {$i}} }
                    else                { {$ipInt} }

                $outputScript =
                    if     ($WithMask)                { {'{0} {1}' -f $_, $maskQuadDot} }
                    elseif ($IPOnly)                  { {$_} }
                    elseif ($MaskQuadDotOnly)         { {$maskQuadDot} }
                    elseif ($MaskLengthOnly)          { {$Mask} }
                    elseif ($MaskLengthWithSlashOnly) { {'/{0}' -f $Mask} }
                    else                              { {'{0}/{1}' -f $_, $Mask} }

                $createScript.Invoke() | Convert-IPv4Address | ForEach-Object -Process $outputScript
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
