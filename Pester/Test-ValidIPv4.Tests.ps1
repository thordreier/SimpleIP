# Invoke-Pester -Path .\Pester\Test-ValidIPv4.Tests.ps1 -Output Detailed
Describe 'Test-ValidIPv4' {

    It 'Positional argmuent' {
        $r = Test-ValidIPv4 '10.11.12.13' -ErrorAction Stop
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
            #>
        )

        It 'Test-ValidIPv4 -IP <IP> -IPOnly == <IPOnly>' -TestCases $testCases1 {
            param ($IP, $IPOnly)
            $r = Test-ValidIPv4 -IP $IP -IPOnly -ErrorAction Stop
            $r | Should -BeOfType 'System.Boolean'
            $r | Should -Be $IPOnly
        }

        It 'Test-ValidIPv4 -IP <IP> -Mask == <Mask>' -TestCases $testCases1 {
            param ($IP, $Mask)
            $r = Test-ValidIPv4 -IP $IP -Mask -ErrorAction Stop
            $r | Should -BeOfType 'System.Boolean'
            $r | Should -Be $Mask
        }

        It 'Test-ValidIPv4 -IP <IP> -Mask -AllowLength == <Length>' -TestCases $testCases1 {
            param ($IP, $Length)
            $r = Test-ValidIPv4 -IP $IP -Mask -AllowLength -ErrorAction Stop
            $r | Should -BeOfType 'System.Boolean'
            $r | Should -Be $Length
        }

        It 'Test-ValidIPv4 -IP <IP> -AllowMask == <AllowMask>' -TestCases $testCases1 {
            param ($IP, $AllowMask)
            $r = Test-ValidIPv4 -IP $IP -AllowMask -ErrorAction Stop
            $r | Should -BeOfType 'System.Boolean'
            $r | Should -Be $AllowMask
        }

        It 'Test-ValidIPv4 -IP <IP> -RequireMask == <RequireMask>' -TestCases $testCases1 {
            param ($IP, $RequireMask)
            $r = Test-ValidIPv4 -IP $IP -RequireMask -ErrorAction Stop
            $r | Should -BeOfType 'System.Boolean'
            $r | Should -Be $RequireMask
        }
    }
}
