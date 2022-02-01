# Invoke-Pester -Path .\Pester\Get-IPv4Subnet.Tests.ps1 -Output Detailed
Describe 'Get-IPv4Subnet' {

    Context PositionalArgmuent {
        It 'Positional argmuent1' {
            $r = Get-IPv4Subnet '10.9.9.7 255.255.254.0' -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be 10.9.8.0/23
        }

        It 'Positional argmuent2' {
            $r = Get-IPv4Subnet 10.9.8.7/22 -WithMask -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be '10.9.8.0 255.255.252.0'
        }
    }

    Context TestCasesWithMaskLength1 {
        $testCasesWithMaskLength1 = @(
            @{IP = '0.0.0.0'                       ; Mask = 0                 ; Subnet = '0.0.0.0/0'       }
            @{IP = '255.255.255.255/0'             ; Mask = $null             ; Subnet = '0.0.0.0/0'       }
            @{IP = '0.0.0.0/255.255.255.255'       ; Mask = 32                ; Subnet = '0.0.0.0/32'      }
            @{IP = '10.2.4.6/8'                    ; Mask = $null             ; Subnet = '10.0.0.0/8'      }
            @{IP = '10.2.4.6/15'                   ; Mask = $null             ; Subnet = '10.2.0.0/15'     }
            @{IP = '10.2.4.6/16'                   ; Mask = $null             ; Subnet = '10.2.0.0/16'     }
            @{IP = '10.2.4.6/17'                   ; Mask = $null             ; Subnet = '10.2.0.0/17'     }
            @{IP = '10.2.4.6/24'                   ; Mask = $null             ; Subnet = '10.2.4.0/24'     }
            @{IP = '192.168.55.66 255.255.255.224' ; Mask = 27                ; Subnet = '192.168.55.64/27'}
            @{IP = '192.168.55.66/27'              ; Mask = '255.255.255.224' ; Subnet = '192.168.55.64/27'}
            @{IP = '172.16.17.18/30'               ; Mask = $null             ; Subnet = '172.16.17.16/30' }
            @{IP = '172.16.17.18/30'               ; Mask = $null             ; Subnet = '172.16.17.16/30' }
            @{IP = '100.64.9.99/31'                ; Mask = $null             ; Subnet = '100.64.9.98/31'  }
            @{IP = '100.64.9.99/31'                ; Mask = $null             ; Subnet = '100.64.9.98/31'  }
            @{IP = '1.1.1.1'                       ; Mask = 32                ; Subnet = '1.1.1.1/32'      }
        )

        It 'Get-IPv4Subnet -WithMaskLength -IP <IP> -Mask <Mask> == <Subnet>' -TestCases $testCasesWithMaskLength1 {
            param ($IP, $Mask, $Subnet)
            $params = @{
                WithMaskLength = $true
                IP             = $IP
            }
            if ($Mask -ne $null) { $params['Mask'] = $Mask }
            $r = Get-IPv4Subnet @params -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Subnet
        }
    }

    Context TestCasesWithMask1 {
        $testCasesWithMask1 = @(
            @{IP = '0.0.0.0'                       ; Mask = 0                 ; Subnet = '0.0.0.0 0.0.0.0'              }
            @{IP = '255.255.255.255/0'             ; Mask = $null             ; Subnet = '0.0.0.0 0.0.0.0'              }
            @{IP = '0.0.0.0/255.255.255.255'       ; Mask = 32                ; Subnet = '0.0.0.0 255.255.255.255'      }
            @{IP = '10.2.4.6/8'                    ; Mask = $null             ; Subnet = '10.0.0.0 255.0.0.0'           }
            @{IP = '10.2.4.6/15'                   ; Mask = $null             ; Subnet = '10.2.0.0 255.254.0.0'         }
            @{IP = '10.2.4.6/16'                   ; Mask = $null             ; Subnet = '10.2.0.0 255.255.0.0'         }
            @{IP = '10.2.4.6/17'                   ; Mask = $null             ; Subnet = '10.2.0.0 255.255.128.0'       }
            @{IP = '10.2.4.6/24'                   ; Mask = $null             ; Subnet = '10.2.4.0 255.255.255.0'       }
            @{IP = '192.168.55.66 255.255.255.224' ; Mask = 27                ; Subnet = '192.168.55.64 255.255.255.224'}
            @{IP = '192.168.55.66/27'              ; Mask = '255.255.255.224' ; Subnet = '192.168.55.64 255.255.255.224'}
            @{IP = '172.16.17.18/30'               ; Mask = $null             ; Subnet = '172.16.17.16 255.255.255.252' }
            @{IP = '172.16.17.18/30'               ; Mask = $null             ; Subnet = '172.16.17.16 255.255.255.252' }
            @{IP = '100.64.9.99/31'                ; Mask = $null             ; Subnet = '100.64.9.98 255.255.255.254'  }
            @{IP = '100.64.9.99/31'                ; Mask = $null             ; Subnet = '100.64.9.98 255.255.255.254'  }
            @{IP = '1.1.1.1'                       ; Mask = 32                ; Subnet = '1.1.1.1 255.255.255.255'      }
        )

        It 'Get-IPv4Subnet -WithMask -Subnet -IP <IP> -Mask <Mask> == <Subnet>' -TestCases $testCasesWithMask1 {
            param ($IP, $Mask, $Subnet)
            $params = @{
                WithMask = $true
                IP       = $IP
            }
            if ($Mask -ne $null) { $params['Mask'] = $Mask }
            $r = Get-IPv4Subnet @params -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Subnet
        }
    }

    Context TestCasesIPOnly1 {
        $testCasesIPOnly1 = @(
            @{IP = '0.0.0.0'                       ; Mask = 0                 ; Subnet = '0.0.0.0'      }
            @{IP = '255.255.255.255/0'             ; Mask = $null             ; Subnet = '0.0.0.0'      }
            @{IP = '0.0.0.0/255.255.255.255'       ; Mask = 32                ; Subnet = '0.0.0.0'      }
            @{IP = '10.2.4.6/8'                    ; Mask = $null             ; Subnet = '10.0.0.0'     }
            @{IP = '10.2.4.6/15'                   ; Mask = $null             ; Subnet = '10.2.0.0'     }
            @{IP = '10.2.4.6/16'                   ; Mask = $null             ; Subnet = '10.2.0.0'     }
            @{IP = '10.2.4.6/17'                   ; Mask = $null             ; Subnet = '10.2.0.0'     }
            @{IP = '10.2.4.6/24'                   ; Mask = $null             ; Subnet = '10.2.4.0'     }
            @{IP = '192.168.55.66 255.255.255.224' ; Mask = 27                ; Subnet = '192.168.55.64'}
            @{IP = '192.168.55.66/27'              ; Mask = '255.255.255.224' ; Subnet = '192.168.55.64'}
            @{IP = '172.16.17.18/30'               ; Mask = $null             ; Subnet = '172.16.17.16' }
            @{IP = '172.16.17.18/30'               ; Mask = $null             ; Subnet = '172.16.17.16' }
            @{IP = '100.64.9.99/31'                ; Mask = $null             ; Subnet = '100.64.9.98'  }
            @{IP = '100.64.9.99/31'                ; Mask = $null             ; Subnet = '100.64.9.98'  }
            @{IP = '1.1.1.1'                       ; Mask = 32                ; Subnet = '1.1.1.1'      }
        )

        It 'Get-IPv4Subnet -IPOnly -Subnet -IP <IP> -Mask <Mask> == <Subnet>' -TestCases $testCasesIPOnly1 {
            param ($IP, $Mask, $Subnet)
            $params = @{
                IPOnly = $true
                IP     = $IP
            }
            if ($Mask -ne $null) { $params['Mask'] = $Mask }
            $r = Get-IPv4Subnet @params -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Subnet
        }
    }

    Context Warning {
        It 'Get-IPv4Subnet -IP 1.2.3.4/8 -Mask 24  (warning)' {
            {Get-IPv4Subnet -IP 1.2.3.4/8 -Mask 24 -ErrorAction Stop -WarningAction Stop 3>$null} | Should -Throw '*Mask set to*but*Using*'
        }
    }

    Context TestCasesThrow1 {
        $testCasesThrow1 = @(
            @{IP = -1          ; Mask = $null ; Switch1 = $null     ; Switch2 = $null    ; Throw = '*is not a valid IPv4 address*'}
            @{IP = 22          ; Mask = $null ; Switch1 = $null     ; Switch2 = $null    ; Throw = '*is not a valid IPv4 address*'}
            @{IP = -1          ; Mask = -1    ; Switch1 = $null     ; Switch2 = $null    ; Throw = '*is not a valid IPv4*'}
            @{IP = '127.0.0.1' ; Mask = -1    ; Switch1 = $null     ; Switch2 = $null    ; Throw = '*is not a valid IPv4 mask*'}
            @{IP = '127.0.0.1' ; Mask = $null ; Switch1 = $null     ; Switch2 = $null    ; Throw = '*No mask defined*'}
            @{IP = '127.0.0.1' ; Mask = $null ; Switch1 = 'Abc'     ; Switch2 = $null    ; Throw = '*A parameter cannot be found that matches parameter name*'}
            @{IP = '127.0.0.1' ; Mask = $null ; Switch1 = 'Subnet'  ; Switch2 = $null    ; Throw = '*A parameter cannot be found that matches parameter name*'}
            @{IP = '127.0.0.1' ; Mask = $null ; Switch1 = 'QuadDot' ; Switch2 = 'Length' ; Throw = '*A parameter cannot be found that matches parameter name*'}
        )

        It 'Get-IPv4Subnet -IP <IP> -Mask <Mask> -<Switch1> -<Switch2>  (throw)' -TestCases $testCasesThrow1 {
            param ($IP, $Mask, $Switch1, $Switch2, $Throw)
            $params = @{}
            if ($IP      -ne $null) {$params['IP']     = $IP}
            if ($Mask    -ne $null) {$params['Mask']   = $Mask}
            if ($Switch1 -ne $null) {$params[$Switch1] = $true}
            if ($Switch2 -ne $null) {$params[$Switch2] = $true}
            {Get-IPv4Subnet @params -ErrorAction Stop} | Should -Throw $Throw
        }
    }
}
