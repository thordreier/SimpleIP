# Invoke-Pester -Path .\Pester\Test-IPv6Address.Tests.ps1 -Output Detailed
Describe 'Test-IPv6Address' {

    It 'Positional argmuent' {
        $r = Test-IPv6Address 'fc00:a:b::c' -ErrorAction Stop
        $r | Should -BeOfType 'System.Boolean'
        $r | Should -Be $true
    }

    Context TestCases1 {
        $testCases1 = @(
            @{IP = '::1'         ; IPOnly = $true  ; AllowPrefix = $true  ; RequirePrefix = $false}
            @{IP = '::1/128'     ; IPOnly = $false ; AllowPrefix = $true  ; RequirePrefix = $true }
            @{IP = 'a:b::c'      ; IPOnly = $true  ; AllowPrefix = $true  ; RequirePrefix = $false}
            @{IP = 'a:b::c/0'    ; IPOnly = $false ; AllowPrefix = $true  ; RequirePrefix = $true}
            @{IP = 'a:b::c/57'   ; IPOnly = $false ; AllowPrefix = $true  ; RequirePrefix = $true}
            @{IP = 'a:b::/57'    ; IPOnly = $false ; AllowPrefix = $true  ; RequirePrefix = $true}
            @{IP = 'a:b::g'      ; IPOnly = $false ; AllowPrefix = $false ; RequirePrefix = $false}
            @{IP = 'a:b::c::d'   ; IPOnly = $false ; AllowPrefix = $false ; RequirePrefix = $false}
            @{IP = 'a:b::c/128'  ; IPOnly = $false ; AllowPrefix = $true  ; RequirePrefix = $true}
            @{IP = 'a:b::c/129'  ; IPOnly = $false ; AllowPrefix = $false ; RequirePrefix = $false}
        )

        It 'Test-IPv6Address -IP <IP> -IPOnly == <IPOnly>' -TestCases $testCases1 {
            param ($IP, $IPOnly)
            $r = Test-IPv6Address -IP $IP -IPOnly -ErrorAction Stop
            $r | Should -BeOfType 'System.Boolean'
            $r | Should -Be $IPOnly
        }

        It 'Test-IPv6Address -IP <IP> -AllowPrefix == <AllowPrefix>' -TestCases $testCases1 {
            param ($IP, $AllowPrefix)
            $r = Test-IPv6Address -IP $IP -AllowPrefix -ErrorAction Stop
            $r | Should -BeOfType 'System.Boolean'
            $r | Should -Be $AllowPrefix
        }

        It 'Test-IPv6Address -IP <IP> -RequirePrefix == <RequirePrefix>' -TestCases $testCases1 {
            param ($IP, $RequirePrefix)
            $r = Test-IPv6Address -IP $IP -RequirePrefix -ErrorAction Stop
            $r | Should -BeOfType 'System.Boolean'
            $r | Should -Be $RequirePrefix
        }
    }
}
