# Invoke-Pester -Path .\Pester\Convert-IntToIPv4.Tests.ps1 -Output Detailed
Describe 'Convert-IntToIPv4' {

    It 'Positional argmuent' {
        $r = Convert-IntToIPv4 16909060 -ErrorAction Stop
        $r | Should -BeOfType 'System.String'
        $r | Should -Be 1.2.3.4
    }

    Context TestCases1 {
        $testCases1 = @(
            @{Ip = '0.0.0.0'         ; Int = [uint32]::MinValue ; Bin = '00000000000000000000000000000000'}
            @{Ip = '255.255.255.255' ; Int = [uint32]::MaxValue ; Bin = '11111111111111111111111111111111'}
            @{Ip = '1.2.3.4'         ; Int = 16909060           ; Bin = '00000001000000100000001100000100'}
            @{Ip = '10.20.30.40'     ; Int = 169090600          ; Bin = '00001010000101000001111000101000'}
            @{Ip = '192.168.254.253' ; Int = 3232300797         ; Bin = '11000000101010001111111011111101'}
        )

        It 'Convert-IntToIPv4 -Ip <Int> == <Ip>' -TestCases $testCases1 {
            param ($Ip, $Int)
            $r = Convert-IntToIPv4 -Ip $Int -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Ip
        }

        It 'Convert-IntToIPv4 -Ip <Bin> == <Ip>' -TestCases $testCases1 {
            param ($Ip, $Bin)
            $r = Convert-IntToIPv4 -Ip $Bin -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Ip
        }
    }

    Context TestCasesSubnets1 {
        $testCasesSubnets1 = @(
            @{Mask = '0.0.0.0'         ; Dec =  0 ; Bin = '00000000000000000000000000000000' ; Hex = '00000000'}
            @{Mask = '128.0.0.0'       ; Dec =  1 ; Bin = '10000000000000000000000000000000' ; Hex = '80000000'}
            @{Mask = '192.0.0.0'       ; Dec =  2 ; Bin = '11000000000000000000000000000000' ; Hex = 'C0000000'}
            @{Mask = '224.0.0.0'       ; Dec =  3 ; Bin = '11100000000000000000000000000000' ; Hex = 'E0000000'}
            @{Mask = '240.0.0.0'       ; Dec =  4 ; Bin = '11110000000000000000000000000000' ; Hex = 'F0000000'}
            @{Mask = '248.0.0.0'       ; Dec =  5 ; Bin = '11111000000000000000000000000000' ; Hex = 'F8000000'}
            @{Mask = '252.0.0.0'       ; Dec =  6 ; Bin = '11111100000000000000000000000000' ; Hex = 'FC000000'}
            @{Mask = '254.0.0.0'       ; Dec =  7 ; Bin = '11111110000000000000000000000000' ; Hex = 'FE000000'}
            @{Mask = '255.0.0.0'       ; Dec =  8 ; Bin = '11111111000000000000000000000000' ; Hex = 'FF000000'}
            @{Mask = '255.128.0.0'     ; Dec =  9 ; Bin = '11111111100000000000000000000000' ; Hex = 'FF800000'}
            @{Mask = '255.192.0.0'     ; Dec = 10 ; Bin = '11111111110000000000000000000000' ; Hex = 'FFC00000'}
            @{Mask = '255.224.0.0'     ; Dec = 11 ; Bin = '11111111111000000000000000000000' ; Hex = 'FFE00000'}
            @{Mask = '255.240.0.0'     ; Dec = 12 ; Bin = '11111111111100000000000000000000' ; Hex = 'FFF00000'}
            @{Mask = '255.248.0.0'     ; Dec = 13 ; Bin = '11111111111110000000000000000000' ; Hex = 'FFF80000'}
            @{Mask = '255.252.0.0'     ; Dec = 14 ; Bin = '11111111111111000000000000000000' ; Hex = 'FFFC0000'}
            @{Mask = '255.254.0.0'     ; Dec = 15 ; Bin = '11111111111111100000000000000000' ; Hex = 'FFFE0000'}
            @{Mask = '255.255.0.0'     ; Dec = 16 ; Bin = '11111111111111110000000000000000' ; Hex = 'FFFF0000'}
            @{Mask = '255.255.128.0'   ; Dec = 17 ; Bin = '11111111111111111000000000000000' ; Hex = 'FFFF8000'}
            @{Mask = '255.255.192.0'   ; Dec = 18 ; Bin = '11111111111111111100000000000000' ; Hex = 'FFFFC000'}
            @{Mask = '255.255.224.0'   ; Dec = 19 ; Bin = '11111111111111111110000000000000' ; Hex = 'FFFFE000'}
            @{Mask = '255.255.240.0'   ; Dec = 20 ; Bin = '11111111111111111111000000000000' ; Hex = 'FFFFF000'}
            @{Mask = '255.255.248.0'   ; Dec = 21 ; Bin = '11111111111111111111100000000000' ; Hex = 'FFFFF800'}
            @{Mask = '255.255.252.0'   ; Dec = 22 ; Bin = '11111111111111111111110000000000' ; Hex = 'FFFFFC00'}
            @{Mask = '255.255.254.0'   ; Dec = 23 ; Bin = '11111111111111111111111000000000' ; Hex = 'FFFFFE00'}
            @{Mask = '255.255.255.0'   ; Dec = 24 ; Bin = '11111111111111111111111100000000' ; Hex = 'FFFFFF00'}
            @{Mask = '255.255.255.128' ; Dec = 25 ; Bin = '11111111111111111111111110000000' ; Hex = 'FFFFFF80'}
            @{Mask = '255.255.255.192' ; Dec = 26 ; Bin = '11111111111111111111111111000000' ; Hex = 'FFFFFFC0'}
            @{Mask = '255.255.255.224' ; Dec = 27 ; Bin = '11111111111111111111111111100000' ; Hex = 'FFFFFFE0'}
            @{Mask = '255.255.255.240' ; Dec = 28 ; Bin = '11111111111111111111111111110000' ; Hex = 'FFFFFFF0'}
            @{Mask = '255.255.255.248' ; Dec = 29 ; Bin = '11111111111111111111111111111000' ; Hex = 'FFFFFFF8'}
            @{Mask = '255.255.255.252' ; Dec = 30 ; Bin = '11111111111111111111111111111100' ; Hex = 'FFFFFFFC'}
            @{Mask = '255.255.255.254' ; Dec = 31 ; Bin = '11111111111111111111111111111110' ; Hex = 'FFFFFFFE'}
            @{Mask = '255.255.255.255' ; Dec = 32 ; Bin = '11111111111111111111111111111111' ; Hex = 'FFFFFFFF'}
        )

        It 'Convert-IntToIPv4 -Ip <Bin> -Binary == <Mask>' -TestCases $testCasesSubnets1 {
            param ($Mask, $Bin)
            $r = Convert-IntToIPv4 -Ip $Bin -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Mask
        }
    }

    Context TestCasesRandom1 {
        $testCasesRandom1 = (0..20).ForEach({@{Int = Get-Random}})

        It '<Int> | Convert-IntToIPv4 | Convert-IPv4ToInt == <Int>' -TestCases $testCasesRandom1 {
            param ($Int)
            $r = $Int | Convert-IntToIPv4 -ErrorAction Stop | Convert-IPv4ToInt -ErrorAction Stop
            $r | Should -BeOfType 'System.Uint32'
            $r | Should -Be $Int
        }
    }

    Context TestCasesRandom2 {
        $testCasesRandom2 = (0..20).ForEach({@{Ip = (0..3).ForEach({Get-Random -Minimum 0 -Maximum 255}) -join '.'}})

        It '<Ip> | Convert-IPv4ToInt | Convert-IntToIPv4 == <Ip>' -TestCases $testCasesRandom2 {
            param ($Ip)
            $r = $Ip | Convert-IPv4ToInt -ErrorAction Stop | Convert-IntToIPv4 -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Ip
        }
    }

    Context TestCasesThrow1 {
        $testCasesThrow1 = @(
            @{Ip = -1                                  ; Throw = '*UInt32*'}
            @{Ip = '253.254.255.256'                   ; Throw = '*UInt32*'}
            @{Ip = '1111111111111111111111111111111'   ; Throw = '*UInt32*'}
            @{Ip = '1111111111111111 1111111111111111' ; Throw = '*UInt32*'}  # FIXXXME? Show we allow spaces in binary address?
            @{Ip = '111111111111111111111111111111111' ; Throw = '*UInt32*'}
            @{Ip = 'abc'                               ; Throw = '*UInt32*'}
        )

        It 'Convert-IntToIPv4 -Ip <Ip>  (throw)' -TestCases $testCasesThrow1 {
            param ($Ip, $Throw)
            {Convert-IntToIPv4 -Ip $Ip -ErrorAction Stop} | Should -Throw $Throw
        }
    }
#>
}
