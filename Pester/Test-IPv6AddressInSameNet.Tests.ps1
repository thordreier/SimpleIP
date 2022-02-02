# Invoke-Pester -Path .\Pester\Test-IPv6AddressInSameNet.Tests.ps1 -Output Detailed
Describe 'Test-IPv6AddressInSameNet' {

    It 'Positional argmuent' {
        $r = Test-IPv6AddressInSameNet a:b:c::1/64 a:b:C::2/64  -ErrorAction Stop
        $r | Should -BeOfType 'System.Boolean'
        $r | Should -Be $true
    }

    Context TestCases1 {
        $testCases1 = @(
            @{IP = 'a:2::/31'   ; IP2 = 'a:3::/31'  ; Prefix = $null ; Default = $true  ; Mismatch = $true }
            @{IP = 'a:2::/32'   ; IP2 = 'a:3::/32'  ; Prefix = $null ; Default = $false ; Mismatch = $false}
            @{IP = 'a:2::/31'   ; IP2 = 'a:3::/32'  ; Prefix = $null ; Default = $false ; Mismatch = $false}
            @{IP = 'a:2::/32'   ; IP2 = 'a:3::/31'  ; Prefix = $null ; Default = $false ; Mismatch = $false}
            @{IP = 'a:2::/31'   ; IP2 = 'a:3::/30'  ; Prefix = $null ; Default = $false ; Mismatch = $true }
            @{IP = 'a:2::/30'   ; IP2 = 'a:3::/31'  ; Prefix = $null ; Default = $false ; Mismatch = $true }
            @{IP = 'a:2::/31'   ; IP2 = 'a:3::/31'  ; Prefix = 31    ; Default = $true  ; Mismatch = $true }
            @{IP = 'a:2::'      ; IP2 = 'a:3::/31'  ; Prefix = 31    ; Default = $true  ; Mismatch = $true }
            @{IP = 'a:2::/31'   ; IP2 = 'a:3::'     ; Prefix = 31    ; Default = $true  ; Mismatch = $true }
            @{IP = 'a:2::'      ; IP2 = 'a:3::'     ; Prefix = 31    ; Default = $true  ; Mismatch = $true }
            @{IP = 'a:2::/31'   ; IP2 = 'a:3::'     ; Prefix = $null ; Default = $true  ; Mismatch = $true }
            @{IP = 'a:2::'      ; IP2 = 'a:3::/31'  ; Prefix = $null ; Default = $true  ; Mismatch = $true }
        )

        It 'Test-IPv6AddressInSameNet -IP <IP> -IP2 <IP2> -Prefix <Prefix> == <Default>' -TestCases $testCases1 {
            param ($IP, $IP2, $Prefix, $Default)
            $params = @{
                IP  = $IP
                IP2 = $IP2
            }
            if ($Prefix -ne $null) { $params['Prefix'] = $Prefix }
            $r = Test-IPv6AddressInSameNet @params -ErrorAction Stop
            $r | Should -BeOfType 'System.Boolean'
            $r | Should -Be $Default
        }

        It 'Test-IPv6AddressInSameNet -IP <IP> -IP2 <IP2> -Prefix <Prefix> -AllowPrefixMismatch == <Mismatch>' -TestCases $testCases1 {
            param ($IP, $IP2, $Prefix, $Mismatch)
            $params = @{
                IP                = $IP
                IP2               = $IP2
                AllowPrefixMismatch = $true
            }
            if ($Prefix -ne $null) { $params['Prefix'] = $Prefix }
            $r = Test-IPv6AddressInSameNet @params -ErrorAction Stop
            $r | Should -BeOfType 'System.Boolean'
            $r | Should -Be $Mismatch
        }
    }

    Context Warning {
        It 'Test-IPv6AddressInSameNet -IP a::b/8 -IP2 a::c -Prefix 24  (warning)' {
            {Test-IPv6AddressInSameNet -IP a::b/8 -IP2 a::c -Prefix 24 -ErrorAction Stop -WarningAction Stop 3>$null} | Should -Throw '*Prefix set to*but*Using*'
        }

        It 'Test-IPv6AddressInSameNet -IP a::b/8 -IP2 a::b  (warning)' {
            {Test-IPv6AddressInSameNet -IP a::b/8 -IP2 a::b -ErrorAction Stop -WarningAction Stop 3>$null} | Should -Throw '*is the same*'
        }
    }

    Context TestCasesThrow1 {
        $testCasesThrow1 = @(
            @{IP = -1          ; IP2 = $null       ; Prefix = $null ; Switch1 = $null ; Switch2 = $null ; Throw = '*Cannot validate argument on parameter*'}
            @{IP = 22          ; IP2 = 22          ; Prefix = $null ; Switch1 = $null ; Switch2 = $null ; Throw = '*is not a valid IPv6 address*'}
            @{IP = -1          ; IP2 = 'a::b'      ; Prefix = -1    ; Switch1 = $null ; Switch2 = $null ; Throw = '*Cannot convert value*System.Byte*'}
            @{IP = 'a::b'      ; IP2 = 'a::c'      ; Prefix = -1    ; Switch1 = $null ; Switch2 = $null ; Throw = '*Cannot convert value*System.Byte*'}
            @{IP = 'a::b'      ; IP2 = 'a::c'      ; Prefix = $null ; Switch1 = $null ; Switch2 = $null ; Throw = '*No Prefix defined for either*'}
            @{IP = 'a::b'      ; IP2 = 'a::C'      ; Prefix = $null ; Switch1 = 'Abc' ; Switch2 = $null ; Throw = '*A parameter cannot be found that matches parameter name*'}
        )

        It 'Test-IPv6AddressInSameNet -IP <IP> -IP2 <IP2> -Prefix <Prefix> -<Switch1> -<Switch2>  (throw)' -TestCases $testCasesThrow1 {
            param ($IP, $IP2, $Prefix, $Switch1, $Switch2, $Throw)
            $params = @{
                IP  = $IP
                IP2 = $IP2
            }
            if ($Prefix    -ne $null) {$params['Prefix']   = $Prefix}
            if ($Switch1 -ne $null) {$params[$Switch1] = $true}
            if ($Switch2 -ne $null) {$params[$Switch2] = $true}
            {Test-IPv6AddressInSameNet @params -ErrorAction Stop} | Should -Throw $Throw
        }
    }
}
