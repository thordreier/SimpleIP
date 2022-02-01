function Test-IPv4AddressInSubnet
{
    <#
        .SYNOPSIS
            Test if IP address is in a subnet

        .DESCRIPTION
            Test if IP address is in a subnet

        .PARAMETER Subnet
            Input IP in quad dot format with subnet mask, either:
            - IP + mask in quad dot, eg. "127.0.0.0 255.0.0.0"
            - IP + mask length,      eg. "127.0.0.0/8"
            If input is IP without subnet mask (eg. "127.0.0.0") then -Mask parameter must be set

        .PARAMETER IP
            Same format as -Subnet

        .PARAMETER Mask
            If input IP is in format without subnet mask, this parameter must be set to either
            - Quad dot format,        eg. "255.255.255.0"
            - Mask length (0-32),     eg. "24"
            - Mask length with slash, eg. "/24"

        .PARAMETER AllowMaskMismatch
            Return true if IP is in subnet, even if the subnet mask is wrong.

        .EXAMPLE
            Test-IPv4AddressInSubnet -Subnet 10.30.50.0/24 -IP 10.30.50.70
            True

        .EXAMPLE
            Test-IPv4AddressInSubnet -Subnet 10.30.50.0/24 -IP 10.30.50.70/24
            True

        .EXAMPLE
            Test-IPv4AddressInSubnet -Subnet 10.30.50.0/24 -IP 10.30.50.70/29
            False

        .EXAMPLE
            Test-IPv4AddressInSubnet -Subnet 10.30.50.0/24 -IP 10.30.50.70/29 -AllowMaskMismatch
            True
    #>

    [OutputType([System.String])]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position=0)]
        [ValidateScript({ (Test-IPv4Address -IP $_ -AllowMask) -or $(throw "$_ is not a valid IPv4 address") })]
        [System.String]
        $Subnet,

        [Parameter(Mandatory = $true, Position=1)]
        [ValidateScript({ (Test-IPv4Address -IP $_ -AllowMask) -or $(throw "$_ is not a valid IPv4 address") })]
        [System.String]
        $IP,

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
            $null = $PSBoundParameters.Remove('Subnet')
            $null = $PSBoundParameters.Remove('IP')

            if (-not (Test-IPv4Subnet -Subnet $Subnet @PSBoundParameters))
            {
                throw "$Subnet (mask $Mask) is not a subnet"
            }
            elseif (
                $Mask -or
                ((Test-IPv4Address -IP $Subnet -RequireMask) -and (Test-IPv4Address -IP $IP -RequireMask))
            )
            {
                $info1 = Get-IPAddress -Info -IP $Subnet @PSBoundParameters
                $info2 = Get-IPAddress -Info -IP $IP @PSBoundParameters
            }
            elseif (Test-IPv4Address -IP $Subnet -RequireMask)
            {
                $info1 = Get-IPAddress -Info -IP $Subnet @PSBoundParameters
                $null = $PSBoundParameters.Remove('Mask')
                $info2 = Get-IPAddress -Info -IP $IP -Mask $info1.MaskLength @PSBoundParameters
            }
            else
            {
                throw "No mask defined for Subnet ($Subnet), and -Mask parameter is not used"
            }

            if ($info1.IP -eq $info2.IP)
            {
                "-Subnet and -IP is the same ($IP)" | Write-Warning
            }

            # Return
            ($info1.Subnet -eq $info2.Subnet -and $info1.MaskLength -eq $info2.MaskLength) -or
            (
                $AllowMaskMismatch -and
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
