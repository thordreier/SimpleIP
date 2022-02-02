# Invoke-Pester -Path .\Pester\Test-IPv4Subnet.Tests.ps1 -Output Detailed
Describe 'Test-IPv4Subnet' {

    It 'Positional argmuent' {
        $r = Test-IPv4Subnet 10.11.12.12/30 -ErrorAction Stop
        $r | Should -BeOfType 'System.Boolean'
        $r | Should -Be $true
    }

    Context TestCases1 {
        $testCases1 = @(
            @{Subnet = '0.0.0.0'        ; Mask = $null ; Result = $false}
            @{Subnet = '0.0.0.0'        ; Mask = 0     ; Result = $true}
            @{Subnet = '0.0.0.0/0'      ; Mask = $null ; Result = $true}
            @{Subnet = '192.168.5.5/24' ; Mask = $null ; Result = $false}
            @{Subnet = '192.168.5.0/24' ; Mask = $null ; Result = $true}
            @{Subnet = '192.168.5.0/24' ; Mask = 24    ; Result = $true}
            @{Subnet = '192.168.5.0'    ; Mask = 24    ; Result = $true}
            @{Subnet = '192.168.5.0/16' ; Mask = 16    ; Result = $false}
            @{Subnet = '192.168.5.0'    ; Mask = 16    ; Result = $false}
        )

        It 'Test-IPv4Subnet -Subnet <Subnet> -Mask <Mask> == <Result>' -TestCases $testCases1 {
            param ($Subnet, $Mask, $Result)
            $params = @{
                Subnet = $Subnet
            }
            if ($Mask -ne $null) { $params['Mask'] = $Mask }
            $global:params = $params
            $r = Test-IPv4Subnet @params -ErrorAction Stop
            $r | Should -BeOfType 'System.Boolean'
            $r | Should -Be $Result
        }
    }

    Context Warning {
        It 'Test-IPv4Subnet -Subnet 192.168.5.0/24 -Mask 16  (warning)' {
            {Test-IPv4Subnet -Subnet 192.168.5.0/24 -Mask 16 -ErrorAction Stop -WarningAction SilentlyContinue -WarningVariable w ; throw $w} | Should -Throw '*Mask set to*but*Using*'
        }
    }
}
