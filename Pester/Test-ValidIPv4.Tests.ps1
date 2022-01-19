# Invoke-Pester -Path .\Pester\Test-ValidIPv4.Tests.ps1 -Output Detailed
Describe 'Test-ValidIPv4' {

    It 'Positional argmuent' {
        $r = Test-ValidIPv4 '10.11.12.13' -ErrorAction Stop
        $r | Should -BeOfType 'System.Boolean'
        $r | Should -Be $true
    }

    Context TestCases1 {
        $testCases1 = @(
            @{Ip = '0.0.0.0'                      ; IpOnly = $true  ; Subnet = $true  ; AllowSubnet = $true  ; RequireSubnet = $false}
            @{Ip = '255.255.128.0'                ; IpOnly = $true  ; Subnet = $true  ; AllowSubnet = $true  ; RequireSubnet = $false}
            @{Ip = '255.255.0.255'                ; IpOnly = $true  ; Subnet = $false ; AllowSubnet = $true  ; RequireSubnet = $false}
            @{Ip = '10.12.12.13'                  ; IpOnly = $true  ; Subnet = $false ; AllowSubnet = $true  ; RequireSubnet = $false}
            @{Ip = '10.12.12.13'                  ; IpOnly = $true  ; Subnet = $false ; AllowSubnet = $true  ; RequireSubnet = $false}
            @{Ip = '0.0.0.0/0'                    ; IpOnly = $false ; Subnet = $false ; AllowSubnet = $true  ; RequireSubnet = $true }
            @{Ip = '255.255.255.255/0'            ; IpOnly = $false ; Subnet = $false ; AllowSubnet = $true  ; RequireSubnet = $true }
            @{Ip = '10.12.12.13/0'                ; IpOnly = $false ; Subnet = $false ; AllowSubnet = $true  ; RequireSubnet = $true }
            @{Ip = '10.12.12.13/18'               ; IpOnly = $false ; Subnet = $false ; AllowSubnet = $true  ; RequireSubnet = $true }
            @{Ip = '10.12.12.13/32'               ; IpOnly = $false ; Subnet = $false ; AllowSubnet = $true  ; RequireSubnet = $true }
            @{Ip = '10.12.12.13/33'               ; IpOnly = $false ; Subnet = $false ; AllowSubnet = $false ; RequireSubnet = $false}
            @{Ip = '10.12.12.13 32'               ; IpOnly = $false ; Subnet = $false ; AllowSubnet = $true  ; RequireSubnet = $true }
            @{Ip = '10.12.12.13/255.255.224.0'    ; IpOnly = $false ; Subnet = $false ; AllowSubnet = $true  ; RequireSubnet = $true }
            @{Ip = '10.12.12.13 255.255.224.0'    ; IpOnly = $false ; Subnet = $false ; AllowSubnet = $true  ; RequireSubnet = $true }
            @{Ip = '10.12.12.13  255.255.224.0'   ; IpOnly = $false ; Subnet = $false ; AllowSubnet = $false ; RequireSubnet = $false}
            @{Ip = '10.12.12.13/255.255.0.224'    ; IpOnly = $false ; Subnet = $false ; AllowSubnet = $false ; RequireSubnet = $false}
            @{Ip = 'abcdef'                       ; IpOnly = $false ; Subnet = $false ; AllowSubnet = $false ; RequireSubnet = $false}
        )

        It 'Test-ValidIPv4 -Ip <Ip> -IpOnly == <IpOnly>' -TestCases $testCases1 {
            param ($Ip, $IpOnly)
            $r = Test-ValidIPv4 -Ip $Ip -IpOnly -ErrorAction Stop
            $r | Should -BeOfType 'System.Boolean'
            $r | Should -Be $IpOnly
        }

        It 'Test-ValidIPv4 -Ip <Ip> -Subnet == <Subnet>' -TestCases $testCases1 {
            param ($Ip, $Subnet)
            $r = Test-ValidIPv4 -Ip $Ip -Subnet -ErrorAction Stop
            $r | Should -BeOfType 'System.Boolean'
            $r | Should -Be $Subnet
        }

        It 'Test-ValidIPv4 -Ip <Ip> -AllowSubnet == <AllowSubnet>' -TestCases $testCases1 {
            param ($Ip, $AllowSubnet)
            $r = Test-ValidIPv4 -Ip $Ip -AllowSubnet -ErrorAction Stop
            $r | Should -BeOfType 'System.Boolean'
            $r | Should -Be $AllowSubnet
        }

        It 'Test-ValidIPv4 -Ip <Ip> -RequireSubnet == <RequireSubnet>' -TestCases $testCases1 {
            param ($Ip, $RequireSubnet)
            $r = Test-ValidIPv4 -Ip $Ip -RequireSubnet -ErrorAction Stop
            $r | Should -BeOfType 'System.Boolean'
            $r | Should -Be $RequireSubnet
        }
    }
}
