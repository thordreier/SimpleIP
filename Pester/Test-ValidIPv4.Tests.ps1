# Invoke-Pester -Path .\Pester\Test-ValidIPv4.Tests.ps1 -Output Detailed
Describe 'Test-ValidIPv4' {

    It 'Positional argmuent' {
        $r = Test-ValidIPv4 '10.11.12.13' -ErrorAction Stop
        $r | Should -BeOfType 'System.Boolean'
        $r | Should -Be $true
    }

    Context TestCases1 {
        $testCases1 = @(
            @{Ip = '0.0.0.0'                      ; IpOnly = $true  ; Mask = $true  ; Bits = $true  ; AllowMask = $true  ; RequireMask = $false}
            @{Ip = '255.255.128.0'                ; IpOnly = $true  ; Mask = $true  ; Bits = $true  ; AllowMask = $true  ; RequireMask = $false}
            @{Ip = '255.255.0.255'                ; IpOnly = $true  ; Mask = $false ; Bits = $false ; AllowMask = $true  ; RequireMask = $false}
            @{Ip = '10.12.12.13'                  ; IpOnly = $true  ; Mask = $false ; Bits = $false ; AllowMask = $true  ; RequireMask = $false}
            @{Ip = '10.12.12.13'                  ; IpOnly = $true  ; Mask = $false ; Bits = $false ; AllowMask = $true  ; RequireMask = $false}
            @{Ip = '0.0.0.0/0'                    ; IpOnly = $false ; Mask = $false ; Bits = $false ; AllowMask = $true  ; RequireMask = $true }
            @{Ip = '255.255.255.255/0'            ; IpOnly = $false ; Mask = $false ; Bits = $false ; AllowMask = $true  ; RequireMask = $true }
            @{Ip = '10.12.12.13/0'                ; IpOnly = $false ; Mask = $false ; Bits = $false ; AllowMask = $true  ; RequireMask = $true }
            @{Ip = '10.12.12.13/18'               ; IpOnly = $false ; Mask = $false ; Bits = $false ; AllowMask = $true  ; RequireMask = $true }
            @{Ip = '10.12.12.13/32'               ; IpOnly = $false ; Mask = $false ; Bits = $false ; AllowMask = $true  ; RequireMask = $true }
            @{Ip = '10.12.12.13/33'               ; IpOnly = $false ; Mask = $false ; Bits = $false ; AllowMask = $false ; RequireMask = $false}
            @{Ip = '10.12.12.13/255.255.224.0'    ; IpOnly = $false ; Mask = $false ; Bits = $false ; AllowMask = $true  ; RequireMask = $true }
            @{Ip = '10.12.12.13 255.255.224.0'    ; IpOnly = $false ; Mask = $false ; Bits = $false ; AllowMask = $true  ; RequireMask = $true }
            @{Ip = '10.12.12.13  255.255.224.0'   ; IpOnly = $false ; Mask = $false ; Bits = $false ; AllowMask = $false ; RequireMask = $false}
            @{Ip = '10.12.12.13/255.255.0.224'    ; IpOnly = $false ; Mask = $false ; Bits = $false ; AllowMask = $false ; RequireMask = $false}
            @{Ip = -1                             ; IpOnly = $false ; Mask = $false ; Bits = $false ; AllowMask = $false ; RequireMask = $false}
            @{Ip = 0                              ; IpOnly = $false ; Mask = $false ; Bits = $true  ; AllowMask = $false ; RequireMask = $false}
            @{Ip = 32                             ; IpOnly = $false ; Mask = $false ; Bits = $true  ; AllowMask = $false ; RequireMask = $false}
            @{Ip = 33                             ; IpOnly = $false ; Mask = $false ; Bits = $false ; AllowMask = $false ; RequireMask = $false}
            @{Ip = 'abcdef'                       ; IpOnly = $false ; Mask = $false ; Bits = $false ; AllowMask = $false ; RequireMask = $false}
            #>
        )

        It 'Test-ValidIPv4 -Ip <Ip> -IpOnly == <IpOnly>' -TestCases $testCases1 {
            param ($Ip, $IpOnly)
            $r = Test-ValidIPv4 -Ip $Ip -IpOnly -ErrorAction Stop
            $r | Should -BeOfType 'System.Boolean'
            $r | Should -Be $IpOnly
        }

        It 'Test-ValidIPv4 -Ip <Ip> -Mask == <Mask>' -TestCases $testCases1 {
            param ($Ip, $Mask)
            $r = Test-ValidIPv4 -Ip $Ip -Mask -ErrorAction Stop
            $r | Should -BeOfType 'System.Boolean'
            $r | Should -Be $Mask
        }

        It 'Test-ValidIPv4 -Ip <Ip> -Mask -AllowBits == <Bits>' -TestCases $testCases1 {
            param ($Ip, $Bits)
            $r = Test-ValidIPv4 -Ip $Ip -Mask -AllowBits -ErrorAction Stop
            $r | Should -BeOfType 'System.Boolean'
            $r | Should -Be $Bits
        }

        It 'Test-ValidIPv4 -Ip <Ip> -AllowMask == <AllowMask>' -TestCases $testCases1 {
            param ($Ip, $AllowMask)
            $r = Test-ValidIPv4 -Ip $Ip -AllowMask -ErrorAction Stop
            $r | Should -BeOfType 'System.Boolean'
            $r | Should -Be $AllowMask
        }

        It 'Test-ValidIPv4 -Ip <Ip> -RequireMask == <RequireMask>' -TestCases $testCases1 {
            param ($Ip, $RequireMask)
            $r = Test-ValidIPv4 -Ip $Ip -RequireMask -ErrorAction Stop
            $r | Should -BeOfType 'System.Boolean'
            $r | Should -Be $RequireMask
        }
    }
}
