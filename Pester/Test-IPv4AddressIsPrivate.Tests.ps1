# Invoke-Pester -Path .\Pester\Test-IPv4AddressIsPrivate.Tests.ps1 -Output Detailed
Describe 'Test-IPv4AddressIsPrivate' {

    It 'Positional argmuent' {
        $r = Test-IPv4AddressIsPrivate 10.11.12.0/24 -ErrorAction Stop
        $r | Should -BeOfType 'System.Boolean'
        $r | Should -Be $true
    }

    Context TestCases1 {
        $testCases1 = @(
            @{IP = '9.255.255.255'    ; Default = $false ; Rfc1918 = $false ; Rfc6598 = $false}
            @{IP = '10.0.0.0'         ; Default = $true  ; Rfc1918 = $true  ; Rfc6598 = $false}
            @{IP = '10.255.255.255'   ; Default = $true  ; Rfc1918 = $true  ; Rfc6598 = $false}
            @{IP = '11.0.0.0'         ; Default = $false ; Rfc1918 = $false ; Rfc6598 = $false}

            @{IP = '172.15.255.255'   ; Default = $false ; Rfc1918 = $false ; Rfc6598 = $false}
            @{IP = '172.16.0.0'       ; Default = $true  ; Rfc1918 = $true  ; Rfc6598 = $false}
            @{IP = '172.31.255.255'   ; Default = $true  ; Rfc1918 = $true  ; Rfc6598 = $false}
            @{IP = '172.32.0.0'       ; Default = $false ; Rfc1918 = $false ; Rfc6598 = $false}

            @{IP = '192.167.255.255'  ; Default = $false ; Rfc1918 = $false ; Rfc6598 = $false}
            @{IP = '192.168.0.0'      ; Default = $true  ; Rfc1918 = $true  ; Rfc6598 = $false}
            @{IP = '192.168.255.255'  ; Default = $true  ; Rfc1918 = $true  ; Rfc6598 = $false}
            @{IP = '192.169.0.0'      ; Default = $false ; Rfc1918 = $false ; Rfc6598 = $false}

            @{IP = '100.63.255.255'   ; Default = $false ; Rfc1918 = $false ; Rfc6598 = $false}
            @{IP = '100.64.0.0'       ; Default = $true  ; Rfc1918 = $false ; Rfc6598 = $true }
            @{IP = '100.127.255.255'  ; Default = $true  ; Rfc1918 = $false ; Rfc6598 = $true }
            @{IP = '100.128.0.0'      ; Default = $false ; Rfc1918 = $false ; Rfc6598 = $false}

            @{IP = '192.168.10.20/24' ; Default = $true  ; Rfc1918 = $true  ; Rfc6598 = $false}
            @{IP = '192.168.10.20/8'  ; Default = $true  ; Rfc1918 = $true  ; Rfc6598 = $false}  # Maybe FIXXXME - should this one be true or not?
        )

        It 'Test-IPv4AddressIsPrivate -IP <IP> == <Default>' -TestCases $testCases1 {
            param ($IP, $Default)
            $params = @{
                IP = $IP
            }
            $r = Test-IPv4AddressIsPrivate @params -ErrorAction Stop
            $r | Should -BeOfType 'System.Boolean'
            $r | Should -Be $Default
        }

        It 'Test-IPv4AddressIsPrivate -IP <IP> -Rfc1918 == <Rfc1918>' -TestCases $testCases1 {
            param ($IP, $Rfc1918)
            $params = @{
                IP      = $IP
                Rfc1918 = $true
            }
            $r = Test-IPv4AddressIsPrivate @params -ErrorAction Stop
            $r | Should -BeOfType 'System.Boolean'
            $r | Should -Be $Rfc1918
        }

        It 'Test-IPv4AddressIsPrivate -IP <IP> -Rfc6598 == <Rfc6598>' -TestCases $testCases1 {
            param ($IP, $Rfc1918)
            $params = @{
                IP      = $IP
                Rfc6598 = $true
            }
            $r = Test-IPv4AddressIsPrivate @params -ErrorAction Stop
            $r | Should -BeOfType 'System.Boolean'
            $r | Should -Be $Rfc6598
        }
    }
}
