# Invoke-Pester -Path .\Pester\Test-IPv4Address.Tests.ps1 -Output Detailed
Describe 'Test-IPv4Address' {

    It 'Positional argmuent' {
        $r = Test-IPv4Address '10.11.12.13' -ErrorAction Stop
        $r | Should -BeOfType 'System.Boolean'
        $r | Should -Be $true
    }

    Context TestCases1 {
        $testCases1 = @(
            @{IP = '0.0.0.0'                      ; IPOnly = $true  ; Mask = $true  ; Length = $true  ; AllowMask = $true  ; RequireMask = $false}
            @{IP = '255.255.128.0'                ; IPOnly = $true  ; Mask = $true  ; Length = $true  ; AllowMask = $true  ; RequireMask = $false}
            @{IP = '255.255.0.255'                ; IPOnly = $true  ; Mask = $false ; Length = $false ; AllowMask = $true  ; RequireMask = $false}
            @{IP = '10.12.12.13'                  ; IPOnly = $true  ; Mask = $false ; Length = $false ; AllowMask = $true  ; RequireMask = $false}
            @{IP = '10.12.12.13'                  ; IPOnly = $true  ; Mask = $false ; Length = $false ; AllowMask = $true  ; RequireMask = $false}
            @{IP = '0.0.0.0/0'                    ; IPOnly = $false ; Mask = $false ; Length = $false ; AllowMask = $true  ; RequireMask = $true }
            @{IP = '255.255.255.255/0'            ; IPOnly = $false ; Mask = $false ; Length = $false ; AllowMask = $true  ; RequireMask = $true }
            @{IP = '10.12.12.13/0'                ; IPOnly = $false ; Mask = $false ; Length = $false ; AllowMask = $true  ; RequireMask = $true }
            @{IP = '10.12.12.13/18'               ; IPOnly = $false ; Mask = $false ; Length = $false ; AllowMask = $true  ; RequireMask = $true }
            @{IP = '10.12.12.13/32'               ; IPOnly = $false ; Mask = $false ; Length = $false ; AllowMask = $true  ; RequireMask = $true }
            @{IP = '10.12.12.13/33'               ; IPOnly = $false ; Mask = $false ; Length = $false ; AllowMask = $false ; RequireMask = $false}
            @{IP = '10.12.12.13/255.255.224.0'    ; IPOnly = $false ; Mask = $false ; Length = $false ; AllowMask = $true  ; RequireMask = $true }
            @{IP = '10.12.12.13 255.255.224.0'    ; IPOnly = $false ; Mask = $false ; Length = $false ; AllowMask = $true  ; RequireMask = $true }
            @{IP = '10.12.12.13  255.255.224.0'   ; IPOnly = $false ; Mask = $false ; Length = $false ; AllowMask = $false ; RequireMask = $false}
            @{IP = '10.12.12.13/255.255.0.224'    ; IPOnly = $false ; Mask = $false ; Length = $false ; AllowMask = $false ; RequireMask = $false}
            @{IP = -1                             ; IPOnly = $false ; Mask = $false ; Length = $false ; AllowMask = $false ; RequireMask = $false}
            @{IP = 0                              ; IPOnly = $false ; Mask = $false ; Length = $true  ; AllowMask = $false ; RequireMask = $false}
            @{IP = 32                             ; IPOnly = $false ; Mask = $false ; Length = $true  ; AllowMask = $false ; RequireMask = $false}
            @{IP = 33                             ; IPOnly = $false ; Mask = $false ; Length = $false ; AllowMask = $false ; RequireMask = $false}
            @{IP = 'abcdef'                       ; IPOnly = $false ; Mask = $false ; Length = $false ; AllowMask = $false ; RequireMask = $false}
        )

        It 'Test-IPv4Address -IP <IP> -IPOnly == <IPOnly>' -TestCases $testCases1 {
            param ($IP, $IPOnly)
            $r = Test-IPv4Address -IP $IP -IPOnly -ErrorAction Stop
            $r | Should -BeOfType 'System.Boolean'
            $r | Should -Be $IPOnly
        }

        It 'Test-IPv4Address -IP <IP> -Mask == <Mask>' -TestCases $testCases1 {
            param ($IP, $Mask)
            $r = Test-IPv4Address -IP $IP -Mask -ErrorAction Stop
            $r | Should -BeOfType 'System.Boolean'
            $r | Should -Be $Mask
        }

        It 'Test-IPv4Address -IP <IP> -Mask -AllowLength == <Length>' -TestCases $testCases1 {
            param ($IP, $Length)
            $r = Test-IPv4Address -IP $IP -Mask -AllowLength -ErrorAction Stop
            $r | Should -BeOfType 'System.Boolean'
            $r | Should -Be $Length
        }

        It 'Test-IPv4Address -IP <IP> -AllowMask == <AllowMask>' -TestCases $testCases1 {
            param ($IP, $AllowMask)
            $r = Test-IPv4Address -IP $IP -AllowMask -ErrorAction Stop
            $r | Should -BeOfType 'System.Boolean'
            $r | Should -Be $AllowMask
        }

        It 'Test-IPv4Address -IP <IP> -RequireMask == <RequireMask>' -TestCases $testCases1 {
            param ($IP, $RequireMask)
            $r = Test-IPv4Address -IP $IP -RequireMask -ErrorAction Stop
            $r | Should -BeOfType 'System.Boolean'
            $r | Should -Be $RequireMask
        }
    }
}
