# Invoke-Pester -Path .\Pester\Convert-SubnetMaskToBits.Tests.ps1 -Output Detailed
Describe 'Convert-SubnetMaskToBits' {

    It 'Positional argmuent' {
        $r = Convert-SubnetMaskToBits 255.255.0.0 -ErrorAction Stop
        $r | Should -BeOfType 'System.Byte'
        $r | Should -Be '16'
    }

    Context TestCases1 {
        $testCases1 = @(
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

        It 'Convert-BitsToSubnetMask -Mask <Mask> == <Dec>' -TestCases $testCases1 {
            param ($Mask, $Dec)
            $r = Convert-SubnetMaskToBits -Mask $Mask -ErrorAction Stop
            $r | Should -BeOfType 'System.Byte'
            $r | Should -Be $Dec
        }

        It 'Convert-BitsToSubnetMask -Mask <Mask> -Binary == <Bin>' -TestCases $testCases1 {
            param ($Mask, $Bin)
            $r = Convert-SubnetMaskToBits -Mask $Mask -Binary -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Bin
        }
    }

    Context TestCasesBackAndForth1 {
        $testCasesBackAndForth1 = (0..32).ForEach({@{Mask = $_ ; Result = $_}})

        It '<Mask> | Convert-BitsToSubnetMask | Convert-SubnetMaskToBits == <Result>' -TestCases $testCasesBackAndForth1 {
            param ($Mask, $Result)
            $r = $Mask | Convert-BitsToSubnetMask -ErrorAction Stop | Convert-SubnetMaskToBits -ErrorAction Stop
            $r | Should -BeOfType 'System.Byte'
            $r | Should -Be $Result
        }
    }

    Context TestCasesThrow1 {
        $testCasesThrow1 = @(
            @{Mask = -1            ; Throw = '*is not a valid subnet mask*'}
            @{Mask = 33            ; Throw = '*is not a valid subnet mask*'}
            @{Mask = '255.0.255.0' ; Throw = '*is not a valid subnet mask*'}
            @{Mask = 'abc'         ; Throw = '*is not a valid subnet mask*'}
        )

        It 'Convert-SubnetMaskToBits -Mask <Mask>  (throw)' -TestCases $testCasesThrow1 {
            param ($Mask, $Throw)
            {Convert-SubnetMaskToBits -Mask $Mask -ErrorAction Stop} | Should -Throw $Throw
        }
    }
}
