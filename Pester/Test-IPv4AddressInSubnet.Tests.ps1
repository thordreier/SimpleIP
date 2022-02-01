# Invoke-Pester -Path .\Pester\Test-IPv4AddressInSubnet.Tests.ps1 -Output Detailed
Describe 'Test-IPv4AddressInSubnet' {

    It 'Positional argmuent' {
        $r = Test-IPv4AddressInSubnet 10.11.12.0/24 10.11.12.14 -ErrorAction Stop
        $r | Should -BeOfType 'System.Boolean'
        $r | Should -Be $true
    }

    Context TestCases1 {
        $testCases1 = @(
            @{Subnet = '10.10.10.0/24'   ; IP = '10.10.10.250/24'  ; Mask = $null ; Default = $true  ; Mismatch = $true }
            @{Subnet = '10.10.10.0/23'   ; IP = '10.10.10.250/24'  ; Mask = $null ; Default = $false ; Mismatch = $true }
            @{Subnet = '10.10.22.0/24'   ; IP = '10.10.10.250/24'  ; Mask = $null ; Default = $false ; Mismatch = $false}
            @{Subnet = '10.10.0.0'       ; IP = '10.10.10.250'     ; Mask = 16    ; Default = $true  ; Mismatch = $true }
            @{Subnet = '10.10.22.0'      ; IP = '10.10.10.250'     ; Mask = 24    ; Default = $false ; Mismatch = $false}
            @{Subnet = '10.10.10.200/29' ; IP = '10.10.10.105/24'  ; Mask = $null ; Default = $false ; Mismatch = $false}
            @{Subnet = '10.10.10.200/29' ; IP = '10.10.10.205/24'  ; Mask = $null ; Default = $false ; Mismatch = $true }
            @{Subnet = '10.10.10.200/29' ; IP = '10.10.10.205/29'  ; Mask = $null ; Default = $true  ; Mismatch = $true }
            @{Subnet = '10.10.10.200/29' ; IP = '10.10.10.205'     ; Mask = $null ; Default = $true  ; Mismatch = $true }
        )

        It 'Test-IPv4AddressInSubnet -Subnet <Subnet> -IP <IP> -Mask <Mask> == <Default>' -TestCases $testCases1 {
            param ($Subnet, $IP, $Mask, $Default)
            $params = @{
                Subnet = $Subnet
                IP     = $IP
            }
            if ($Mask -ne $null) { $params['Mask'] = $Mask }
            $r = Test-IPv4AddressInSubnet @params -ErrorAction Stop
            $r | Should -BeOfType 'System.Boolean'
            $r | Should -Be $Default
        }

        It 'Test-IPv4AddressInSubnet -Subnet <Subnet> -IP <IP> -Mask <Mask> -AllowMaskMismatch == <Mismatch>' -TestCases $testCases1 {
            param ($Subnet, $IP, $Mask, $Mismatch)
            $params = @{
                Subnet            = $Subnet
                IP                = $IP
                AllowMaskMismatch = $true
            }
            if ($Mask -ne $null) { $params['Mask'] = $Mask }
            $r = Test-IPv4AddressInSubnet @params -ErrorAction Stop
            $r | Should -BeOfType 'System.Boolean'
            $r | Should -Be $Mismatch
        }
    }

    Context Warning {
        It 'Test-IPv4AddressInSubnet -Subnet 1.0.0.0/8 -IP 1.2.3.5/24 -Mask 8  (warning)' {
            {Test-IPv4AddressInSubnet -Subnet 1.0.0.0/8 -IP 1.2.3.5/24 -Mask 8 -ErrorAction Stop -WarningAction Stop 3>$null} | Should -Throw '*Mask set to*but*Using*'
        }

        It 'Test-IPv4AddressInSubnet -Subnet 1.2.3.4/30 -IP 1.2.3.4  (warning)' {
            {Test-IPv4AddressInSubnet -Subnet 1.2.3.4/30 -IP 1.2.3.4 -ErrorAction Stop -WarningAction Stop 3>$null} | Should -Throw '*is the same*'
        }
    }

    Context TestCasesThrow1 {
        $testCasesThrow1 = @(
            @{Subnet = -1            ; IP = $null         ; Mask = $null ; Switch1 = $null ; Switch2 = $null ; Throw = '*Cannot validate argument on parameter*'}
            @{Subnet = 22            ; IP = 22            ; Mask = $null ; Switch1 = $null ; Switch2 = $null ; Throw = '*is not a valid IPv4 address*'}
            @{Subnet = -1            ; IP = '1.2.3.4'     ; Mask = -1    ; Switch1 = $null ; Switch2 = $null ; Throw = '*is not a valid IPv4*'}
            @{Subnet = '127.0.0.0/8' ; IP = '127.0.0.2'   ; Mask = -1    ; Switch1 = $null ; Switch2 = $null ; Throw = '*is not a valid IPv4 mask*'}
            @{Subnet = '127.0.0.0'   ; IP = '127.0.0.2'   ; Mask = -1    ; Switch1 = $null ; Switch2 = $null ; Throw = '*is not a valid IPv4 mask*'}
            @{Subnet = '127.0.0.0'   ; IP = '127.0.0.2'   ; Mask = $null ; Switch1 = $null ; Switch2 = $null ; Throw = '*is not a subnet*'}
            @{Subnet = '127.0.0.0'   ; IP = '127.0.0.2'   ; Mask = $null ; Switch1 = 'Abc' ; Switch2 = $null ; Throw = '*A parameter cannot be found that matches parameter name*'}
            @{Subnet = '127.0.0.0'   ; IP = '127.0.0.2/8' ; Mask = $null ; Switch1 = $null ; Switch2 = $null ; Throw = '*is not a subnet*'}
        )

        It 'Test-IPv4AddressInSubnet -Subnet <Subnet> -IP <IP> -Mask <Mask> -<Switch1> -<Switch2>  (throw)' -TestCases $testCasesThrow1 {
            param ($Subnet, $IP, $Mask, $Switch1, $Switch2, $Throw)
            $params = @{
                Subnet = $Subnet
                IP     = $IP
            }
            if ($Mask    -ne $null) {$params['Mask']   = $Mask}
            if ($Switch1 -ne $null) {$params[$Switch1] = $true}
            if ($Switch2 -ne $null) {$params[$Switch2] = $true}
            {Test-IPv4AddressInSubnet @params -ErrorAction Stop} | Should -Throw $Throw
        }
    }
}
