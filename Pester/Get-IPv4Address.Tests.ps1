# Invoke-Pester -Path .\Pester\Get-IPv4Address.Tests.ps1 -Output Detailed
Describe 'Get-IPv4Address' {

    Context PositionalArgmuent {
        It 'Positional argmuent1' {
            $r = Get-IPv4Address 10.9.8.7/255.255.255.0 -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be 10.9.8.7/24
        }

        It 'Positional argmuent2' {
            $r = Get-IPv4Address 10.9.8.7/255.255.255.0 -Subnet -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be 10.9.8.0/24
        }
    }

    Context TestCasesWithMaskLength1 {
        $testCasesWithMaskLength1 = @(
            @{IP = '0.0.0.0'                       ; Mask = 0                 ; Pool = $false ; Subnet = '0.0.0.0/0'        ; First = '0.0.0.1/0'        ; Last = '255.255.255.254/0' ; Broadcast = '255.255.255.255/0' ; AllCount = $null}
            @{IP = '255.255.255.255/0'             ; Mask = $null             ; Pool = $false ; Subnet = '0.0.0.0/0'        ; First = '0.0.0.1/0'        ; Last = '255.255.255.254/0' ; Broadcast = '255.255.255.255/0' ; AllCount = $null}
            @{IP = '0.0.0.0/255.255.255.255'       ; Mask = 32                ; Pool = $false ; Subnet = '0.0.0.0/32'       ; First = '0.0.0.0/32'       ; Last = '0.0.0.0/32'        ; Broadcast = '0.0.0.0/32'        ; AllCount = $null}
            @{IP = '10.2.4.6/8'                    ; Mask = $null             ; Pool = $false ; Subnet = '10.0.0.0/8'       ; First = '10.0.0.1/8'       ; Last = '10.255.255.254/8'  ; Broadcast = '10.255.255.255/8'  ; AllCount = $null}
            @{IP = '10.2.4.6/15'                   ; Mask = $null             ; Pool = $false ; Subnet = '10.2.0.0/15'      ; First = '10.2.0.1/15'      ; Last = '10.3.255.254/15'   ; Broadcast = '10.3.255.255/15'   ; AllCount = $null}
            @{IP = '10.2.4.6/16'                   ; Mask = $null             ; Pool = $false ; Subnet = '10.2.0.0/16'      ; First = '10.2.0.1/16'      ; Last = '10.2.255.254/16'   ; Broadcast = '10.2.255.255/16'   ; AllCount = $null}
            @{IP = '10.2.4.6/17'                   ; Mask = $null             ; Pool = $false ; Subnet = '10.2.0.0/17'      ; First = '10.2.0.1/17'      ; Last = '10.2.127.254/17'   ; Broadcast = '10.2.127.255/17'   ; AllCount = $null}
            @{IP = '10.2.4.6/24'                   ; Mask = $null             ; Pool = $false ; Subnet = '10.2.4.0/24'      ; First = '10.2.4.1/24'      ; Last = '10.2.4.254/24'     ; Broadcast = '10.2.4.255/24'     ; AllCount = 254  }
            @{IP = '192.168.55.66 255.255.255.224' ; Mask = 27                ; Pool = $false ; Subnet = '192.168.55.64/27' ; First = '192.168.55.65/27' ; Last = '192.168.55.94/27'  ; Broadcast = '192.168.55.95/27'  ; AllCount =  30  }
            @{IP = '192.168.55.66/27'              ; Mask = '255.255.255.224' ; Pool = $true  ; Subnet = '192.168.55.64/27' ; First = '192.168.55.64/27' ; Last = '192.168.55.95/27'  ; Broadcast = '192.168.55.95/27'  ; AllCount =  32  }
            @{IP = '172.16.17.18/30'               ; Mask = $null             ; Pool = $false ; Subnet = '172.16.17.16/30'  ; First = '172.16.17.17/30'  ; Last = '172.16.17.18/30'   ; Broadcast = '172.16.17.19/30'   ; AllCount =   2  }
            @{IP = '172.16.17.18/30'               ; Mask = $null             ; Pool = $true  ; Subnet = '172.16.17.16/30'  ; First = '172.16.17.16/30'  ; Last = '172.16.17.19/30'   ; Broadcast = '172.16.17.19/30'   ; AllCount =   4  }
            @{IP = '100.64.9.99/31'                ; Mask = $null             ; Pool = $false ; Subnet = '100.64.9.98/31'   ; First = '100.64.9.98/31'   ; Last = '100.64.9.99/31'    ; Broadcast = '100.64.9.99/31'    ; AllCount =   2  }
            @{IP = '100.64.9.99/31'                ; Mask = $null             ; Pool = $true  ; Subnet = '100.64.9.98/31'   ; First = '100.64.9.98/31'   ; Last = '100.64.9.99/31'    ; Broadcast = '100.64.9.99/31'    ; AllCount =   2  }
            @{IP = '1.1.1.1'                       ; Mask = 32                ; Pool = $false ; Subnet = '1.1.1.1/32'       ; First = '1.1.1.1/32'       ; Last = '1.1.1.1/32'        ; Broadcast = '1.1.1.1/32'        ; AllCount =   1  }
        )

        It 'Get-IPv4Address -WithMaskLength -Subnet -IP <IP> -Mask <Mask> -Pool:<Pool> == <Subnet>' -TestCases $testCasesWithMaskLength1 {
            param ($IP, $Mask, $Pool, $Subnet)
            $params = @{
                WithMaskLength = $true
                Subnet         = $true
                IP             = $IP
                Pool           = $Pool
            }
            if ($Mask -ne $null) { $params['Mask'] = $Mask }
            $r = Get-IPv4Address @params -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Subnet
        }

        It 'Get-IPv4Address -WithMaskLength -First -IP <IP> -Mask <Mask> -Pool:<Pool> == <First>' -TestCases $testCasesWithMaskLength1 {
            param ($IP, $Mask, $Pool, $First)
            $params = @{
                WithMaskLength = $true
                First          = $true
                IP             = $IP
                Pool           = $Pool
            }
            if ($Mask -ne $null) { $params['Mask'] = $Mask }
            $r = Get-IPv4Address @params -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $First
        }

        It 'Get-IPv4Address -WithMaskLength -Last -IP <IP> -Mask <Mask> -Pool:<Pool> == <Last>' -TestCases $testCasesWithMaskLength1 {
            param ($IP, $Mask, $Pool, $Last)
            $params = @{
                WithMaskLength = $true
                Last           = $true
                IP             = $IP
                Pool           = $Pool
            }
            if ($Mask -ne $null) { $params['Mask'] = $Mask }
            $r = Get-IPv4Address @params -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Last
        }

        It 'Get-IPv4Address -WithMaskLength -Broadcast -IP <IP> -Mask <Mask> -Pool:<Pool> == <Broadcast>' -TestCases $testCasesWithMaskLength1 {
            param ($IP, $Mask, $Pool, $Broadcast)
            $params = @{
                WithMaskLength = $true
                Broadcast      = $true
                IP             = $IP
                Pool           = $Pool
            }
            if ($Mask -ne $null) { $params['Mask'] = $Mask }
            $r = Get-IPv4Address @params -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Broadcast
        }

        It '(Get-IPv4Address -WithMaskLength -All -IP <IP> -Mask <Mask> -Pool:<Pool>).Count == <AllCount>' -TestCases $testCasesWithMaskLength1.Where({$_.AllCount}) {
            param ($IP, $Mask, $Pool, $AllCount)
            $params = @{
                WithMaskLength = $true
                All            = $true
                IP             = $IP
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
            @{IP = '0.0.0.0'                       ; Mask = 0                 ; Pool = $false ; Subnet = '0.0.0.0 0.0.0.0'               ; First = '0.0.0.1 0.0.0.0'               ; Last = '255.255.255.254 0.0.0.0'       ; Broadcast = '255.255.255.255 0.0.0.0'       ; AllCount = $null}
            @{IP = '255.255.255.255/0'             ; Mask = $null             ; Pool = $false ; Subnet = '0.0.0.0 0.0.0.0'               ; First = '0.0.0.1 0.0.0.0'               ; Last = '255.255.255.254 0.0.0.0'       ; Broadcast = '255.255.255.255 0.0.0.0'       ; AllCount = $null}
            @{IP = '0.0.0.0/255.255.255.255'       ; Mask = 32                ; Pool = $false ; Subnet = '0.0.0.0 255.255.255.255'       ; First = '0.0.0.0 255.255.255.255'       ; Last = '0.0.0.0 255.255.255.255'       ; Broadcast = '0.0.0.0 255.255.255.255'       ; AllCount = $null}
            @{IP = '10.2.4.6/8'                    ; Mask = $null             ; Pool = $false ; Subnet = '10.0.0.0 255.0.0.0'            ; First = '10.0.0.1 255.0.0.0'            ; Last = '10.255.255.254 255.0.0.0'      ; Broadcast = '10.255.255.255 255.0.0.0'      ; AllCount = $null}
            @{IP = '10.2.4.6/15'                   ; Mask = $null             ; Pool = $false ; Subnet = '10.2.0.0 255.254.0.0'          ; First = '10.2.0.1 255.254.0.0'          ; Last = '10.3.255.254 255.254.0.0'      ; Broadcast = '10.3.255.255 255.254.0.0'      ; AllCount = $null}
            @{IP = '10.2.4.6/16'                   ; Mask = $null             ; Pool = $false ; Subnet = '10.2.0.0 255.255.0.0'          ; First = '10.2.0.1 255.255.0.0'          ; Last = '10.2.255.254 255.255.0.0'      ; Broadcast = '10.2.255.255 255.255.0.0'      ; AllCount = $null}
            @{IP = '10.2.4.6/17'                   ; Mask = $null             ; Pool = $false ; Subnet = '10.2.0.0 255.255.128.0'        ; First = '10.2.0.1 255.255.128.0'        ; Last = '10.2.127.254 255.255.128.0'    ; Broadcast = '10.2.127.255 255.255.128.0'    ; AllCount = $null}
            @{IP = '10.2.4.6/24'                   ; Mask = $null             ; Pool = $false ; Subnet = '10.2.4.0 255.255.255.0'        ; First = '10.2.4.1 255.255.255.0'        ; Last = '10.2.4.254 255.255.255.0'      ; Broadcast = '10.2.4.255 255.255.255.0'      ; AllCount = 254  }
            @{IP = '192.168.55.66 255.255.255.224' ; Mask = 27                ; Pool = $false ; Subnet = '192.168.55.64 255.255.255.224' ; First = '192.168.55.65 255.255.255.224' ; Last = '192.168.55.94 255.255.255.224' ; Broadcast = '192.168.55.95 255.255.255.224' ; AllCount =  30  }
            @{IP = '192.168.55.66/27'              ; Mask = '255.255.255.224' ; Pool = $true  ; Subnet = '192.168.55.64 255.255.255.224' ; First = '192.168.55.64 255.255.255.224' ; Last = '192.168.55.95 255.255.255.224' ; Broadcast = '192.168.55.95 255.255.255.224' ; AllCount =  32  }
            @{IP = '172.16.17.18/30'               ; Mask = $null             ; Pool = $false ; Subnet = '172.16.17.16 255.255.255.252'  ; First = '172.16.17.17 255.255.255.252'  ; Last = '172.16.17.18 255.255.255.252'  ; Broadcast = '172.16.17.19 255.255.255.252'  ; AllCount =   2  }
            @{IP = '172.16.17.18/30'               ; Mask = $null             ; Pool = $true  ; Subnet = '172.16.17.16 255.255.255.252'  ; First = '172.16.17.16 255.255.255.252'  ; Last = '172.16.17.19 255.255.255.252'  ; Broadcast = '172.16.17.19 255.255.255.252'  ; AllCount =   4  }
            @{IP = '100.64.9.99/31'                ; Mask = $null             ; Pool = $false ; Subnet = '100.64.9.98 255.255.255.254'   ; First = '100.64.9.98 255.255.255.254'   ; Last = '100.64.9.99 255.255.255.254'   ; Broadcast = '100.64.9.99 255.255.255.254'   ; AllCount =   2  }
            @{IP = '100.64.9.99/31'                ; Mask = $null             ; Pool = $true  ; Subnet = '100.64.9.98 255.255.255.254'   ; First = '100.64.9.98 255.255.255.254'   ; Last = '100.64.9.99 255.255.255.254'   ; Broadcast = '100.64.9.99 255.255.255.254'   ; AllCount =   2  }
            @{IP = '1.1.1.1'                       ; Mask = 32                ; Pool = $false ; Subnet = '1.1.1.1 255.255.255.255'       ; First = '1.1.1.1 255.255.255.255'       ; Last = '1.1.1.1 255.255.255.255'       ; Broadcast = '1.1.1.1 255.255.255.255'       ; AllCount =   1  }
        )

        It 'Get-IPv4Address -WithMask -Subnet -IP <IP> -Mask <Mask> -Pool:<Pool> == <Subnet>' -TestCases $testCasesWithMask1 {
            param ($IP, $Mask, $Pool, $Subnet)
            $params = @{
                WithMask = $true
                Subnet   = $true
                IP       = $IP
                Pool     = $Pool
            }
            if ($Mask -ne $null) { $params['Mask'] = $Mask }
            $r = Get-IPv4Address @params -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Subnet
        }

        It 'Get-IPv4Address -WithMask -First -IP <IP> -Mask <Mask> -Pool:<Pool> == <First>' -TestCases $testCasesWithMask1 {
            param ($IP, $Mask, $Pool, $First)
            $params = @{
                WithMask = $true
                First    = $true
                IP       = $IP
                Pool     = $Pool
            }
            if ($Mask -ne $null) { $params['Mask'] = $Mask }
            $r = Get-IPv4Address @params -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $First
        }

        It 'Get-IPv4Address -WithMask -Last -IP <IP> -Mask <Mask> -Pool:<Pool> == <Last>' -TestCases $testCasesWithMask1 {
            param ($IP, $Mask, $Pool, $Last)
            $params = @{
                WithMask = $true
                Last     = $true
                IP       = $IP
                Pool     = $Pool
            }
            if ($Mask -ne $null) { $params['Mask'] = $Mask }
            $r = Get-IPv4Address @params -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Last
        }

        It 'Get-IPv4Address -WithMask -Broadcast -IP <IP> -Mask <Mask> -Pool:<Pool> == <Broadcast>' -TestCases $testCasesWithMask1 {
            param ($IP, $Mask, $Pool, $Broadcast)
            $params = @{
                WithMask  = $true
                Broadcast = $true
                IP        = $IP
                Pool      = $Pool
            }
            if ($Mask -ne $null) { $params['Mask'] = $Mask }
            $r = Get-IPv4Address @params -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Broadcast
        }

        It '(Get-IPv4Address -WithMask -All -IP <IP> -Mask <Mask> -Pool:<Pool>).Count == <AllCount>' -TestCases $testCasesWithMask1.Where({$_.AllCount}) {
            param ($IP, $Mask, $Pool, $AllCount)
            $params = @{
                WithMask = $true
                All      = $true
                IP       = $IP
                Pool     = $Pool
            }
            if ($Mask -ne $null) { $params['Mask'] = $Mask }
            $r = @(Get-IPv4Address @params -ErrorAction Stop)
            $r[0]    | Should -BeOfType 'System.String'
            $r.Count | Should -Be $AllCount
        }
    }

    Context TestCasesIPOnly1 {
        $testCasesIPOnly1 = @(
            @{IP = '0.0.0.0'                       ; Mask = 0                 ; Pool = $false ; Subnet = '0.0.0.0'       ; First = '0.0.0.1'       ; Last = '255.255.255.254' ; Broadcast = '255.255.255.255' ; AllCount = $null}
            @{IP = '255.255.255.255/0'             ; Mask = $null             ; Pool = $false ; Subnet = '0.0.0.0'       ; First = '0.0.0.1'       ; Last = '255.255.255.254' ; Broadcast = '255.255.255.255' ; AllCount = $null}
            @{IP = '0.0.0.0/255.255.255.255'       ; Mask = 32                ; Pool = $false ; Subnet = '0.0.0.0'       ; First = '0.0.0.0'       ; Last = '0.0.0.0'         ; Broadcast = '0.0.0.0'         ; AllCount = $null}
            @{IP = '10.2.4.6/8'                    ; Mask = $null             ; Pool = $false ; Subnet = '10.0.0.0'      ; First = '10.0.0.1'      ; Last = '10.255.255.254'  ; Broadcast = '10.255.255.255'  ; AllCount = $null}
            @{IP = '10.2.4.6/15'                   ; Mask = $null             ; Pool = $false ; Subnet = '10.2.0.0'      ; First = '10.2.0.1'      ; Last = '10.3.255.254'    ; Broadcast = '10.3.255.255'    ; AllCount = $null}
            @{IP = '10.2.4.6/16'                   ; Mask = $null             ; Pool = $false ; Subnet = '10.2.0.0'      ; First = '10.2.0.1'      ; Last = '10.2.255.254'    ; Broadcast = '10.2.255.255'    ; AllCount = $null}
            @{IP = '10.2.4.6/17'                   ; Mask = $null             ; Pool = $false ; Subnet = '10.2.0.0'      ; First = '10.2.0.1'      ; Last = '10.2.127.254'    ; Broadcast = '10.2.127.255'    ; AllCount = $null}
            @{IP = '10.2.4.6/24'                   ; Mask = $null             ; Pool = $false ; Subnet = '10.2.4.0'      ; First = '10.2.4.1'      ; Last = '10.2.4.254'      ; Broadcast = '10.2.4.255'      ; AllCount = 254  }
            @{IP = '192.168.55.66 255.255.255.224' ; Mask = 27                ; Pool = $false ; Subnet = '192.168.55.64' ; First = '192.168.55.65' ; Last = '192.168.55.94'   ; Broadcast = '192.168.55.95'   ; AllCount =  30  }
            @{IP = '192.168.55.66/27'              ; Mask = '255.255.255.224' ; Pool = $true  ; Subnet = '192.168.55.64' ; First = '192.168.55.64' ; Last = '192.168.55.95'   ; Broadcast = '192.168.55.95'   ; AllCount =  32  }
            @{IP = '172.16.17.18/30'               ; Mask = $null             ; Pool = $false ; Subnet = '172.16.17.16'  ; First = '172.16.17.17'  ; Last = '172.16.17.18'    ; Broadcast = '172.16.17.19'    ; AllCount =   2  }
            @{IP = '172.16.17.18/30'               ; Mask = $null             ; Pool = $true  ; Subnet = '172.16.17.16'  ; First = '172.16.17.16'  ; Last = '172.16.17.19'    ; Broadcast = '172.16.17.19'    ; AllCount =   4  }
            @{IP = '100.64.9.99/31'                ; Mask = $null             ; Pool = $false ; Subnet = '100.64.9.98'   ; First = '100.64.9.98'   ; Last = '100.64.9.99'     ; Broadcast = '100.64.9.99'     ; AllCount =   2  }
            @{IP = '100.64.9.99/31'                ; Mask = $null             ; Pool = $true  ; Subnet = '100.64.9.98'   ; First = '100.64.9.98'   ; Last = '100.64.9.99'     ; Broadcast = '100.64.9.99'     ; AllCount =   2  }
            @{IP = '1.1.1.1'                       ; Mask = 32                ; Pool = $false ; Subnet = '1.1.1.1'       ; First = '1.1.1.1'       ; Last = '1.1.1.1'         ; Broadcast = '1.1.1.1'         ; AllCount =   1  }
        )

        It 'Get-IPv4Address -IPOnly -Subnet -IP <IP> -Mask <Mask> -Pool:<Pool> == <Subnet>' -TestCases $testCasesIPOnly1 {
            param ($IP, $Mask, $Pool, $Subnet)
            $params = @{
                IPOnly = $true
                Subnet = $true
                IP     = $IP
                Pool   = $Pool
            }
            if ($Mask -ne $null) { $params['Mask'] = $Mask }
            $r = Get-IPv4Address @params -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Subnet
        }

        It 'Get-IPv4Address -IPOnly -First -IP <IP> -Mask <Mask> -Pool:<Pool> == <First>' -TestCases $testCasesIPOnly1 {
            param ($IP, $Mask, $Pool, $First)
            $params = @{
                IPOnly = $true
                First  = $true
                IP     = $IP
                Pool   = $Pool
            }
            if ($Mask -ne $null) { $params['Mask'] = $Mask }
            $r = Get-IPv4Address @params -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $First
        }

        It 'Get-IPv4Address -IPOnly -Last -IP <IP> -Mask <Mask> -Pool:<Pool> == <Last>' -TestCases $testCasesIPOnly1 {
            param ($IP, $Mask, $Pool, $Last)
            $params = @{
                IPOnly = $true
                Last   = $true
                IP     = $IP
                Pool   = $Pool
            }
            if ($Mask -ne $null) { $params['Mask'] = $Mask }
            $r = Get-IPv4Address @params -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Last
        }

        It 'Get-IPv4Address -IPOnly -Broadcast -IP <IP> -Mask <Mask> -Pool:<Pool> == <Broadcast>' -TestCases $testCasesIPOnly1 {
            param ($IP, $Mask, $Pool, $Broadcast)
            $params = @{
                IPOnly    = $true
                Broadcast = $true
                IP        = $IP
                Pool      = $Pool
            }
            if ($Mask -ne $null) { $params['Mask'] = $Mask }
            $r = Get-IPv4Address @params -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Broadcast
        }

        It '(Get-IPv4Address -IPOnly -All -IP <IP> -Mask <Mask> -Pool:<Pool>).Count == <AllCount>' -TestCases $testCasesIPOnly1.Where({$_.AllCount}) {
            param ($IP, $Mask, $Pool, $AllCount)
            $params = @{
                IPOnly = $true
                All    = $true
                IP     = $IP
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
            @{IP = '0.0.0.0'                       ; Mask = 0                 ; Pool = $false ; MaskQuadDotOnly = '0.0.0.0'         ; MaskLengthOnly =  '0' ; MaskLengthWithSlashOnly = '/0'  }
            @{IP = '255.255.255.255/0'             ; Mask = $null             ; Pool = $false ; MaskQuadDotOnly = '0.0.0.0'         ; MaskLengthOnly =  '0' ; MaskLengthWithSlashOnly = '/0'  }
            @{IP = '0.0.0.0/255.255.255.255'       ; Mask = 32                ; Pool = $false ; MaskQuadDotOnly = '255.255.255.255' ; MaskLengthOnly = '32' ; MaskLengthWithSlashOnly = '/32' }
            @{IP = '10.2.4.6/8'                    ; Mask = $null             ; Pool = $false ; MaskQuadDotOnly = '255.0.0.0'       ; MaskLengthOnly =  '8' ; MaskLengthWithSlashOnly = '/8'  }
            @{IP = '10.2.4.6/15'                   ; Mask = $null             ; Pool = $false ; MaskQuadDotOnly = '255.254.0.0'     ; MaskLengthOnly = '15' ; MaskLengthWithSlashOnly = '/15' }
            @{IP = '10.2.4.6/16'                   ; Mask = $null             ; Pool = $false ; MaskQuadDotOnly = '255.255.0.0'     ; MaskLengthOnly = '16' ; MaskLengthWithSlashOnly = '/16' }
            @{IP = '10.2.4.6/17'                   ; Mask = $null             ; Pool = $false ; MaskQuadDotOnly = '255.255.128.0'   ; MaskLengthOnly = '17' ; MaskLengthWithSlashOnly = '/17' }
            @{IP = '10.2.4.6/24'                   ; Mask = $null             ; Pool = $false ; MaskQuadDotOnly = '255.255.255.0'   ; MaskLengthOnly = '24' ; MaskLengthWithSlashOnly = '/24' }
            @{IP = '192.168.55.66 255.255.255.224' ; Mask = 27                ; Pool = $false ; MaskQuadDotOnly = '255.255.255.224' ; MaskLengthOnly = '27' ; MaskLengthWithSlashOnly = '/27' }
            @{IP = '192.168.55.66/27'              ; Mask = '255.255.255.224' ; Pool = $true  ; MaskQuadDotOnly = '255.255.255.224' ; MaskLengthOnly = '27' ; MaskLengthWithSlashOnly = '/27' }
            @{IP = '172.16.17.18/30'               ; Mask = $null             ; Pool = $false ; MaskQuadDotOnly = '255.255.255.252' ; MaskLengthOnly = '30' ; MaskLengthWithSlashOnly = '/30' }
            @{IP = '172.16.17.18/30'               ; Mask = $null             ; Pool = $true  ; MaskQuadDotOnly = '255.255.255.252' ; MaskLengthOnly = '30' ; MaskLengthWithSlashOnly = '/30' }
            @{IP = '100.64.9.99/31'                ; Mask = $null             ; Pool = $false ; MaskQuadDotOnly = '255.255.255.254' ; MaskLengthOnly = '31' ; MaskLengthWithSlashOnly = '/31' }
            @{IP = '100.64.9.99/31'                ; Mask = $null             ; Pool = $true  ; MaskQuadDotOnly = '255.255.255.254' ; MaskLengthOnly = '31' ; MaskLengthWithSlashOnly = '/31' }
            @{IP = '1.1.1.1'                       ; Mask = 32                ; Pool = $false ; MaskQuadDotOnly = '255.255.255.255' ; MaskLengthOnly = '32' ; MaskLengthWithSlashOnly = '/32' }
        )

        It 'Get-IPv4Address -MaskQuadDotOnly -IP <IP> -Mask <Mask> -Pool:<Pool> == <MaskQuadDotOnly>' -TestCases $testCasesMask1 {
            param ($IP, $Mask, $Pool, $MaskQuadDotOnly)
            $params = @{
                MaskQuadDotOnly = $true
                IP              = $IP
                Pool            = $Pool
            }
            if ($Mask -ne $null) { $params['Mask'] = $Mask }
            $r = Get-IPv4Address @params -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $MaskQuadDotOnly
        }

        It 'Get-IPv4Address -MaskLengthOnly -IP <IP> -Mask <Mask> -Pool:<Pool> == <MaskLengthOnly>' -TestCases $testCasesMask1 {
            param ($IP, $Mask, $Pool, $MaskLengthOnly)
            $params = @{
                MaskLengthOnly = $true
                IP             = $IP
                Pool           = $Pool
            }
            if ($Mask -ne $null) { $params['Mask'] = $Mask }
            $r = Get-IPv4Address @params -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $MaskLengthOnly
        }

        It 'Get-IPv4Address -MaskLengthWithSlashOnly -IP <IP> -Mask <Mask> -Pool:<Pool> == <MaskLengthWithSlashOnly>' -TestCases $testCasesMask1 {
            param ($IP, $Mask, $Pool, $MaskLengthWithSlashOnly)
            $params = @{
                MaskLengthWithSlashOnly = $true
                IP                      = $IP
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
            $r = Get-IPv4Address -IP 10.200.30.40/11 -Info -ErrorAction Stop
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
        It 'Get-IPv4Address -IP 1.2.3.4/8 -Mask 24 -Subnet  (warning)' {
            {Get-IPv4Address -IP 1.2.3.4/8 -Mask 24 -Subnet -ErrorAction Stop -WarningAction Stop 3>$null} | Should -Throw '*Mask set to*but*Using*'
        }
    }

    Context TestCasesThrow1 {
        $testCasesThrow1 = @(
            @{IP = -1          ; Mask = $null ; Switch1 = $null    ; Switch2 = $null ; Throw = '*is not a valid IPv4 address*'}
            @{IP = 22          ; Mask = $null ; Switch1 = $null    ; Switch2 = $null ; Throw = '*is not a valid IPv4 address*'}
            @{IP = -1          ; Mask = -1    ; Switch1 = $null    ; Switch2 = $null ; Throw = '*is not a valid IPv4*'}
            @{IP = '127.0.0.1' ; Mask = -1    ; Switch1 = $null    ; Switch2 = $null ; Throw = '*is not a valid IPv4 mask*'}
            @{IP = '127.0.0.1' ; Mask = $null ; Switch1 = $null    ; Switch2 = $null ; Throw = '*No mask defined*'}
            @{IP = '127.0.0.1' ; Mask = $null ; Switch1 = 'Abc'    ; Switch2 = $null ; Throw = '*A parameter cannot be found that matches parameter name*'}
            @{IP = '127.0.0.1' ; Mask = $null ; Switch1 = 'Subnet' ; Switch2 = $null ; Throw = '*No mask defined*'}
        )

        It 'Get-IPv4Address -IP <IP> -Mask <Mask> -<Switch1> -<Switch2>  (throw)' -TestCases $testCasesThrow1 {
            param ($IP, $Mask, $Switch1, $Switch2, $Throw)
            $params = @{}
            if ($IP      -ne $null) {$params['IP']     = $IP}
            if ($Mask    -ne $null) {$params['Mask']   = $Mask}
            if ($Switch1 -ne $null) {$params[$Switch1] = $true}
            if ($Switch2 -ne $null) {$params[$Switch2] = $true}
            {Get-IPv4Address @params -ErrorAction Stop} | Should -Throw $Throw
        }
    }
}
