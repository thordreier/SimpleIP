# Invoke-Pester -Path .\Pester\Get-IPv6Subnet.Tests.ps1 -Output Detailed
Describe 'Get-IPv6Subnet' {

    Context PositionalArgmuent {
        It 'Positional argmuent1' {
            $r = Get-IPv6Subnet a:b:00c:FFFF::0ff/56 -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be a:b:c:ff00::/56
        }

        It 'Positional argmuent2' {
            $r = Get-IPv6Subnet a:b:00c:FFFF::0ff/56 -IPOnly -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be a:b:c:ff00::
        }
    }

    Context TestCases1 {
        $testCases1 = @(
            @{IP = 'aaaa:bbbb:cccc:0:0:0:0:0'  ; Prefix = 8     ;  Subnet = 'aa00::/8'         }
            @{IP = '::1/128'                   ; Prefix = $null ;  Subnet = '::1/128'          }
            @{IP = 'a:b:c:d:abcd:f:22:33/65'   ; Prefix = $null ;  Subnet = 'a:b:c:d:8000::/65'}
        )

        It 'Get-IPv6Subnet -IP <IP> -Prefix <Prefix> == <Subnet>' -TestCases $testCases1 {
            param ($IP, $Prefix, $Subnet)
            $params = @{
                IP = $IP
            }
            if ($Prefix -ne $null) { $params['Prefix'] = $Prefix }
            $r = Get-IPv6Subnet @params -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Subnet
        }
    }

    Context TestCasesThrow1 {
        $testCasesThrow1 = @(
            @{IP = 'a::b'      ; Prefix = $null ; Switch1 = $null    ; Switch2 = $null ; Throw = '*No prefix defined for*'}
            @{IP = 'xxxx'      ; Prefix = $null ; Switch1 = $null    ; Switch2 = $null ; Throw = '*Error parsing IPv6 address*'}
            @{IP = 'a::b'      ; Prefix = $null ; Switch1 = 'Subnet' ; Switch2 = $null ; Throw = '*A parameter cannot be found that matches parameter name*'}
            @{IP = 'xxxx'      ; Prefix = $null ; Switch1 = 'Subnet' ; Switch2 = $null ; Throw = '*A parameter cannot be found that matches parameter name*'}
            @{IP = 'a::b'      ; Prefix = 129   ; Switch1 = $null    ; Switch2 = $null ; Throw = '*Prefix is higher than 128*'}
            @{IP = 'a::b'      ; Prefix = -1    ; Switch1 = 'Subnet' ; Switch2 = $null ; Throw = '*Cannot convert*Byte*'}
        )

        It 'Get-IPv6Subnet -IP <IP> -Prefix <Prefix> -<Switch1> -<Switch2>  (throw)' -TestCases $testCasesThrow1 {
            param ($IP, $Prefix, $Switch1, $Switch2, $Throw)
            $params = @{}
            if ($IP      -ne $null) {$params['IP']     = $IP}
            if ($Prefix  -ne $null) {$params['Prefix'] = $Prefix}
            if ($Switch1 -ne $null) {$params[$Switch1] = $true}
            if ($Switch2 -ne $null) {$params[$Switch2] = $true}
            {Get-IPv6Subnet @params -ErrorAction Stop} | Should -Throw $Throw
        }
    }
}
