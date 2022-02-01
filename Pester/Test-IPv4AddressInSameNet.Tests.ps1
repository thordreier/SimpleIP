# Invoke-Pester -Path .\Pester\Test-IPv4AddressInSameNet.Tests.ps1 -Output Detailed
Describe 'Test-IPv4AddressInSameNet' {

    It 'Positional argmuent' {
        $r = Test-IPv4AddressInSameNet 10.11.12.13/24 10.11.12.14/24  -ErrorAction Stop
        $r | Should -BeOfType 'System.Boolean'
        $r | Should -Be $true
    }

    Context TestCases1 {
        $testCases1 = @(
            @{IP = '10.10.10.4/24'   ; IP2 = '10.10.10.250/24'  ; Mask = $null ; Default = $true  ; Mismatch = $true }
            @{IP = '10.10.10.4/23'   ; IP2 = '10.10.10.250/24'  ; Mask = $null ; Default = $false ; Mismatch = $true }
            @{IP = '10.10.22.4/24'   ; IP2 = '10.10.10.250/24'  ; Mask = $null ; Default = $false ; Mismatch = $false}
            @{IP = '10.10.22.4'      ; IP2 = '10.10.10.250'     ; Mask = 16    ; Default = $true  ; Mismatch = $true }
            @{IP = '10.10.22.4'      ; IP2 = '10.10.10.250'     ; Mask = 24    ; Default = $false ; Mismatch = $false}
            @{IP = '10.10.10.204/29' ; IP2 = '10.10.10.105/24'  ; Mask = $null ; Default = $false ; Mismatch = $false}
            @{IP = '10.10.10.204/29' ; IP2 = '10.10.10.205/24'  ; Mask = $null ; Default = $false ; Mismatch = $true }
            @{IP = '10.10.10.204/29' ; IP2 = '10.10.10.205/29'  ; Mask = $null ; Default = $true  ; Mismatch = $true }
            @{IP = '10.10.10.204'    ; IP2 = '10.10.10.205/29'  ; Mask = $null ; Default = $true  ; Mismatch = $true }
            @{IP = '10.10.10.204/29' ; IP2 = '10.10.10.205'     ; Mask = $null ; Default = $true  ; Mismatch = $true }
        )

        It 'Test-IPv4AddressInSameNet -IP <IP> -IP2 <IP2> -Mask <Mask> == <Default>' -TestCases $testCases1 {
            param ($IP, $IP2, $Mask, $Default)
            $params = @{
                IP  = $IP
                IP2 = $IP2
            }
            if ($Mask -ne $null) { $params['Mask'] = $Mask }
            $r = Test-IPv4AddressInSameNet @params -ErrorAction Stop
            $r | Should -BeOfType 'System.Boolean'
            $r | Should -Be $Default
        }

        It 'Test-IPv4AddressInSameNet -IP <IP> -IP2 <IP2> -Mask <Mask> -AllowMaskMismatch == <Mismatch>' -TestCases $testCases1 {
            param ($IP, $IP2, $Mask, $Mismatch)
            $params = @{
                IP                = $IP
                IP2               = $IP2
                AllowMaskMismatch = $true
            }
            if ($Mask -ne $null) { $params['Mask'] = $Mask }
            $r = Test-IPv4AddressInSameNet @params -ErrorAction Stop
            $r | Should -BeOfType 'System.Boolean'
            $r | Should -Be $Mismatch
        }
    }

    Context Warning {
        It 'Test-IPv4AddressInSameNet -IP 1.2.3.4/8 -IP2 1.2.3.5 -Mask 24  (warning)' {
            {Test-IPv4AddressInSameNet -IP 1.2.3.4/8 -IP2 1.2.3.5 -Mask 24 -ErrorAction Stop -WarningAction Stop 3>$null} | Should -Throw '*Mask set to*but*Using*'
        }

        It 'Test-IPv4AddressInSameNet -IP 1.2.3.4/8 -IP2 1.2.3.4  (warning)' {
            {Test-IPv4AddressInSameNet -IP 1.2.3.4/8 -IP2 1.2.3.4 -ErrorAction Stop -WarningAction Stop 3>$null} | Should -Throw '*is the same*'
        }
    }

    Context TestCasesThrow1 {
        $testCasesThrow1 = @(
            @{IP = -1          ; IP2 = $null       ; Mask = $null ; Switch1 = $null ; Switch2 = $null ; Throw = '*Cannot validate argument on parameter*'}
            @{IP = 22          ; IP2 = 22          ; Mask = $null ; Switch1 = $null ; Switch2 = $null ; Throw = '*is not a valid IPv4 address*'}
            @{IP = -1          ; IP2 = '1.2.3.4'   ; Mask = -1    ; Switch1 = $null ; Switch2 = $null ; Throw = '*is not a valid IPv4*'}
            @{IP = '127.0.0.1' ; IP2 = '127.0.0.2' ; Mask = -1    ; Switch1 = $null ; Switch2 = $null ; Throw = '*is not a valid IPv4 mask*'}
            @{IP = '127.0.0.1' ; IP2 = '127.0.0.2' ; Mask = $null ; Switch1 = $null ; Switch2 = $null ; Throw = '*No mask defined for either*'}
            @{IP = '127.0.0.1' ; IP2 = '127.0.0.2' ; Mask = $null ; Switch1 = 'Abc' ; Switch2 = $null ; Throw = '*A parameter cannot be found that matches parameter name*'}
        )

        It 'Test-IPv4AddressInSameNet -IP <IP> -IP2 <IP2> -Mask <Mask> -<Switch1> -<Switch2>  (throw)' -TestCases $testCasesThrow1 {
            param ($IP, $IP2, $Mask, $Switch1, $Switch2, $Throw)
            $params = @{
                IP  = $IP
                IP2 = $IP2
            }
            if ($Mask    -ne $null) {$params['Mask']   = $Mask}
            if ($Switch1 -ne $null) {$params[$Switch1] = $true}
            if ($Switch2 -ne $null) {$params[$Switch2] = $true}
            {Test-IPv4AddressInSameNet @params -ErrorAction Stop} | Should -Throw $Throw
        }
    }
}
