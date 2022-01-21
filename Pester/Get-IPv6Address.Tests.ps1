# Invoke-Pester -Path .\Pester\Get-IPv6Address.Tests.ps1 -Output Detailed
Describe 'Get-IPv6Address' {

    It 'Positional argmuent' {
        $r = Get-IPv6Address a:b:c:FFFF::0ff/56 -Subnet -ErrorAction Stop
        $r | Should -BeOfType 'System.String'
        $r | Should -Be a:b:c:ff00::/56
    }

    Context TestCases1 {
        $testCases1 = @(
            @{Ip = 'aaaa:bbbb:cccc:0:0:0:0:0'  ; Prefix = 8     ;  Subnet = 'aa00::/8'          ; First = '' ; Last = '' ; Broadcast = '' ; AllCount = $null}
            @{Ip = '::1/128'                   ; Prefix = $null ;  Subnet = '::1/128'           ; First = '' ; Last = '' ; Broadcast = '' ; AllCount = $null}
            @{Ip = 'a:b:c:d:abcd:f:22:33/65'   ; Prefix = $null ;  Subnet = 'a:b:c:d:8000::/65' ; First = '' ; Last = '' ; Broadcast = '' ; AllCount = $null}
        )

        It 'Get-IPv6Address -Subnet -Ip <Ip> -Prefix <Prefix> == <Subnet>' -TestCases $testCases1 {
            param ($Ip, $Prefix, $Pool, $Subnet)
            $params = @{
                Subnet         = $true
                Ip             = $Ip
            }
            if ($Prefix -ne $null) { $params['Prefix'] = $Prefix }
            $r = Get-IPv6Address @params -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Subnet
        }
    }

    Context Info {
        It 'Info' {
            $r = Get-IPv6Address -Ip 99:88:77:0::/15 -Info -ErrorAction Stop
            $r.IP           | Should -Be 99:88:77::/15
            $r.Subnet       | Should -Be 98::/15
            $r.FirstIP4Real | Should -Be 98::/15
            $r.FirstIP      | Should -Be 98::1/15
            $r.LastIP       | Should -Be 99:ffff:ffff:ffff:ffff:ffff:ffff:fffe/15
            $r.LastIP4Real  | Should -Be 99:ffff:ffff:ffff:ffff:ffff:ffff:ffff/15
        }
    }

    Context Warning {
        It 'Get-IPv6Address -Ip a::f/64 -Prefix 11 -Subnet  (warning)' {
            {Get-IPv6Address -Ip a::f/64 -Prefix 11 -Subnet -ErrorAction Stop -WarningAction Stop 3>$null} | Should -Throw '*Prefix set to*but*Using*'
        }
    }

    Context TestCasesThrow1 {
        $testCasesThrow1 = @(
            @{Ip = 'a::b'      ; Prefix = $null ; Switch1 = $null    ; Switch2 = $null ; Throw = '*Parameter set cannot be resolved using the specified named parameters*'}
            @{Ip = 'xxxx'      ; Prefix = $null ; Switch1 = $null    ; Switch2 = $null ; Throw = '*Parameter set cannot be resolved using the specified named parameters*'}
            @{Ip = 'a::b'      ; Prefix = $null ; Switch1 = 'Subnet' ; Switch2 = $null ; Throw = '*No prefix defined for*'}
            @{Ip = 'xxxx'      ; Prefix = $null ; Switch1 = 'Subnet' ; Switch2 = $null ; Throw = '*Error parsing IPv6 address*'}
            @{Ip = 'a::b'      ; Prefix = 129   ; Switch1 = 'Subnet' ; Switch2 = $null ; Throw = '*Prefix is higher than 128*'}
            @{Ip = 'a::b'      ; Prefix = -1    ; Switch1 = 'Subnet' ; Switch2 = $null ; Throw = '*Cannot convert*Byte*'}
        )

        It 'Convert-IPv6Address -Ip <Ip> -Prefix <Prefix> -<Switch1> -<Switch2>  (throw)' -TestCases $testCasesThrow1 {
            param ($Ip, $Prefix, $Switch1, $Switch2, $Throw)
            $params = @{}
            if ($Ip      -ne $null) {$params['Ip']     = $Ip}
            if ($Prefix  -ne $null) {$params['Prefix'] = $Prefix}
            if ($Switch1 -ne $null) {$params[$Switch1] = $true}
            if ($Switch2 -ne $null) {$params[$Switch2] = $true}
            {Get-IPv6Address @params -ErrorAction Stop} | Should -Throw $Throw
        }
    }
}
