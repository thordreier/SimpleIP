function Test-IPv4AddressInSameNet
{
    <#
        .SYNOPSIS
            Test if two IP addresses are in the same subnet

        .DESCRIPTION
            Test if two IP addresses are in the same subnet

        .PARAMETER IP
            Input IP in quad dot format with subnet mask, either:
            - IP + mask in quad dot, eg. "127.0.0.1 255.0.0.0"
            - IP + mask length,      eg. "127.0.0.1/8"
            If input is IP without subnet mask (eg. "127.0.0.1") then -Mask parameter must be set

        .PARAMETER IP2
            Same format as -IP

        .PARAMETER Mask
            If input IP is in format without subnet mask, this parameter must be set to either
            - Quad dot format,        eg. "255.255.255.0"
            - Mask length (0-32),     eg. "24"
            - Mask length with slash, eg. "/24"

        .PARAMETER AllowMaskMismatch
            Return true if hosts with the two IP addresses can communicate with each other directly
            (not routed), even if there's a mismatch in subnet mask between the two.

        .EXAMPLE
            Test-IPv4AddressInSameNet -IP 10.30.50.60 -IP2 10.30.50.61/24
            True

        .EXAMPLE
            Test-IPv4AddressInSameNet -IP 10.30.50.60/24 -IP2 10.30.50.61/255.255.255.0
            True

        .EXAMPLE
            Test-IPv4AddressInSameNet -IP 10.30.50.60/24 -IP2 10.30.50.61/29
            False

        .EXAMPLE
            Test-IPv4AddressInSameNet -IP 10.30.50.60/24 -IP2 10.30.50.61/29 -AllowMaskMismatch
            True
    #>

    [OutputType([System.Boolean])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position=0)]
        [ValidateScript({ (Test-IPv4Address -IP $_ -AllowMask) -or $(throw "$_ is not a valid IPv4 address") })]
        [System.String]
        $IP,

        [Parameter(Mandatory = $true, Position=1)]
        [ValidateScript({ (Test-IPv4Address -IP $_ -AllowMask) -or $(throw "$_ is not a valid IPv4 address") })]
        [System.String]
        $IP2,

        [Parameter()]
        [ValidateScript({ (Test-IPv4Address -IP $_ -Mask -AllowLength) -or $(throw "$_ is not a valid IPv4 mask") })]
        [System.String]
        $Mask = '',

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $AllowMaskMismatch
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

            $null = $PSBoundParameters.Remove('AllowMaskMismatch')
            $null = $PSBoundParameters.Remove('IP')
            $null = $PSBoundParameters.Remove('IP2')
            if (
                $Mask -or
                ((Test-IPv4Address -IP $IP -RequireMask) -and (Test-IPv4Address -IP $IP2 -RequireMask))
            )
            {
                $info1 = Get-IPv4Address -Info -IP $IP @PSBoundParameters
                $info2 = Get-IPv4Address -Info -IP $IP2 @PSBoundParameters
            }
            elseif (Test-IPv4Address -IP $IP -RequireMask)
            {
                $info1 = Get-IPv4Address -Info -IP $IP @PSBoundParameters
                $null = $PSBoundParameters.Remove('Mask')
                $info2 = Get-IPv4Address -Info -IP $IP2 -Mask $info1.MaskLength @PSBoundParameters
            }
            elseif (Test-IPv4Address -IP $IP2 -RequireMask)
            {
                $info2 = Get-IPv4Address -Info -IP $IP2 @PSBoundParameters
                $null = $PSBoundParameters.Remove('Mask')
                $info1 = Get-IPv4Address -Info -IP $IP -Mask $info2.MaskLength @PSBoundParameters
            }
            else
            {
                throw "No mask defined for either IP ($IP) or IP2 ($IP2), and -Mask parameter is not set"
            }

            if ($info1.IP -eq $info2.IP)
            {
                "-IP and -IP2 is the same ($IP)" | Write-Warning
            }

            # Return
            ($info1.Subnet -eq $info2.Subnet -and $info1.MaskLength -eq $info2.MaskLength) -or
            (
                $AllowMaskMismatch -and
                $info1.Integer.IP -ge $info2.Integer.FirstIP -and
                $info1.Integer.IP -le $info2.Integer.LastIP -and
                $info2.Integer.IP -ge $info1.Integer.FirstIP -and
                $info2.Integer.IP -le $info1.Integer.LastIP
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
