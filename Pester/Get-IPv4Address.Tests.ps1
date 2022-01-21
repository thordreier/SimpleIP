# Invoke-Pester -Path .\Pester\Get-IPv4Address.Tests.ps1 -Output Detailed
Describe 'Get-IPv4Address' {

    It 'Positional argmuent' {
        $r = Get-IPv4Address 10.9.8.7/255.255.255.0 -Subnet -ErrorAction Stop
        $r | Should -BeOfType 'System.String'
        $r | Should -Be 10.9.8.0/24
    }

    Context TestCasesWithMaskLength1 {
        $testCasesWithMaskLength1 = @(
            @{Ip = '0.0.0.0'                       ; Mask = 0                 ; Pool = $false ; Subnet = '0.0.0.0/0'        ; First = '0.0.0.1/0'        ; Last = '255.255.255.254/0' ; Broadcast = '255.255.255.255/0' ; AllCount = $null}
            @{Ip = '255.255.255.255/0'             ; Mask = $null             ; Pool = $false ; Subnet = '0.0.0.0/0'        ; First = '0.0.0.1/0'        ; Last = '255.255.255.254/0' ; Broadcast = '255.255.255.255/0' ; AllCount = $null}
            @{Ip = '0.0.0.0/255.255.255.255'       ; Mask = 32                ; Pool = $false ; Subnet = '0.0.0.0/32'       ; First = '0.0.0.0/32'       ; Last = '0.0.0.0/32'        ; Broadcast = '0.0.0.0/32'        ; AllCount = $null}
            @{Ip = '10.2.4.6/8'                    ; Mask = $null             ; Pool = $false ; Subnet = '10.0.0.0/8'       ; First = '10.0.0.1/8'       ; Last = '10.255.255.254/8'  ; Broadcast = '10.255.255.255/8'  ; AllCount = $null}
            @{Ip = '10.2.4.6/15'                   ; Mask = $null             ; Pool = $false ; Subnet = '10.2.0.0/15'      ; First = '10.2.0.1/15'      ; Last = '10.3.255.254/15'   ; Broadcast = '10.3.255.255/15'   ; AllCount = $null}
            @{Ip = '10.2.4.6/16'                   ; Mask = $null             ; Pool = $false ; Subnet = '10.2.0.0/16'      ; First = '10.2.0.1/16'      ; Last = '10.2.255.254/16'   ; Broadcast = '10.2.255.255/16'   ; AllCount = $null}
            @{Ip = '10.2.4.6/17'                   ; Mask = $null             ; Pool = $false ; Subnet = '10.2.0.0/17'      ; First = '10.2.0.1/17'      ; Last = '10.2.127.254/17'   ; Broadcast = '10.2.127.255/17'   ; AllCount = $null}
            @{Ip = '10.2.4.6/24'                   ; Mask = $null             ; Pool = $false ; Subnet = '10.2.4.0/24'      ; First = '10.2.4.1/24'      ; Last = '10.2.4.254/24'     ; Broadcast = '10.2.4.255/24'     ; AllCount = 254  }
            @{Ip = '192.168.55.66 255.255.255.224' ; Mask = 27                ; Pool = $false ; Subnet = '192.168.55.64/27' ; First = '192.168.55.65/27' ; Last = '192.168.55.94/27'  ; Broadcast = '192.168.55.95/27'  ; AllCount =  30  }
            @{Ip = '192.168.55.66/27'              ; Mask = '255.255.255.224' ; Pool = $true  ; Subnet = '192.168.55.64/27' ; First = '192.168.55.64/27' ; Last = '192.168.55.95/27'  ; Broadcast = '192.168.55.95/27'  ; AllCount =  32  }
            @{Ip = '172.16.17.18/30'               ; Mask = $null             ; Pool = $false ; Subnet = '172.16.17.16/30'  ; First = '172.16.17.17/30'  ; Last = '172.16.17.18/30'   ; Broadcast = '172.16.17.19/30'   ; AllCount =   2  }
            @{Ip = '172.16.17.18/30'               ; Mask = $null             ; Pool = $true  ; Subnet = '172.16.17.16/30'  ; First = '172.16.17.16/30'  ; Last = '172.16.17.19/30'   ; Broadcast = '172.16.17.19/30'   ; AllCount =   4  }
            @{Ip = '100.64.9.99/31'                ; Mask = $null             ; Pool = $false ; Subnet = '100.64.9.98/31'   ; First = '100.64.9.98/31'   ; Last = '100.64.9.99/31'    ; Broadcast = '100.64.9.99/31'    ; AllCount =   2  }
            @{Ip = '100.64.9.99/31'                ; Mask = $null             ; Pool = $true  ; Subnet = '100.64.9.98/31'   ; First = '100.64.9.98/31'   ; Last = '100.64.9.99/31'    ; Broadcast = '100.64.9.99/31'    ; AllCount =   2  }
            @{Ip = '1.1.1.1'                       ; Mask = 32                ; Pool = $false ; Subnet = '1.1.1.1/32'       ; First = '1.1.1.1/32'       ; Last = '1.1.1.1/32'        ; Broadcast = '1.1.1.1/32'        ; AllCount =   1  }
        )

        It 'Get-IPv4Address -WithMaskLength -Subnet -Ip <Ip> -Mask <Mask> -Pool:<Pool> == <Subnet>' -TestCases $testCasesWithMaskLength1 {
            param ($Ip, $Mask, $Pool, $Subnet)
            $params = @{
                WithMaskLength = $true
                Subnet         = $true
                Ip             = $Ip
                Pool           = $Pool
            }
            if ($Mask -ne $null) { $params['Mask'] = $Mask }
            $r = Get-IPv4Address @params -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Subnet
        }

        It 'Get-IPv4Address -WithMaskLength -First -Ip <Ip> -Mask <Mask> -Pool:<Pool> == <First>' -TestCases $testCasesWithMaskLength1 {
            param ($Ip, $Mask, $Pool, $First)
            $params = @{
                WithMaskLength = $true
                First          = $true
                Ip             = $Ip
                Pool           = $Pool
            }
            if ($Mask -ne $null) { $params['Mask'] = $Mask }
            $r = Get-IPv4Address @params -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $First
        }

        It 'Get-IPv4Address -WithMaskLength -Last -Ip <Ip> -Mask <Mask> -Pool:<Pool> == <Last>' -TestCases $testCasesWithMaskLength1 {
            param ($Ip, $Mask, $Pool, $Last)
            $params = @{
                WithMaskLength = $true
                Last           = $true
                Ip             = $Ip
                Pool           = $Pool
            }
            if ($Mask -ne $null) { $params['Mask'] = $Mask }
            $r = Get-IPv4Address @params -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Last
        }

        It 'Get-IPv4Address -WithMaskLength -Broadcast -Ip <Ip> -Mask <Mask> -Pool:<Pool> == <Broadcast>' -TestCases $testCasesWithMaskLength1 {
            param ($Ip, $Mask, $Pool, $Broadcast)
            $params = @{
                WithMaskLength = $true
                Broadcast      = $true
                Ip             = $Ip
                Pool           = $Pool
            }
            if ($Mask -ne $null) { $params['Mask'] = $Mask }
            $r = Get-IPv4Address @params -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Broadcast
        }

        It '(Get-IPv4Address -WithMaskLength -All -Ip <Ip> -Mask <Mask> -Pool:<Pool>).Count == <AllCount>' -TestCases $testCasesWithMaskLength1.Where({$_.AllCount}) {
            param ($Ip, $Mask, $Pool, $AllCount)
            $params = @{
                WithMaskLength = $true
                All            = $true
                Ip             = $Ip
                Pool           = $Pool
            }
            if ($Mask -ne $null) { $params['Mask'] = $Mask }
            $r = @(Get-IPv4Address @params -ErrorAction Stop)
            $r[0]    | Should -BeOfType 'System.String'
            $r.Count | Should -Be $AllCount
        }
    }

    Context TestCasesWithMask1 {
        $testCasesWithMask1 = @(
            @{Ip = '0.0.0.0'                       ; Mask = 0                 ; Pool = $false ; Subnet = '0.0.0.0 0.0.0.0'               ; First = '0.0.0.1 0.0.0.0'               ; Last = '255.255.255.254 0.0.0.0'       ; Broadcast = '255.255.255.255 0.0.0.0'       ; AllCount = $null}
            @{Ip = '255.255.255.255/0'             ; Mask = $null             ; Pool = $false ; Subnet = '0.0.0.0 0.0.0.0'               ; First = '0.0.0.1 0.0.0.0'               ; Last = '255.255.255.254 0.0.0.0'       ; Broadcast = '255.255.255.255 0.0.0.0'       ; AllCount = $null}
            @{Ip = '0.0.0.0/255.255.255.255'       ; Mask = 32                ; Pool = $false ; Subnet = '0.0.0.0 255.255.255.255'       ; First = '0.0.0.0 255.255.255.255'       ; Last = '0.0.0.0 255.255.255.255'       ; Broadcast = '0.0.0.0 255.255.255.255'       ; AllCount = $null}
            @{Ip = '10.2.4.6/8'                    ; Mask = $null             ; Pool = $false ; Subnet = '10.0.0.0 255.0.0.0'            ; First = '10.0.0.1 255.0.0.0'            ; Last = '10.255.255.254 255.0.0.0'      ; Broadcast = '10.255.255.255 255.0.0.0'      ; AllCount = $null}
            @{Ip = '10.2.4.6/15'                   ; Mask = $null             ; Pool = $false ; Subnet = '10.2.0.0 255.254.0.0'          ; First = '10.2.0.1 255.254.0.0'          ; Last = '10.3.255.254 255.254.0.0'      ; Broadcast = '10.3.255.255 255.254.0.0'      ; AllCount = $null}
            @{Ip = '10.2.4.6/16'                   ; Mask = $null             ; Pool = $false ; Subnet = '10.2.0.0 255.255.0.0'          ; First = '10.2.0.1 255.255.0.0'          ; Last = '10.2.255.254 255.255.0.0'      ; Broadcast = '10.2.255.255 255.255.0.0'      ; AllCount = $null}
            @{Ip = '10.2.4.6/17'                   ; Mask = $null             ; Pool = $false ; Subnet = '10.2.0.0 255.255.128.0'        ; First = '10.2.0.1 255.255.128.0'        ; Last = '10.2.127.254 255.255.128.0'    ; Broadcast = '10.2.127.255 255.255.128.0'    ; AllCount = $null}
            @{Ip = '10.2.4.6/24'                   ; Mask = $null             ; Pool = $false ; Subnet = '10.2.4.0 255.255.255.0'        ; First = '10.2.4.1 255.255.255.0'        ; Last = '10.2.4.254 255.255.255.0'      ; Broadcast = '10.2.4.255 255.255.255.0'      ; AllCount = 254  }
            @{Ip = '192.168.55.66 255.255.255.224' ; Mask = 27                ; Pool = $false ; Subnet = '192.168.55.64 255.255.255.224' ; First = '192.168.55.65 255.255.255.224' ; Last = '192.168.55.94 255.255.255.224' ; Broadcast = '192.168.55.95 255.255.255.224' ; AllCount =  30  }
            @{Ip = '192.168.55.66/27'              ; Mask = '255.255.255.224' ; Pool = $true  ; Subnet = '192.168.55.64 255.255.255.224' ; First = '192.168.55.64 255.255.255.224' ; Last = '192.168.55.95 255.255.255.224' ; Broadcast = '192.168.55.95 255.255.255.224' ; AllCount =  32  }
            @{Ip = '172.16.17.18/30'               ; Mask = $null             ; Pool = $false ; Subnet = '172.16.17.16 255.255.255.252'  ; First = '172.16.17.17 255.255.255.252'  ; Last = '172.16.17.18 255.255.255.252'  ; Broadcast = '172.16.17.19 255.255.255.252'  ; AllCount =   2  }
            @{Ip = '172.16.17.18/30'               ; Mask = $null             ; Pool = $true  ; Subnet = '172.16.17.16 255.255.255.252'  ; First = '172.16.17.16 255.255.255.252'  ; Last = '172.16.17.19 255.255.255.252'  ; Broadcast = '172.16.17.19 255.255.255.252'  ; AllCount =   4  }
            @{Ip = '100.64.9.99/31'                ; Mask = $null             ; Pool = $false ; Subnet = '100.64.9.98 255.255.255.254'   ; First = '100.64.9.98 255.255.255.254'   ; Last = '100.64.9.99 255.255.255.254'   ; Broadcast = '100.64.9.99 255.255.255.254'   ; AllCount =   2  }
            @{Ip = '100.64.9.99/31'                ; Mask = $null             ; Pool = $true  ; Subnet = '100.64.9.98 255.255.255.254'   ; First = '100.64.9.98 255.255.255.254'   ; Last = '100.64.9.99 255.255.255.254'   ; Broadcast = '100.64.9.99 255.255.255.254'   ; AllCount =   2  }
            @{Ip = '1.1.1.1'                       ; Mask = 32                ; Pool = $false ; Subnet = '1.1.1.1 255.255.255.255'       ; First = '1.1.1.1 255.255.255.255'       ; Last = '1.1.1.1 255.255.255.255'       ; Broadcast = '1.1.1.1 255.255.255.255'       ; AllCount =   1  }
        )

        It 'Get-IPv4Address -WithMask -Subnet -Ip <Ip> -Mask <Mask> -Pool:<Pool> == <Subnet>' -TestCases $testCasesWithMask1 {
            param ($Ip, $Mask, $Pool, $Subnet)
            $params = @{
                WithMask = $true
                Subnet   = $true
                Ip       = $Ip
                Pool     = $Pool
            }
            if ($Mask -ne $null) { $params['Mask'] = $Mask }
            $r = Get-IPv4Address @params -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Subnet
        }

        It 'Get-IPv4Address -WithMask -First -Ip <Ip> -Mask <Mask> -Pool:<Pool> == <First>' -TestCases $testCasesWithMask1 {
            param ($Ip, $Mask, $Pool, $First)
            $params = @{
                WithMask = $true
                First    = $true
                Ip       = $Ip
                Pool     = $Pool
            }
            if ($Mask -ne $null) { $params['Mask'] = $Mask }
            $r = Get-IPv4Address @params -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $First
        }

        It 'Get-IPv4Address -WithMask -Last -Ip <Ip> -Mask <Mask> -Pool:<Pool> == <Last>' -TestCases $testCasesWithMask1 {
            param ($Ip, $Mask, $Pool, $Last)
            $params = @{
                WithMask = $true
                Last     = $true
                Ip       = $Ip
                Pool     = $Pool
            }
            if ($Mask -ne $null) { $params['Mask'] = $Mask }
            $r = Get-IPv4Address @params -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Last
        }

        It 'Get-IPv4Address -WithMask -Broadcast -Ip <Ip> -Mask <Mask> -Pool:<Pool> == <Broadcast>' -TestCases $testCasesWithMask1 {
            param ($Ip, $Mask, $Pool, $Broadcast)
            $params = @{
                WithMask  = $true
                Broadcast = $true
                Ip        = $Ip
                Pool      = $Pool
            }
            if ($Mask -ne $null) { $params['Mask'] = $Mask }
            $r = Get-IPv4Address @params -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Broadcast
        }

        It '(Get-IPv4Address -WithMask -All -Ip <Ip> -Mask <Mask> -Pool:<Pool>).Count == <AllCount>' -TestCases $testCasesWithMask1.Where({$_.AllCount}) {
            param ($Ip, $Mask, $Pool, $AllCount)
            $params = @{
                WithMask = $true
                All      = $true
                Ip       = $Ip
                Pool     = $Pool
            }
            if ($Mask -ne $null) { $params['Mask'] = $Mask }
            $r = @(Get-IPv4Address @params -ErrorAction Stop)
            $r[0]    | Should -BeOfType 'System.String'
            $r.Count | Should -Be $AllCount
        }
    }

    Context TestCasesIpOnly1 {
        $testCasesIpOnly1 = @(
            @{Ip = '0.0.0.0'                       ; Mask = 0                 ; Pool = $false ; Subnet = '0.0.0.0'       ; First = '0.0.0.1'       ; Last = '255.255.255.254' ; Broadcast = '255.255.255.255' ; AllCount = $null}
            @{Ip = '255.255.255.255/0'             ; Mask = $null             ; Pool = $false ; Subnet = '0.0.0.0'       ; First = '0.0.0.1'       ; Last = '255.255.255.254' ; Broadcast = '255.255.255.255' ; AllCount = $null}
            @{Ip = '0.0.0.0/255.255.255.255'       ; Mask = 32                ; Pool = $false ; Subnet = '0.0.0.0'       ; First = '0.0.0.0'       ; Last = '0.0.0.0'         ; Broadcast = '0.0.0.0'         ; AllCount = $null}
            @{Ip = '10.2.4.6/8'                    ; Mask = $null             ; Pool = $false ; Subnet = '10.0.0.0'      ; First = '10.0.0.1'      ; Last = '10.255.255.254'  ; Broadcast = '10.255.255.255'  ; AllCount = $null}
            @{Ip = '10.2.4.6/15'                   ; Mask = $null             ; Pool = $false ; Subnet = '10.2.0.0'      ; First = '10.2.0.1'      ; Last = '10.3.255.254'    ; Broadcast = '10.3.255.255'    ; AllCount = $null}
            @{Ip = '10.2.4.6/16'                   ; Mask = $null             ; Pool = $false ; Subnet = '10.2.0.0'      ; First = '10.2.0.1'      ; Last = '10.2.255.254'    ; Broadcast = '10.2.255.255'    ; AllCount = $null}
            @{Ip = '10.2.4.6/17'                   ; Mask = $null             ; Pool = $false ; Subnet = '10.2.0.0'      ; First = '10.2.0.1'      ; Last = '10.2.127.254'    ; Broadcast = '10.2.127.255'    ; AllCount = $null}
            @{Ip = '10.2.4.6/24'                   ; Mask = $null             ; Pool = $false ; Subnet = '10.2.4.0'      ; First = '10.2.4.1'      ; Last = '10.2.4.254'      ; Broadcast = '10.2.4.255'      ; AllCount = 254  }
            @{Ip = '192.168.55.66 255.255.255.224' ; Mask = 27                ; Pool = $false ; Subnet = '192.168.55.64' ; First = '192.168.55.65' ; Last = '192.168.55.94'   ; Broadcast = '192.168.55.95'   ; AllCount =  30  }
            @{Ip = '192.168.55.66/27'              ; Mask = '255.255.255.224' ; Pool = $true  ; Subnet = '192.168.55.64' ; First = '192.168.55.64' ; Last = '192.168.55.95'   ; Broadcast = '192.168.55.95'   ; AllCount =  32  }
            @{Ip = '172.16.17.18/30'               ; Mask = $null             ; Pool = $false ; Subnet = '172.16.17.16'  ; First = '172.16.17.17'  ; Last = '172.16.17.18'    ; Broadcast = '172.16.17.19'    ; AllCount =   2  }
            @{Ip = '172.16.17.18/30'               ; Mask = $null             ; Pool = $true  ; Subnet = '172.16.17.16'  ; First = '172.16.17.16'  ; Last = '172.16.17.19'    ; Broadcast = '172.16.17.19'    ; AllCount =   4  }
            @{Ip = '100.64.9.99/31'                ; Mask = $null             ; Pool = $false ; Subnet = '100.64.9.98'   ; First = '100.64.9.98'   ; Last = '100.64.9.99'     ; Broadcast = '100.64.9.99'     ; AllCount =   2  }
            @{Ip = '100.64.9.99/31'                ; Mask = $null             ; Pool = $true  ; Subnet = '100.64.9.98'   ; First = '100.64.9.98'   ; Last = '100.64.9.99'     ; Broadcast = '100.64.9.99'     ; AllCount =   2  }
            @{Ip = '1.1.1.1'                       ; Mask = 32                ; Pool = $false ; Subnet = '1.1.1.1'       ; First = '1.1.1.1'       ; Last = '1.1.1.1'         ; Broadcast = '1.1.1.1'         ; AllCount =   1  }
        )

        It 'Get-IPv4Address -IpOnly -Subnet -Ip <Ip> -Mask <Mask> -Pool:<Pool> == <Subnet>' -TestCases $testCasesIpOnly1 {
            param ($Ip, $Mask, $Pool, $Subnet)
            $params = @{
                IpOnly = $true
                Subnet = $true
                Ip     = $Ip
                Pool   = $Pool
            }
            if ($Mask -ne $null) { $params['Mask'] = $Mask }
            $r = Get-IPv4Address @params -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Subnet
        }

        It 'Get-IPv4Address -IpOnly -First -Ip <Ip> -Mask <Mask> -Pool:<Pool> == <First>' -TestCases $testCasesIpOnly1 {
            param ($Ip, $Mask, $Pool, $First)
            $params = @{
                IpOnly = $true
                First  = $true
                Ip     = $Ip
                Pool   = $Pool
            }
            if ($Mask -ne $null) { $params['Mask'] = $Mask }
            $r = Get-IPv4Address @params -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $First
        }

        It 'Get-IPv4Address -IpOnly -Last -Ip <Ip> -Mask <Mask> -Pool:<Pool> == <Last>' -TestCases $testCasesIpOnly1 {
            param ($Ip, $Mask, $Pool, $Last)
            $params = @{
                IpOnly = $true
                Last   = $true
                Ip     = $Ip
                Pool   = $Pool
            }
            if ($Mask -ne $null) { $params['Mask'] = $Mask }
            $r = Get-IPv4Address @params -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Last
        }

        It 'Get-IPv4Address -IpOnly -Broadcast -Ip <Ip> -Mask <Mask> -Pool:<Pool> == <Broadcast>' -TestCases $testCasesIpOnly1 {
            param ($Ip, $Mask, $Pool, $Broadcast)
            $params = @{
                IpOnly    = $true
                Broadcast = $true
                Ip        = $Ip
                Pool      = $Pool
            }
            if ($Mask -ne $null) { $params['Mask'] = $Mask }
            $r = Get-IPv4Address @params -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Broadcast
        }

        It '(Get-IPv4Address -IpOnly -All -Ip <Ip> -Mask <Mask> -Pool:<Pool>).Count == <AllCount>' -TestCases $testCasesIpOnly1.Where({$_.AllCount}) {
            param ($Ip, $Mask, $Pool, $AllCount)
            $params = @{
                IpOnly = $true
                All    = $true
                Ip     = $Ip
                Pool   = $Pool
            }
            if ($Mask -ne $null) { $params['Mask'] = $Mask }
            $r = @(Get-IPv4Address @params -ErrorAction Stop)
            $r[0]    | Should -BeOfType 'System.String'
            $r.Count | Should -Be $AllCount
        }
    }

    Context TestCasesMask1 {
        $testCasesMask1 = @(
            @{Ip = '0.0.0.0'                       ; Mask = 0                 ; Pool = $false ; MaskQuadDotOnly = '0.0.0.0'         ; MaskLengthOnly =  '0' ; MaskLengthWithSlashOnly = '/0'  }
            @{Ip = '255.255.255.255/0'             ; Mask = $null             ; Pool = $false ; MaskQuadDotOnly = '0.0.0.0'         ; MaskLengthOnly =  '0' ; MaskLengthWithSlashOnly = '/0'  }
            @{Ip = '0.0.0.0/255.255.255.255'       ; Mask = 32                ; Pool = $false ; MaskQuadDotOnly = '255.255.255.255' ; MaskLengthOnly = '32' ; MaskLengthWithSlashOnly = '/32' }
            @{Ip = '10.2.4.6/8'                    ; Mask = $null             ; Pool = $false ; MaskQuadDotOnly = '255.0.0.0'       ; MaskLengthOnly =  '8' ; MaskLengthWithSlashOnly = '/8'  }
            @{Ip = '10.2.4.6/15'                   ; Mask = $null             ; Pool = $false ; MaskQuadDotOnly = '255.254.0.0'     ; MaskLengthOnly = '15' ; MaskLengthWithSlashOnly = '/15' }
            @{Ip = '10.2.4.6/16'                   ; Mask = $null             ; Pool = $false ; MaskQuadDotOnly = '255.255.0.0'     ; MaskLengthOnly = '16' ; MaskLengthWithSlashOnly = '/16' }
            @{Ip = '10.2.4.6/17'                   ; Mask = $null             ; Pool = $false ; MaskQuadDotOnly = '255.255.128.0'   ; MaskLengthOnly = '17' ; MaskLengthWithSlashOnly = '/17' }
            @{Ip = '10.2.4.6/24'                   ; Mask = $null             ; Pool = $false ; MaskQuadDotOnly = '255.255.255.0'   ; MaskLengthOnly = '24' ; MaskLengthWithSlashOnly = '/24' }
            @{Ip = '192.168.55.66 255.255.255.224' ; Mask = 27                ; Pool = $false ; MaskQuadDotOnly = '255.255.255.224' ; MaskLengthOnly = '27' ; MaskLengthWithSlashOnly = '/27' }
            @{Ip = '192.168.55.66/27'              ; Mask = '255.255.255.224' ; Pool = $true  ; MaskQuadDotOnly = '255.255.255.224' ; MaskLengthOnly = '27' ; MaskLengthWithSlashOnly = '/27' }
            @{Ip = '172.16.17.18/30'               ; Mask = $null             ; Pool = $false ; MaskQuadDotOnly = '255.255.255.252' ; MaskLengthOnly = '30' ; MaskLengthWithSlashOnly = '/30' }
            @{Ip = '172.16.17.18/30'               ; Mask = $null             ; Pool = $true  ; MaskQuadDotOnly = '255.255.255.252' ; MaskLengthOnly = '30' ; MaskLengthWithSlashOnly = '/30' }
            @{Ip = '100.64.9.99/31'                ; Mask = $null             ; Pool = $false ; MaskQuadDotOnly = '255.255.255.254' ; MaskLengthOnly = '31' ; MaskLengthWithSlashOnly = '/31' }
            @{Ip = '100.64.9.99/31'                ; Mask = $null             ; Pool = $true  ; MaskQuadDotOnly = '255.255.255.254' ; MaskLengthOnly = '31' ; MaskLengthWithSlashOnly = '/31' }
            @{Ip = '1.1.1.1'                       ; Mask = 32                ; Pool = $false ; MaskQuadDotOnly = '255.255.255.255' ; MaskLengthOnly = '32' ; MaskLengthWithSlashOnly = '/32' }
        )

        It 'Get-IPv4Address -MaskQuadDotOnly -Ip <Ip> -Mask <Mask> -Pool:<Pool> == <MaskQuadDotOnly>' -TestCases $testCasesMask1 {
            param ($Ip, $Mask, $Pool, $MaskQuadDotOnly)
            $params = @{
                MaskQuadDotOnly = $true
                Ip              = $Ip
                Pool            = $Pool
            }
            if ($Mask -ne $null) { $params['Mask'] = $Mask }
            $r = Get-IPv4Address @params -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $MaskQuadDotOnly
        }

        It 'Get-IPv4Address -MaskLengthOnly -Ip <Ip> -Mask <Mask> -Pool:<Pool> == <MaskLengthOnly>' -TestCases $testCasesMask1 {
            param ($Ip, $Mask, $Pool, $MaskLengthOnly)
            $params = @{
                MaskLengthOnly = $true
                Ip             = $Ip
                Pool           = $Pool
            }
            if ($Mask -ne $null) { $params['Mask'] = $Mask }
            $r = Get-IPv4Address @params -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $MaskLengthOnly
        }

        It 'Get-IPv4Address -MaskLengthWithSlashOnly -Ip <Ip> -Mask <Mask> -Pool:<Pool> == <MaskLengthWithSlashOnly>' -TestCases $testCasesMask1 {
            param ($Ip, $Mask, $Pool, $MaskLengthWithSlashOnly)
            $params = @{
                MaskLengthWithSlashOnly = $true
                Ip                      = $Ip
                Pool                    = $Pool
            }
            if ($Mask -ne $null) { $params['Mask'] = $Mask }
            $r = Get-IPv4Address @params -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $MaskLengthWithSlashOnly
        }
    }

    Context Info {
        It 'Info' {
            $r = Get-IPv4Address -Ip 10.200.30.40/11 -Info -ErrorAction Stop
            $r.IP          | Should -Be 10.200.30.40
            $r.Subnet      | Should -Be 10.192.0.0
            $r.FirstIP     | Should -Be 10.192.0.1
            $r.LastIP      | Should -Be 10.223.255.254
            $r.Broadcast   | Should -Be 10.223.255.255
            $r.MaskQuadDot | Should -Be 255.224.0.0
            $r.MaskLength  | Should -Be 11
        }
    }

    Context Warning {
        It 'Get-IPv4Address -Ip 1.2.3.4/8 -Mask 24 -Subnet  (warning)' {
            {Get-IPv4Address -Ip 1.2.3.4/8 -Mask 24 -Subnet -ErrorAction Stop -WarningAction Stop 3>$null} | Should -Throw '*Mask set to*but*Using*'
        }
    }

    Context TestCasesThrow1 {
        $testCasesThrow1 = @(
            @{Ip = $null       ; Mask = $null ; Switch1 = $null    ; Switch2 = $null ; Throw = '*Parameter set cannot be resolved using the specified named parameters*'}
            @{Ip = -1          ; Mask = $null ; Switch1 = $null    ; Switch2 = $null ; Throw = '*is not a valid IPv4 address*'}
            @{Ip = 22          ; Mask = $null ; Switch1 = $null    ; Switch2 = $null ; Throw = '*is not a valid IPv4 address*'}
            @{Ip = -1          ; Mask = -1    ; Switch1 = $null    ; Switch2 = $null ; Throw = '*is not a valid IPv4*'}
            @{Ip = '127.0.0.1' ; Mask = -1    ; Switch1 = $null    ; Switch2 = $null ; Throw = '*is not a valid IPv4 mask*'}
            @{Ip = '127.0.0.1' ; Mask = $null ; Switch1 = $null    ; Switch2 = $null ; Throw = '*Parameter set cannot be resolved using the specified named parameters*'}
            @{Ip = '127.0.0.1' ; Mask = $null ; Switch1 = 'Abc'    ; Switch2 = $null ; Throw = '*Parameter set cannot be resolved using the specified named parameters*'}
            @{Ip = '127.0.0.1' ; Mask = $null ; Switch1 = 'Subnet' ; Switch2 = $null ; Throw = '*No mask defined*'}
        )

        It 'Convert-IPv4Address -Ip <Ip> -Mask <Mask> -<Switch1> -<Switch2>  (throw)' -TestCases $testCasesThrow1 {
            param ($Ip, $Mask, $Switch1, $Switch2, $Throw)
            $params = @{}
            if ($Ip      -ne $null) {$params['Ip']     = $Ip}
            if ($Mask    -ne $null) {$params['Mask']   = $Mask}
            if ($Switch1 -ne $null) {$params[$Switch1] = $true}
            if ($Switch2 -ne $null) {$params[$Switch2] = $true}
            {Get-IPv4Address @params -ErrorAction Stop} | Should -Throw $Throw
        }
    }
}
