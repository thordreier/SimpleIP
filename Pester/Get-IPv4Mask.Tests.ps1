# Invoke-Pester -Path .\Pester\Get-IPv4Mask.Tests.ps1 -Output Detailed
Describe 'Get-IPv4Mask' {

    Context PositionalArgmuent {
        It 'Positional argmuent1' {
            $r = Get-IPv4Mask 10.9.8.7/23 -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be 255.255.254.0
        }

        It 'Positional argmuent2' {
            $r = Get-IPv4Mask 10.9.8.7/255.255.255.0 -Length -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be 24
        }
    }

    Context TestCasesMask1 {
        $testCasesMask1 = @(
            # For some reason Pester confuse "Length" and "LengthWithSlash" and creates a
            # "Cannot bind parameter because parameter 'Length' is specified more than once"
            # Thats why a "x" was added
            @{IP = '0.0.0.0/0'                     ; QuadDot = '0.0.0.0'         ; Length =  '0' ; xLengthWithSlash = '/0'  }
            @{IP = '255.255.255.255/0'             ; QuadDot = '0.0.0.0'         ; Length =  '0' ; xLengthWithSlash = '/0'  }
            @{IP = '0.0.0.0/255.255.255.255'       ; QuadDot = '255.255.255.255' ; Length = '32' ; xLengthWithSlash = '/32' }
            @{IP = '10.2.4.6/8'                    ; QuadDot = '255.0.0.0'       ; Length =  '8' ; xLengthWithSlash = '/8'  }
            @{IP = '10.2.4.6/15'                   ; QuadDot = '255.254.0.0'     ; Length = '15' ; xLengthWithSlash = '/15' }
            @{IP = '10.2.4.6/16'                   ; QuadDot = '255.255.0.0'     ; Length = '16' ; xLengthWithSlash = '/16' }
            @{IP = '10.2.4.6/17'                   ; QuadDot = '255.255.128.0'   ; Length = '17' ; xLengthWithSlash = '/17' }
            @{IP = '10.2.4.6/24'                   ; QuadDot = '255.255.255.0'   ; Length = '24' ; xLengthWithSlash = '/24' }
            @{IP = '192.168.55.66 255.255.255.224' ; QuadDot = '255.255.255.224' ; Length = '27' ; xLengthWithSlash = '/27' }
            @{IP = '192.168.55.66/27'              ; QuadDot = '255.255.255.224' ; Length = '27' ; xLengthWithSlash = '/27' }
            @{IP = '172.16.17.18/30'               ; QuadDot = '255.255.255.252' ; Length = '30' ; xLengthWithSlash = '/30' }
            @{IP = '172.16.17.18/30'               ; QuadDot = '255.255.255.252' ; Length = '30' ; xLengthWithSlash = '/30' }
            @{IP = '100.64.9.99/31'                ; QuadDot = '255.255.255.254' ; Length = '31' ; xLengthWithSlash = '/31' }
            @{IP = '100.64.9.99/31'                ; QuadDot = '255.255.255.254' ; Length = '31' ; xLengthWithSlash = '/31' }
            @{IP = '1.1.1.1/32'                    ; QuadDot = '255.255.255.255' ; Length = '32' ; xLengthWithSlash = '/32' }
        )

        It 'Get-IPv4Mask -QuadDot -IP <IP> == <QuadDot>' -TestCases $testCasesMask1 {
            param ($IP, $QuadDot)
            $params = @{
                QuadDot = $true
                IP      = $IP
            }
            $r = Get-IPv4Mask @params -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $QuadDot
        }

        It 'Get-IPv4Mask -Length -IP <IP> == <Length>' -TestCases $testCasesMask1 {
            param ($IP, $Length)
            $params = @{
                Length = $true
                IP     = $IP
            }
            $r = Get-IPv4Mask @params -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Length
        }

        It 'Get-IPv4Mask -LengthWithSlash -IP <IP> == <xLengthWithSlash>' -TestCases $testCasesMask1 {
            param ($IP, $xLengthWithSlash)
            $params = @{
                LengthWithSlash = $true
                IP              = $IP
            }
            $r = Get-IPv4Mask @params -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $xLengthWithSlash
        }
    }

    Context TestCasesThrow1 {
        $testCasesThrow1 = @(
            @{IP = -1          ; Switch1 = $null    ; Switch2 = $null    ; Throw = '*is not a valid IPv4 address*'}
            @{IP = 22          ; Switch1 = $null    ; Switch2 = $null    ; Throw = '*is not a valid IPv4 address*'}
            @{IP = -1          ; Switch1 = $null    ; Switch2 = $null    ; Throw = '*is not a valid IPv4*'}
            @{IP = '127.0.0.1' ; Switch1 = $null    ; Switch2 = $null    ; Throw = '*No mask defined for*'}
            @{IP = '127.0.0.1' ; Switch1 = $null    ; Switch2 = $null    ; Throw = '*No mask defined*'}
            @{IP = '127.0.0.1' ; Switch1 = 'Abc'    ; Switch2 = $null    ; Throw = '*A parameter cannot be found that matches parameter name*'}
            @{IP = '127.0.0.1' ; Switch1 = 'Subnet' ; Switch2 = $null    ; Throw = '*A parameter cannot be found that matches parameter name*'}
            @{IP = '127.0.0.1' ; Switch1 = 'QuadDot'; Switch2 = 'Length' ; Throw = '*Parameter set cannot be resolved using the specified named parameters*'}
        )

        It 'Get-IPv4Mask -IP <IP> -<Switch1> -<Switch2>  (throw)' -TestCases $testCasesThrow1 {
            param ($IP, $Switch1, $Switch2, $Throw)
            $params = @{}
            if ($IP      -ne $null) {$params['IP']     = $IP}
            if ($Switch1 -ne $null) {$params[$Switch1] = $true}
            if ($Switch2 -ne $null) {$params[$Switch2] = $true}
            {Get-IPv4Mask @params -ErrorAction Stop} | Should -Throw $Throw
        }
    }
}
