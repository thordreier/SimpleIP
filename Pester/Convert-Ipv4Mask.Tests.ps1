# Invoke-Pester -Path .\Pester\Convert-Ipv4Mask.Tests.ps1 -Output Detailed
Describe 'Convert-Ipv4Mask' {

    It 'Positional argmuent' {
        $r = Convert-Ipv4Mask 255.255.0.0 -ErrorAction Stop
        $r | Should -BeOfType 'System.String'
        $r | Should -Be '/16'
    }

    Context TestCases1 {
        $testCases1 = @(
            @{Mask = '0.0.0.0'         ; Bits =  0 ; Int =          0 ; Bin = '00000000000000000000000000000000' ; Hex = '00000000'}
            @{Mask = '128.0.0.0'       ; Bits =  1 ; Int = 2147483648 ; Bin = '10000000000000000000000000000000' ; Hex = '80000000'}
            @{Mask = '192.0.0.0'       ; Bits =  2 ; Int = 3221225472 ; Bin = '11000000000000000000000000000000' ; Hex = 'C0000000'}
            @{Mask = '224.0.0.0'       ; Bits =  3 ; Int = 3758096384 ; Bin = '11100000000000000000000000000000' ; Hex = 'E0000000'}
            @{Mask = '240.0.0.0'       ; Bits =  4 ; Int = 4026531840 ; Bin = '11110000000000000000000000000000' ; Hex = 'F0000000'}
            @{Mask = '248.0.0.0'       ; Bits =  5 ; Int = 4160749568 ; Bin = '11111000000000000000000000000000' ; Hex = 'F8000000'}
            @{Mask = '252.0.0.0'       ; Bits =  6 ; Int = 4227858432 ; Bin = '11111100000000000000000000000000' ; Hex = 'FC000000'}
            @{Mask = '254.0.0.0'       ; Bits =  7 ; Int = 4261412864 ; Bin = '11111110000000000000000000000000' ; Hex = 'FE000000'}
            @{Mask = '255.0.0.0'       ; Bits =  8 ; Int = 4278190080 ; Bin = '11111111000000000000000000000000' ; Hex = 'FF000000'}
            @{Mask = '255.128.0.0'     ; Bits =  9 ; Int = 4286578688 ; Bin = '11111111100000000000000000000000' ; Hex = 'FF800000'}
            @{Mask = '255.192.0.0'     ; Bits = 10 ; Int = 4290772992 ; Bin = '11111111110000000000000000000000' ; Hex = 'FFC00000'}
            @{Mask = '255.224.0.0'     ; Bits = 11 ; Int = 4292870144 ; Bin = '11111111111000000000000000000000' ; Hex = 'FFE00000'}
            @{Mask = '255.240.0.0'     ; Bits = 12 ; Int = 4293918720 ; Bin = '11111111111100000000000000000000' ; Hex = 'FFF00000'}
            @{Mask = '255.248.0.0'     ; Bits = 13 ; Int = 4294443008 ; Bin = '11111111111110000000000000000000' ; Hex = 'FFF80000'}
            @{Mask = '255.252.0.0'     ; Bits = 14 ; Int = 4294705152 ; Bin = '11111111111111000000000000000000' ; Hex = 'FFFC0000'}
            @{Mask = '255.254.0.0'     ; Bits = 15 ; Int = 4294836224 ; Bin = '11111111111111100000000000000000' ; Hex = 'FFFE0000'}
            @{Mask = '255.255.0.0'     ; Bits = 16 ; Int = 4294901760 ; Bin = '11111111111111110000000000000000' ; Hex = 'FFFF0000'}
            @{Mask = '255.255.128.0'   ; Bits = 17 ; Int = 4294934528 ; Bin = '11111111111111111000000000000000' ; Hex = 'FFFF8000'}
            @{Mask = '255.255.192.0'   ; Bits = 18 ; Int = 4294950912 ; Bin = '11111111111111111100000000000000' ; Hex = 'FFFFC000'}
            @{Mask = '255.255.224.0'   ; Bits = 19 ; Int = 4294959104 ; Bin = '11111111111111111110000000000000' ; Hex = 'FFFFE000'}
            @{Mask = '255.255.240.0'   ; Bits = 20 ; Int = 4294963200 ; Bin = '11111111111111111111000000000000' ; Hex = 'FFFFF000'}
            @{Mask = '255.255.248.0'   ; Bits = 21 ; Int = 4294965248 ; Bin = '11111111111111111111100000000000' ; Hex = 'FFFFF800'}
            @{Mask = '255.255.252.0'   ; Bits = 22 ; Int = 4294966272 ; Bin = '11111111111111111111110000000000' ; Hex = 'FFFFFC00'}
            @{Mask = '255.255.254.0'   ; Bits = 23 ; Int = 4294966784 ; Bin = '11111111111111111111111000000000' ; Hex = 'FFFFFE00'}
            @{Mask = '255.255.255.0'   ; Bits = 24 ; Int = 4294967040 ; Bin = '11111111111111111111111100000000' ; Hex = 'FFFFFF00'}
            @{Mask = '255.255.255.128' ; Bits = 25 ; Int = 4294967168 ; Bin = '11111111111111111111111110000000' ; Hex = 'FFFFFF80'}
            @{Mask = '255.255.255.192' ; Bits = 26 ; Int = 4294967232 ; Bin = '11111111111111111111111111000000' ; Hex = 'FFFFFFC0'}
            @{Mask = '255.255.255.224' ; Bits = 27 ; Int = 4294967264 ; Bin = '11111111111111111111111111100000' ; Hex = 'FFFFFFE0'}
            @{Mask = '255.255.255.240' ; Bits = 28 ; Int = 4294967280 ; Bin = '11111111111111111111111111110000' ; Hex = 'FFFFFFF0'}
            @{Mask = '255.255.255.248' ; Bits = 29 ; Int = 4294967288 ; Bin = '11111111111111111111111111111000' ; Hex = 'FFFFFFF8'}
            @{Mask = '255.255.255.252' ; Bits = 30 ; Int = 4294967292 ; Bin = '11111111111111111111111111111100' ; Hex = 'FFFFFFFC'}
            @{Mask = '255.255.255.254' ; Bits = 31 ; Int = 4294967294 ; Bin = '11111111111111111111111111111110' ; Hex = 'FFFFFFFE'}
            @{Mask = '255.255.255.255' ; Bits = 32 ; Int = 4294967295 ; Bin = '11111111111111111111111111111111' ; Hex = 'FFFFFFFF'}
        )

        It 'Convert-Ipv4Mask -Mask <Mask> == /<Bits>' -TestCases $testCases1 {
            param ($Mask, $Bits)
            $r = Convert-Ipv4Mask -Mask $Mask -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be "/$Bits"
        }

        It 'Convert-Ipv4Mask -QuadDot -Mask <Mask> == <Mask>' -TestCases $testCases1 {
            param ($Mask)
            $r = Convert-Ipv4Mask -QuadDot -Mask $Mask -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Mask
        }

        It 'Convert-Ipv4Mask -Bits -Mask <Mask> == <Bits>' -TestCases $testCases1 {
            param ($Mask, $Bits)
            $r = Convert-Ipv4Mask -Bits -Mask $Mask -ErrorAction Stop
            $r | Should -BeOfType 'System.Byte'
            $r | Should -Be $Bits
        }

        It 'Convert-Ipv4Mask -BitsWithSlash -Mask <Mask> == /<Bits>' -TestCases $testCases1 {
            param ($Mask, $Bits)
            $r = Convert-Ipv4Mask -BitsWithSlash -Mask $Mask -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be "/$Bits"
        }

        It 'Convert-Ipv4Mask -Integer -Mask <Mask> == <Int>' -TestCases $testCases1 {
            param ($Mask, $Int)
            $r = Convert-Ipv4Mask -Integer -Mask $Mask -ErrorAction Stop
            $r | Should -BeOfType 'System.UInt32'
            $r | Should -Be $Int
        }

        It 'Convert-Ipv4Mask -Binary -Mask <Mask> == <Bin>' -TestCases $testCases1 {
            param ($Mask, $Bin)
            $r = Convert-Ipv4Mask -Binary -Mask $Mask -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Bin
        }

        It 'Convert-Ipv4Mask -Mask <Bits> == <Mask>' -TestCases $testCases1 {
            param ($Bits, $Mask)
            $r = Convert-Ipv4Mask -Mask $Bits -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Mask
        }

        It 'Convert-Ipv4Mask -QuadDot -Mask <Bits> == <Mask>' -TestCases $testCases1 {
            param ($Bits, $Mask)
            $r = Convert-Ipv4Mask -QuadDot -Mask $Bits -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Mask
        }

        It 'Convert-Ipv4Mask -Bits -Mask <Bits> == <Bits>' -TestCases $testCases1 {
            param ($Bits)
            $r = Convert-Ipv4Mask -Bits -Mask $Bits -ErrorAction Stop
            $r | Should -BeOfType 'System.Byte'
            $r | Should -Be $Bits
        }

        It 'Convert-Ipv4Mask -BitsWithSlash -Mask <Bits> == /<Bits>' -TestCases $testCases1 {
            param ($Bits)
            $r = Convert-Ipv4Mask -BitsWithSlash -Mask $Bits -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be "/$Bits"
        }

        It 'Convert-Ipv4Mask -Integer -Mask <Bits> == <Int>' -TestCases $testCases1 {
            param ($Bits, $Int)
            $r = Convert-Ipv4Mask -Integer -Mask $Bits -ErrorAction Stop
            $r | Should -BeOfType 'System.UInt32'
            $r | Should -Be $Int
        }

        It 'Convert-Ipv4Mask -Binary -Mask <Bits> == <Bin>' -TestCases $testCases1 {
            param ($Bits, $Bin)
            $r = Convert-Ipv4Mask -Binary -Mask $Bits -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Bin
        }

        It 'Convert-Ipv4Mask -Mask /<Bits> == <Mask>' -TestCases $testCases1 {
            param ($Bits, $Mask)
            $r = Convert-Ipv4Mask -Mask "/$Bits" -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Mask
        }

        It 'Convert-Ipv4Mask -QuadDot -Mask /<Bits> == <Mask>' -TestCases $testCases1 {
            param ($Bits, $Mask)
            $r = Convert-Ipv4Mask -QuadDot -Mask "/$Bits" -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Mask
        }

        It 'Convert-Ipv4Mask -Bits -Mask /<Bits> == <Bits>' -TestCases $testCases1 {
            param ($Bits)
            $r = Convert-Ipv4Mask -Bits -Mask "/$Bits" -ErrorAction Stop
            $r | Should -BeOfType 'System.Byte'
            $r | Should -Be $Bits
        }

        It 'Convert-Ipv4Mask -BitsWithSlash -Mask /<Bits> == /<Bits>' -TestCases $testCases1 {
            param ($Bits)
            $r = Convert-Ipv4Mask -BitsWithSlash -Mask "/$Bits" -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be "/$Bits"
        }

        It 'Convert-Ipv4Mask -Integer -Mask /<Bits> == <Int>' -TestCases $testCases1 {
            param ($Bits, $Int)
            $r = Convert-Ipv4Mask -Integer -Mask "/$Bits" -ErrorAction Stop
            $r | Should -BeOfType 'System.UInt32'
            $r | Should -Be $Int
        }

        It 'Convert-Ipv4Mask -Binary -Mask /<Bits> == <Bin>' -TestCases $testCases1 {
            param ($Bits, $Bin)
            $r = Convert-Ipv4Mask -Binary -Mask "/$Bits" -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Bin
        }

        It 'Convert-Ipv4Mask -Mask <Int> == <Mask>' -TestCases $testCases1 {
            param ($Int, $Mask)
            $r = Convert-Ipv4Mask -Mask $Int -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Mask
        }

        It 'Convert-Ipv4Mask -QuadDot -Mask <Int> == <Mask>' -TestCases $testCases1 {
            param ($Int, $Mask)
            $r = Convert-Ipv4Mask -QuadDot -Mask $Int -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Mask
        }

        It 'Convert-Ipv4Mask -Bits -Mask <Int> == <Bits>' -TestCases $testCases1 {
            param ($Int, $Bits)
            $r = Convert-Ipv4Mask -Bits -Mask $Int -ErrorAction Stop
            $r | Should -BeOfType 'System.Byte'
            $r | Should -Be $Bits
        }

        It 'Convert-Ipv4Mask -BitsWithSlash -Mask <Int> == /<Bits>' -TestCases $testCases1 {
            param ($Int, $Bits)
            $r = Convert-Ipv4Mask -BitsWithSlash -Mask $Int -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be "/$Bits"
        }

        It 'Convert-Ipv4Mask -Integer -Mask <Int> == <Int>' -TestCases $testCases1 {
            param ($Int)
            $r = Convert-Ipv4Mask -Integer -Mask $Int -ErrorAction Stop
            $r | Should -BeOfType 'System.UInt32'
            $r | Should -Be $Int
        }

        It 'Convert-Ipv4Mask -Binary -Mask <Int> == <Bin>' -TestCases $testCases1 {
            param ($Int, $Bin)
            $r = Convert-Ipv4Mask -Binary -Mask $Int -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Bin
        }

        It 'Convert-Ipv4Mask -Mask <Bin> == <Mask>' -TestCases $testCases1 {
            param ($Bin, $Bits)
            $r = Convert-Ipv4Mask -Mask $Bin -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Mask
        }

        It 'Convert-Ipv4Mask -QuadDot -Mask <Bin> == <Mask>' -TestCases $testCases1 {
            param ($Bin, $Mask)
            $r = Convert-Ipv4Mask -QuadDot -Mask $Bin -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Mask
        }

        It 'Convert-Ipv4Mask -Bits -Mask <Bin> == <Bits>' -TestCases $testCases1 {
            param ($Bin, $Bits)
            $r = Convert-Ipv4Mask -Bits -Mask $Bin -ErrorAction Stop
            $r | Should -BeOfType 'System.Byte'
            $r | Should -Be $Bits
        }

        It 'Convert-Ipv4Mask -BitsWithSlash -Mask <Bin> == /<Bits>' -TestCases $testCases1 {
            param ($Bin, $Bits)
            $r = Convert-Ipv4Mask -BitsWithSlash -Mask $Bin -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be "/$Bits"
        }

        It 'Convert-Ipv4Mask -Integer -Mask <Bin> == <Int>' -TestCases $testCases1 {
            param ($Bin, $Int)
            $r = Convert-Ipv4Mask -Integer -Mask $Bin -ErrorAction Stop
            $r | Should -BeOfType 'System.UInt32'
            $r | Should -Be $Int
        }

        It 'Convert-Ipv4Mask -Binary -Mask <Bin> == <Bin>' -TestCases $testCases1 {
            param ($Bin)
            $r = Convert-Ipv4Mask -Binary -Mask $Bin -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Bin
        }
    }

    Context TestCasesBackAndForth1 {
        $testCasesBackAndForth1 = (0..32).ForEach({@{Mask = $_}})

        It '<Mask> | Convert-Ipv4Mask | Convert-Ipv4Mask -Bits == <Result>' -TestCases $testCasesBackAndForth1 {
            param ($Mask)
            $r = $Mask | Convert-Ipv4Mask -ErrorAction Stop | Convert-Ipv4Mask -Bits -ErrorAction Stop
            $r | Should -BeOfType 'System.Byte'
            $r | Should -Be $Mask
        }

        It '<Mask> | Convert-Ipv4Mask -QuadDot | Convert-Ipv4Mask -Bits == <Result>' -TestCases $testCasesBackAndForth1 {
            param ($Mask)
            $r = $Mask | Convert-Ipv4Mask -QuadDot -ErrorAction Stop | Convert-Ipv4Mask -Bits -ErrorAction Stop
            $r | Should -BeOfType 'System.Byte'
            $r | Should -Be $Mask
        }

        It '<Mask> | Convert-Ipv4Mask -Bits | Convert-Ipv4Mask -Bits == <Result>' -TestCases $testCasesBackAndForth1 {
            param ($Mask)
            $r = $Mask | Convert-Ipv4Mask -Bits -ErrorAction Stop | Convert-Ipv4Mask -Bits -ErrorAction Stop
            $r | Should -BeOfType 'System.Byte'
            $r | Should -Be $Mask
        }

        It '<Mask> | Convert-Ipv4Mask -BitsWithSlash | Convert-Ipv4Mask -Bits == <Result>' -TestCases $testCasesBackAndForth1 {
            param ($Mask)
            $r = $Mask | Convert-Ipv4Mask -BitsWithSlash -ErrorAction Stop | Convert-Ipv4Mask -Bits -ErrorAction Stop
            $r | Should -BeOfType 'System.Byte'
            $r | Should -Be $Mask
        }

        It '<Mask> | Convert-Ipv4Mask -Integer | Convert-Ipv4Mask -Bits == <Result>' -TestCases $testCasesBackAndForth1 {
            param ($Mask)
            $r = $Mask | Convert-Ipv4Mask -Integer -ErrorAction Stop | Convert-Ipv4Mask -Bits -ErrorAction Stop
            $r | Should -BeOfType 'System.Byte'
            $r | Should -Be $Mask
        }

        It '<Mask> | Convert-Ipv4Mask -Binary | Convert-Ipv4Mask -Bits == <Result>' -TestCases $testCasesBackAndForth1 {
            param ($Mask)
            $r = $Mask | Convert-Ipv4Mask -Binary -ErrorAction Stop | Convert-Ipv4Mask -Bits -ErrorAction Stop
            $r | Should -BeOfType 'System.Byte'
            $r | Should -Be $Mask
        }
    }

    Context TestCasesThrow1 {
        $testCasesThrow1 = @(
            @{Mask = -1            ; Throw = '*is not a valid subnet mask*'}
            @{Mask = 33            ; Throw = '*is not a valid subnet mask*'}
            @{Mask = '255.0.255.0' ; Throw = '*is not a valid subnet mask*'}
            @{Mask = 'abc'         ; Throw = '*is not a valid subnet mask*'}
        )

        It 'Convert-Ipv4Mask -Mask <Mask>  (throw)' -TestCases $testCasesThrow1 {
            param ($Mask, $Throw)
            {Convert-Ipv4Mask -Mask $Mask -ErrorAction Stop} | Should -Throw $Throw
        }
    }
}
