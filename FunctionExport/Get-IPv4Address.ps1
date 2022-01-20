function Get-IPv4Address
{
    <#
        .SYNOPSIS
            xxx

        .DESCRIPTION
            xxx

        .PARAMETER xxx
            xxx

        .EXAMPLE
            xxx
    #>

    [OutputType([System.String])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position=0)]
        [ValidateScript({ (Test-ValidIPv4 -Ip $_ -AllowMask) -or $(throw "$_ is not a valid IPv4 address") })]
        [System.String]
        $Ip,

        [Parameter()]
        [ValidateScript({ (Test-ValidIPv4 -Ip $_ -Mask -AllowLength) -or $(throw "$_ is not a valid IPv4 mask") })]
        [System.String]
        $Mask = '',

        [Parameter(Mandatory = $true, ParameterSetName = 'SubnetWithMaskLength')]
        [Parameter(Mandatory = $true, ParameterSetName = 'SubnetWithMask')]
        [Parameter(Mandatory = $true, ParameterSetName = 'SubnetIpOnly')]
        [System.Management.Automation.SwitchParameter]
        $Subnet,

        [Parameter(Mandatory = $true, ParameterSetName = 'BroadcastWithMaskLength')]
        [Parameter(Mandatory = $true, ParameterSetName = 'BroadcastWithMask')]
        [Parameter(Mandatory = $true, ParameterSetName = 'BroadcastIpOnly')]
        [System.Management.Automation.SwitchParameter]
        $Broadcast,

        [Parameter(Mandatory = $true, ParameterSetName = 'FirstWithMaskLength')]
        [Parameter(Mandatory = $true, ParameterSetName = 'FirstWithMask')]
        [Parameter(Mandatory = $true, ParameterSetName = 'FirstIpOnly')]
        [System.Management.Automation.SwitchParameter]
        $First,

        [Parameter(Mandatory = $true, ParameterSetName = 'LastWithMaskLength')]
        [Parameter(Mandatory = $true, ParameterSetName = 'LastWithMask')]
        [Parameter(Mandatory = $true, ParameterSetName = 'LastIpOnly')]
        [System.Management.Automation.SwitchParameter]
        $Last,

        [Parameter(Mandatory = $true, ParameterSetName = 'AllWithMaskLength')]
        [Parameter(Mandatory = $true, ParameterSetName = 'AllWithMask')]
        [Parameter(Mandatory = $true, ParameterSetName = 'AllIpOnly')]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Pool,

        [Parameter(ParameterSetName = 'SubnetWithMaskLength')]
        [Parameter(ParameterSetName = 'BroadcastWithMaskLength')]
        [Parameter(ParameterSetName = 'FirstWithMaskLength')]
        [Parameter(ParameterSetName = 'LastWithMaskLength')]
        [Parameter(ParameterSetName = 'AllWithMaskLength')]
        [System.Management.Automation.SwitchParameter]
        $WithMaskLength,

        [Parameter(Mandatory = $true, ParameterSetName = 'SubnetWithMask')]
        [Parameter(Mandatory = $true, ParameterSetName = 'BroadcastWithMask')]
        [Parameter(Mandatory = $true, ParameterSetName = 'FirstWithMask')]
        [Parameter(Mandatory = $true, ParameterSetName = 'LastWithMask')]
        [Parameter(Mandatory = $true, ParameterSetName = 'AllWithMask')]
        [System.Management.Automation.SwitchParameter]
        $WithMask,

        [Parameter(Mandatory = $true, ParameterSetName = 'SubnetIpOnly')]
        [Parameter(Mandatory = $true, ParameterSetName = 'BroadcastIpOnly')]
        [Parameter(Mandatory = $true, ParameterSetName = 'FirstIpOnly')]
        [Parameter(Mandatory = $true, ParameterSetName = 'LastIpOnly')]
        [Parameter(Mandatory = $true, ParameterSetName = 'AllIpOnly')]
        [System.Management.Automation.SwitchParameter]
        $IpOnly,

        [Parameter(Mandatory = $true, ParameterSetName = 'MaskQuadDotOnly')]
        [System.Management.Automation.SwitchParameter]
        $MaskQuadDotOnly,

        [Parameter(Mandatory = $true, ParameterSetName = 'MaskLengthOnly')]
        [System.Management.Automation.SwitchParameter]
        $MaskLengthOnly,

        [Parameter(Mandatory = $true, ParameterSetName = 'MaskLengthWithSlashOnly')]
        [System.Management.Automation.SwitchParameter]
        $MaskLengthWithSlashOnly
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
                if (Test-ValidIPv4 -Ip $Ip) {throw "No mask defined for $Ip"}
            }
            else
            {
                $Mask = $Mask | Convert-Ipv4Mask -Length
            }

            if (-not (Test-ValidIPv4 -Ip $Ip))
            {
                ($Ip, $m) = $Ip -split '[/ ]'
                $m = $m | Convert-Ipv4Mask -Length
                if ($Mask -eq '')
                {
                    $Mask = $m
                }
                elseif ($Mask -ne $m)
                {
                    "Mask set to /$m in -Ip but /$Mask in -Mask for $Ip. Using /$Mask" | Write-Warning
                }
            }

            [System.String] $maskQuadDot  = $Mask | Convert-Ipv4Mask -QuadDot
            [System.UInt32] $maskInt      = $Mask | Convert-Ipv4Mask -Integer
            [System.UInt32] $ipInt        = $Ip | Convert-IPv4Address -Integer
            [System.UInt32] $subnetInt    = $ipInt -band $maskInt
            [System.UInt32] $broadcastInt = $ipInt -bor (-bnot $maskInt)
            [System.UInt32] $firstInt     = 0
            [System.UInt32] $lastInt      = 0
            if ($Pool -or $Mask -eq 31 -or $Mask -eq 32) {
                $firstInt = $subnetInt
                $lastInt  = $broadcastInt
            }
            else
            {
                $firstInt = $subnetInt + 1
                $lastInt  = $broadcastInt -1
            }

            $createScript =
                if ($Subnet)        { {$subnetInt} }
                elseif ($Broadcast) { {$broadcastInt} }
                elseif ($First)     { {$firstInt} }
                elseif ($Last)      { {$lastInt} }
                elseif ($All)       { {for ([uint32] $i = $firstInt; $i -le $lastInt; $i++) {$i}} }
                else                { {$ipInt} }

            $outputScript =
                if     ($WithMask)                { {'{0} {1}' -f $_, $maskQuadDot} }
                elseif ($IpOnly)                  { {$_} }
                elseif ($MaskQuadDotOnly)         { {$maskQuadDot} }
                elseif ($MaskLengthOnly)          { {$Mask} }
                elseif ($MaskLengthWithSlashOnly) { {'/{0}' -f $Mask} }
                else                              { {'{0}/{1}' -f $_, $Mask} }

            $createScript.Invoke() | Convert-IPv4Address | ForEach-Object -Process $outputScript
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
