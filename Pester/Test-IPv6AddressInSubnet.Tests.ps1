# Invoke-Pester -Path .\Pester\Test-IPv6AddressInSubnet.Tests.ps1 -Output Detailed
Describe 'Test-IPv6AddressInSubnet' {

    It 'Positional argmuent' {
        $r = Test-IPv6AddressInSubnet a:b:c::/64 a:b:c::2/64 -ErrorAction Stop
        $r | Should -BeOfType 'System.Boolean'
        $r | Should -Be $true
    }

    Context TestCases1 {
        $testCases1 = @(
            @{Subnet = 'a:2::/31'   ; IP = 'a:3::/31'  ; Prefix = $null ; Default = $true  ; Mismatch = $true }
            @{Subnet = 'a:2::/32'   ; IP = 'a:3::/32'  ; Prefix = $null ; Default = $false ; Mismatch = $false}
            @{Subnet = 'a:2::/31'   ; IP = 'a:3::/32'  ; Prefix = $null ; Default = $false ; Mismatch = $true }
            @{Subnet = 'a:2::/32'   ; IP = 'a:3::/31'  ; Prefix = $null ; Default = $false ; Mismatch = $false}
            @{Subnet = 'a:2::/31'   ; IP = 'a:3::/30'  ; Prefix = $null ; Default = $false ; Mismatch = $true }
            @{Subnet = 'a:0::/30'   ; IP = 'a:3::/31'  ; Prefix = $null ; Default = $false ; Mismatch = $true }
            @{Subnet = 'a:2::/31'   ; IP = 'a:3::/31'  ; Prefix = 31    ; Default = $true  ; Mismatch = $true }
            @{Subnet = 'a:2::'      ; IP = 'a:3::/31'  ; Prefix = 31    ; Default = $true  ; Mismatch = $true }
            @{Subnet = 'a:2::/31'   ; IP = 'a:3::'     ; Prefix = 31    ; Default = $true  ; Mismatch = $true }
            @{Subnet = 'a:2::'      ; IP = 'a:3::'     ; Prefix = 31    ; Default = $true  ; Mismatch = $true }
            @{Subnet = 'a:2::/31'   ; IP = 'a:3::'     ; Prefix = $null ; Default = $true  ; Mismatch = $true }
        )

        It 'Test-IPv6AddressInSubnet -Subnet <Subnet> -IP <IP> -Prefix <Prefix> == <Default>' -TestCases $testCases1 {
            param ($Subnet, $IP, $Prefix, $Default)
            $params = @{
                Subnet = $Subnet
                IP     = $IP
            }
            if ($Prefix -ne $null) { $params['Prefix'] = $Prefix }
            $r = Test-IPv6AddressInSubnet @params -ErrorAction Stop
            $r | Should -BeOfType 'System.Boolean'
            $r | Should -Be $Default
        }

        It 'Test-IPv6AddressInSubnet -Subnet <Subnet> -IP <IP> -Prefix <Prefix> -AllowPrefixMismatch == <Mismatch>' -TestCases $testCases1 {
            param ($Subnet, $IP, $Prefix, $Mismatch)
            $params = @{
                Subnet              = $Subnet
                IP                  = $IP
                AllowPrefixMismatch = $true
            }
            if ($Prefix -ne $null) { $params['Prefix'] = $Prefix }
            $r = Test-IPv6AddressInSubnet @params -ErrorAction Stop
            $r | Should -BeOfType 'System.Boolean'
            $r | Should -Be $Mismatch
        }
    }

    Context Warning {
        It 'Test-IPv6AddressInSubnet -Subnet a:b::/32 -IP a:b::c -Prefix 64  (warning)' {
            {Test-IPv6AddressInSubnet -Subnet a:b::/32 -IP a:b::c -Prefix 64 -ErrorAction Stop -WarningAction SilentlyContinue -WarningVariable w ; throw $w} | Should -Throw '*Prefix set to*but*Using*'
        }

        It 'Test-IPv6AddressInSubnet -Subnet a:b::/32 -IP a:b::  (warning)' {
            {Test-IPv6AddressInSubnet -Subnet a:b::/32 -IP a:b:: -ErrorAction Stop -WarningAction SilentlyContinue -WarningVariable w ; throw $w} | Should -Throw '*is the same*'
        }
    }

    Context TestCasesThrow1 {
        $testCasesThrow1 = @(
            @{Subnet = -1          ; IP = $null       ; Prefix = $null ; Switch1 = $null ; Switch2 = $null ; Throw = '*Cannot validate argument on parameter*'}
            @{Subnet = 22          ; IP = 22          ; Prefix = $null ; Switch1 = $null ; Switch2 = $null ; Throw = '*is not a valid IPv6 address*'}
            @{Subnet = -1          ; IP = 'a::b'      ; Prefix = -1    ; Switch1 = $null ; Switch2 = $null ; Throw = '*is not a valid IPv6 address*'}
            @{Subnet = 'a::b'      ; IP = 'a::c'      ; Prefix = -1    ; Switch1 = $null ; Switch2 = $null ; Throw = '*Cannot convert value*System.Byte*'}
            @{Subnet = 'a::b'      ; IP = 'a::c'      ; Prefix = $null ; Switch1 = $null ; Switch2 = $null ; Throw = '*is not a subnet*'}
            @{Subnet = 'a::b'      ; IP = 'a::C'      ; Prefix = $null ; Switch1 = 'Abc' ; Switch2 = $null ; Throw = '*A parameter cannot be found that matches parameter name*'}
            @{Subnet = 'a::b/32'   ; IP = 'a::c'      ; Prefix = $null ; Switch1 = $null ; Switch2 = $null ; Throw = '*is not a subnet*'}
            @{Subnet = 'a:b::'     ; IP = 'a::c'      ; Prefix = -1    ; Switch1 = $null ; Switch2 = $null ; Throw = '*Cannot convert value*System.Byte*'}
            @{Subnet = 'a:b::'     ; IP = 'a::c'      ; Prefix = $null ; Switch1 = $null ; Switch2 = $null ; Throw = '*is not a subnet*'}
            @{Subnet = 'a:b::'     ; IP = 'a::C'      ; Prefix = $null ; Switch1 = 'Abc' ; Switch2 = $null ; Throw = '*A parameter cannot be found that matches parameter name*'}
        )

        It 'Test-IPv6AddressInSubnet -Subnet <Subnet> -IP <IP> -Prefix <Prefix> -<Switch1> -<Switch2>  (throw)' -TestCases $testCasesThrow1 {
            param ($Subnet, $IP, $Prefix, $Switch1, $Switch2, $Throw)
            $params = @{
                Subnet = $Subnet
                IP     = $IP
            }
            if ($Prefix    -ne $null) {$params['Prefix']   = $Prefix}
            if ($Switch1 -ne $null) {$params[$Switch1] = $true}
            if ($Switch2 -ne $null) {$params[$Switch2] = $true}
            {Test-IPv6AddressInSubnet @params -ErrorAction Stop} | Should -Throw $Throw
        }
    }
}
