# Invoke-Pester -Path .\Pester\Test-IPv6Subnet.Tests.ps1 -Output Detailed
Describe 'Test-IPv6Subnet' {

    It 'Positional argmuent' {
        $r = Test-IPv6Subnet a:b:c::/64 -ErrorAction Stop
        $r | Should -BeOfType 'System.Boolean'
        $r | Should -Be $true
    }

    Context TestCases1 {
        $testCases1 = @(
            @{Subnet = '0::'            ; Prefix = $null ; Result = $false}
            @{Subnet = '0::'            ; Prefix = 0     ; Result = $true}
            @{Subnet = '0::/0'          ; Prefix = $null ; Result = $true}
            @{Subnet = 'a:b:c:d::5/64'  ; Prefix = $null ; Result = $false}
            @{Subnet = 'a:b:c:d::/64'   ; Prefix = $null ; Result = $true}
            @{Subnet = 'a:b:c:d::/64'   ; Prefix = 64    ; Result = $true}
            @{Subnet = 'a:b:c:d::'      ; Prefix = 64    ; Result = $true}
            @{Subnet = 'a:b:c:d::/16'   ; Prefix = 16    ; Result = $false}
            @{Subnet = 'a:b:c:d::'      ; Prefix = 16    ; Result = $false}
            @{Subnet = 'a:0:0:b:0::/64' ; Prefix = $null ; Result = $true}
            @{Subnet = 'a:0:0:0:b::/64' ; Prefix = $null ; Result = $false}
        )

        It 'Test-IPv6Subnet -Subnet <Subnet> -Prefix <Prefix> == <Result>' -TestCases $testCases1 {
            param ($Subnet, $Prefix, $Result)
            $params = @{
                Subnet = $Subnet
            }
            if ($Prefix -ne $null) { $params['Prefix'] = $Prefix }
            $global:params = $params
            $r = Test-IPv6Subnet @params -ErrorAction Stop
            $r | Should -BeOfType 'System.Boolean'
            $r | Should -Be $Result
        }
    }

    Context Warning {
        It 'Test-IPv6Subnet -Subnet a:b:c::/56 -Prefix 64  (warning)' {
            {Test-IPv6Subnet -Subnet a:b:c::/56 -Prefix 64 -ErrorAction Stop -WarningAction SilentlyContinue -WarningVariable w ; throw $w} | Should -Throw '*Prefix set to*but*Using*'
        }
    }
}
