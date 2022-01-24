# Invoke-Pester -Path .\Pester\Convert-IPv6Address.Tests.ps1 -Output Detailed
Describe 'Convert-IPv6Address' {

    It 'Positional argmuent' {
        $r = Convert-IPv6Address 0:0::1 -ErrorAction Stop
        $r | Should -BeOfType 'System.String'
        $r | Should -Be ::1
    }

    Context TestCases1 {
        $testCases1 = @(
            @{IP = '::1'             ; Result = '::1'}
            @{IP = '0::1'            ; Result = '::1'}
            @{IP = '0:0::1'          ; Result = '::1'}
            @{IP = '0:0:0::1'        ; Result = '::1'}
            @{IP = '0:0:0:0::1'      ; Result = '::1'}
            @{IP = '0:0:0:0:0::1'    ; Result = '::1'}
            @{IP = '0:0:0:0:0:0::1'  ; Result = '::1'}
            @{IP = '0:0:0:0:0::0:1'  ; Result = '::1'}
            @{IP = '0:0:0:0::0:0:1'  ; Result = '::1'}
            @{IP = '0:0:0::0:0:0:1'  ; Result = '::1'}
            @{IP = '0:0::0:0:0:0:1'  ; Result = '::1'}
            @{IP = '0::0:0:0:0:0:1'  ; Result = '::1'}
            @{IP = '::0:0:0:0:0:1'   ; Result = '::1'}
            @{IP = 'a::'             ; Result = 'a::'}
            @{IP = '000a:0:0::b'     ; Result = 'a::b'}
            @{IP = 'a::b:0:0:0:c'    ; Result = 'a:0:0:b::c'}
            @{IP = '0::abcd/64'      ; Result = '::abcd/64'}
        )

        It 'Convert-IPv6Address -IP <IP> == <IP>' -TestCases $testCases1 {
            param ($IP, $Result)
            $r = Convert-IPv6Address -IP $IP -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Result
        }
    }
    
    Context IntArray {
        It 'Int array 1' {
            $r = Convert-IPv6Address -IP @(1,2,3,4,5,6,7,[uint16]::MaxValue)
            $r | Should -BeOfType 'System.String'
            $r | Should -Be '1:2:3:4:5:6:7:ffff'
        }

        It 'Int array 2' {
            $r = Convert-IPv6Address -IP (Convert-IPv6Address -IP abcd::0123/20 -Info -ErrorAction Stop).IPIntArray -Prefix 30 -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be 'abcd::123/30'
        }
    }

    Context Warning {
        It 'Convert-IPv6Address -IP a::b/20 -Prefix 30  (warning)' {
            {Convert-IPv6Address -IP a::b/20 -Prefix 30 -ErrorAction Stop -WarningAction Stop 3>$null} | Should -Throw '*Prefix set to*but*Using*'
        }
    }

    Context TestCasesThrow1 {
        $testCasesThrow1 = @(
            @{IP = 'a'                         ; Throw = '*Error parsing IPv6 address*'}
            @{IP = 'a:'                        ; Throw = '*Error parsing IPv6 address*'}
            @{IP = ':b'                        ; Throw = '*Error parsing IPv6 address*'}
            @{IP = '253.254.255.256'           ; Throw = '*Error parsing IPv6 address*'}
            @{IP = 'abc'                       ; Throw = '*Error parsing IPv6 address*'}
            @{IP = '1111111111111111111111111' ; Throw = '*Error parsing IPv6 address*'}
            @{IP = 'abc:de:x::'                ; Throw = '*Error parsing IPv6 address*'}
            @{IP = '1:2:3:4:5:6:7:8:'          ; Throw = '*Error parsing IPv6 address*'}
            @{IP = ':1:2:3:4:5:6:7:8'          ; Throw = '*Error parsing IPv6 address*'}
            @{IP = ':1:2:3:4:5:6:7:8:'         ; Throw = '*Error parsing IPv6 address*'}
            @{IP = 'aaaaa::'                   ; Throw = '*Error parsing IPv6 address*'}
            @{IP = 'a:b::c/129'                ; Throw = '*Error parsing IPv6 address*'}
            @{IP = -1                          ; Throw = '*Input IP is in unknown format*'}
            @{IP = @{A=1}                      ; Throw = '*Input IP is in unknown format*'}
            @{IP = @(1,2,3,4,5,6,7)            ; Throw = '*Input IP is in unknown format*'}
            @{IP = @(1,2,3,4,5,6,7,8,9)        ; Throw = '*Input IP is in unknown format*'}
            @{IP = @(1,2,3,4,5,6,7,'a')        ; Throw = '*Input IP is in unknown format*'}
        )

        It 'Convert-IPv6Address -IP <IP>  (throw)' -TestCases $testCasesThrow1 {
            param ($IP, $Throw)
            {Convert-IPv6Address -IP $IP -ErrorAction Stop} | Should -Throw $Throw
        }
    }
}
