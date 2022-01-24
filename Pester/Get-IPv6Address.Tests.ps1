# Invoke-Pester -Path .\Pester\Get-IPv6Address.Tests.ps1 -Output Detailed
Describe 'Get-IPv6Address' {

    It 'Positional argmuent' {
        $r = Get-IPv6Address a:b:c:FFFF::0ff/56 -Subnet -ErrorAction Stop
        $r | Should -BeOfType 'System.String'
        $r | Should -Be a:b:c:ff00::/56
    }

    Context TestCases1 {
        $testCases1 = @(
            @{IP = 'aaaa:bbbb:cccc:0:0:0:0:0'  ; Prefix = 8     ;  Subnet = 'aa00::/8'          ; First = '' ; Last = '' ; Broadcast = '' ; AllCount = $null}
            @{IP = '::1/128'                   ; Prefix = $null ;  Subnet = '::1/128'           ; First = '' ; Last = '' ; Broadcast = '' ; AllCount = $null}
            @{IP = 'a:b:c:d:abcd:f:22:33/65'   ; Prefix = $null ;  Subnet = 'a:b:c:d:8000::/65' ; First = '' ; Last = '' ; Broadcast = '' ; AllCount = $null}
        )

        It 'Get-IPv6Address -Subnet -IP <IP> -Prefix <Prefix> == <Subnet>' -TestCases $testCases1 {
            param ($IP, $Prefix, $Pool, $Subnet)
            $params = @{
                Subnet         = $true
                IP             = $IP
            }
            if ($Prefix -ne $null) { $params['Prefix'] = $Prefix }
            $r = Get-IPv6Address @params -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Subnet
        }
    }

    Context Info {
        It 'Info' {
            $r = Get-IPv6Address -IP 99:88:77:0::/15 -Info -ErrorAction Stop
            $r.IP           | Should -Be 99:88:77::/15
            $r.Subnet       | Should -Be 98::/15
            $r.FirstIP4Real | Should -Be 98::/15
            $r.FirstIP      | Should -Be 98::1/15
            $r.LastIP       | Should -Be 99:ffff:ffff:ffff:ffff:ffff:ffff:fffe/15
            $r.LastIP4Real  | Should -Be 99:ffff:ffff:ffff:ffff:ffff:ffff:ffff/15
        }
    }

    Context Warning {
        It 'Get-IPv6Address -IP a::f/64 -Prefix 11 -Subnet  (warning)' {
            {Get-IPv6Address -IP a::f/64 -Prefix 11 -Subnet -ErrorAction Stop -WarningAction Stop 3>$null} | Should -Throw '*Prefix set to*but*Using*'
        }
    }

    Context TestCasesThrow1 {
        $testCasesThrow1 = @(
            @{IP = 'a::b'      ; Prefix = $null ; Switch1 = $null    ; Switch2 = $null ; Throw = '*Parameter set cannot be resolved using the specified named parameters*'}
            @{IP = 'xxxx'      ; Prefix = $null ; Switch1 = $null    ; Switch2 = $null ; Throw = '*Parameter set cannot be resolved using the specified named parameters*'}
            @{IP = 'a::b'      ; Prefix = $null ; Switch1 = 'Subnet' ; Switch2 = $null ; Throw = '*No prefix defined for*'}
            @{IP = 'xxxx'      ; Prefix = $null ; Switch1 = 'Subnet' ; Switch2 = $null ; Throw = '*Error parsing IPv6 address*'}
            @{IP = 'a::b'      ; Prefix = 129   ; Switch1 = 'Subnet' ; Switch2 = $null ; Throw = '*Prefix is higher than 128*'}
            @{IP = 'a::b'      ; Prefix = -1    ; Switch1 = 'Subnet' ; Switch2 = $null ; Throw = '*Cannot convert*Byte*'}
        )

        It 'Convert-IPv6Address -IP <IP> -Prefix <Prefix> -<Switch1> -<Switch2>  (throw)' -TestCases $testCasesThrow1 {
            param ($IP, $Prefix, $Switch1, $Switch2, $Throw)
            $params = @{}
            if ($IP      -ne $null) {$params['IP']     = $IP}
            if ($Prefix  -ne $null) {$params['Prefix'] = $Prefix}
            if ($Switch1 -ne $null) {$params[$Switch1] = $true}
            if ($Switch2 -ne $null) {$params[$Switch2] = $true}
            {Get-IPv6Address @params -ErrorAction Stop} | Should -Throw $Throw
        }
    }
}
