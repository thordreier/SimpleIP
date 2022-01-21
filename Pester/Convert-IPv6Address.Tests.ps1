# Invoke-Pester -Path .\Pester\Convert-IPv6Address.Tests.ps1 -Output Detailed
Describe 'Convert-IPv6Address' {

    It 'Positional argmuent' {
        $r = Convert-IPv6Address 0:0::1 -ErrorAction Stop
        $r | Should -BeOfType 'System.String'
        $r | Should -Be ::1
    }

    Context TestCases1 {
        $testCases1 = @(
            @{Ip = '::1'             ; Result = '::1'}
            @{Ip = '0::1'            ; Result = '::1'}
            @{Ip = '0:0::1'          ; Result = '::1'}
            @{Ip = '0:0:0::1'        ; Result = '::1'}
            @{Ip = '0:0:0:0::1'      ; Result = '::1'}
            @{Ip = '0:0:0:0:0::1'    ; Result = '::1'}
            @{Ip = '0:0:0:0:0:0::1'  ; Result = '::1'}
            @{Ip = '0:0:0:0:0::0:1'  ; Result = '::1'}
            @{Ip = '0:0:0:0::0:0:1'  ; Result = '::1'}
            @{Ip = '0:0:0::0:0:0:1'  ; Result = '::1'}
            @{Ip = '0:0::0:0:0:0:1'  ; Result = '::1'}
            @{Ip = '0::0:0:0:0:0:1'  ; Result = '::1'}
            @{Ip = '::0:0:0:0:0:1'   ; Result = '::1'}
            @{Ip = 'a::'             ; Result = 'a::'}
            @{Ip = '000a:0:0::b'     ; Result = 'a::b'}
            @{Ip = 'a::b:0:0:0:c'    ; Result = 'a:0:0:b::c'}
            @{Ip = '0::abcd/64'      ; Result = '::abcd/64'}
        )

        It 'Convert-IPv6Address -Ip <Ip> == <Ip>' -TestCases $testCases1 {
            param ($Ip, $Result)
            $r = Convert-IPv6Address -Ip $Ip -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Result
        }
    }
    
    Context IntArray {
        It 'Int array 1' {
            $r = Convert-IPv6Address -Ip @(1,2,3,4,5,6,7,[uint16]::MaxValue)
            $r | Should -BeOfType 'System.String'
            $r | Should -Be '1:2:3:4:5:6:7:ffff'
        }

        It 'Int array 2' {
            $r = Convert-IPv6Address -Ip (Convert-IPv6Address -Ip abcd::0123/20 -Info -ErrorAction Stop).IPIntArray -Prefix 30 -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be 'abcd::123/30'
        }
    }

    Context Warning {
        It 'Convert-IPv6Address -Ip a::b/20 -Prefix 30  (warning)' {
            {Convert-IPv6Address -Ip a::b/20 -Prefix 30 -ErrorAction Stop -WarningAction Stop 3>$null} | Should -Throw '*Prefix set to*but*Using*'
        }
    }

    Context TestCasesThrow1 {
        $testCasesThrow1 = @(
            @{Ip = 'a'                         ; Throw = '*Error parsing IPv6 address*'}
            @{Ip = 'a:'                        ; Throw = '*Error parsing IPv6 address*'}
            @{Ip = ':b'                        ; Throw = '*Error parsing IPv6 address*'}
            @{Ip = '253.254.255.256'           ; Throw = '*Error parsing IPv6 address*'}
            @{Ip = 'abc'                       ; Throw = '*Error parsing IPv6 address*'}
            @{Ip = '1111111111111111111111111' ; Throw = '*Error parsing IPv6 address*'}
            @{Ip = 'abc:de:x::'                ; Throw = '*Error parsing IPv6 address*'}
            @{Ip = '1:2:3:4:5:6:7:8:'          ; Throw = '*Error parsing IPv6 address*'}
            @{Ip = ':1:2:3:4:5:6:7:8'          ; Throw = '*Error parsing IPv6 address*'}
            @{Ip = ':1:2:3:4:5:6:7:8:'         ; Throw = '*Error parsing IPv6 address*'}
            @{Ip = 'aaaaa::'                   ; Throw = '*Error parsing IPv6 address*'}
            @{Ip = 'a:b::c/129'                ; Throw = '*Error parsing IPv6 address*'}
            @{Ip = -1                          ; Throw = '*Input IP is in unknown format*'}
            @{Ip = @{A=1}                      ; Throw = '*Input IP is in unknown format*'}
            @{Ip = @(1,2,3,4,5,6,7)            ; Throw = '*Input IP is in unknown format*'}
            @{Ip = @(1,2,3,4,5,6,7,8,9)        ; Throw = '*Input IP is in unknown format*'}
            @{Ip = @(1,2,3,4,5,6,7,'a')        ; Throw = '*Input IP is in unknown format*'}
        )

        It 'Convert-IPv6Address -Ip <Ip>  (throw)' -TestCases $testCasesThrow1 {
            param ($Ip, $Throw)
            {Convert-IPv6Address -Ip $Ip -ErrorAction Stop} | Should -Throw $Throw
        }
    }
}
