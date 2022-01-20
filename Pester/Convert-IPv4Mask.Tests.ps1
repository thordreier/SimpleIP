# Invoke-Pester -Path .\Pester\Convert-IPv4Mask.Tests.ps1 -Output Detailed
Describe 'Convert-IPv4Mask' {

    It 'Positional argmuent' {
        $r = Convert-IPv4Mask 255.255.0.0 -ErrorAction Stop
        $r | Should -BeOfType 'System.String'
        $r | Should -Be '/16'
    }

    Context TestCases1 {
        $testCases1 = @(
            @{Mask = '0.0.0.0'         ; Length =  0 ; Int =          0 ; Bin = '00000000000000000000000000000000' ; Hex = '00000000'}
            @{Mask = '128.0.0.0'       ; Length =  1 ; Int = 2147483648 ; Bin = '10000000000000000000000000000000' ; Hex = '80000000'}
            @{Mask = '192.0.0.0'       ; Length =  2 ; Int = 3221225472 ; Bin = '11000000000000000000000000000000' ; Hex = 'C0000000'}
            @{Mask = '224.0.0.0'       ; Length =  3 ; Int = 3758096384 ; Bin = '11100000000000000000000000000000' ; Hex = 'E0000000'}
            @{Mask = '240.0.0.0'       ; Length =  4 ; Int = 4026531840 ; Bin = '11110000000000000000000000000000' ; Hex = 'F0000000'}
            @{Mask = '248.0.0.0'       ; Length =  5 ; Int = 4160749568 ; Bin = '11111000000000000000000000000000' ; Hex = 'F8000000'}
            @{Mask = '252.0.0.0'       ; Length =  6 ; Int = 4227858432 ; Bin = '11111100000000000000000000000000' ; Hex = 'FC000000'}
            @{Mask = '254.0.0.0'       ; Length =  7 ; Int = 4261412864 ; Bin = '11111110000000000000000000000000' ; Hex = 'FE000000'}
            @{Mask = '255.0.0.0'       ; Length =  8 ; Int = 4278190080 ; Bin = '11111111000000000000000000000000' ; Hex = 'FF000000'}
            @{Mask = '255.128.0.0'     ; Length =  9 ; Int = 4286578688 ; Bin = '11111111100000000000000000000000' ; Hex = 'FF800000'}
            @{Mask = '255.192.0.0'     ; Length = 10 ; Int = 4290772992 ; Bin = '11111111110000000000000000000000' ; Hex = 'FFC00000'}
            @{Mask = '255.224.0.0'     ; Length = 11 ; Int = 4292870144 ; Bin = '11111111111000000000000000000000' ; Hex = 'FFE00000'}
            @{Mask = '255.240.0.0'     ; Length = 12 ; Int = 4293918720 ; Bin = '11111111111100000000000000000000' ; Hex = 'FFF00000'}
            @{Mask = '255.248.0.0'     ; Length = 13 ; Int = 4294443008 ; Bin = '11111111111110000000000000000000' ; Hex = 'FFF80000'}
            @{Mask = '255.252.0.0'     ; Length = 14 ; Int = 4294705152 ; Bin = '11111111111111000000000000000000' ; Hex = 'FFFC0000'}
            @{Mask = '255.254.0.0'     ; Length = 15 ; Int = 4294836224 ; Bin = '11111111111111100000000000000000' ; Hex = 'FFFE0000'}
            @{Mask = '255.255.0.0'     ; Length = 16 ; Int = 4294901760 ; Bin = '11111111111111110000000000000000' ; Hex = 'FFFF0000'}
            @{Mask = '255.255.128.0'   ; Length = 17 ; Int = 4294934528 ; Bin = '11111111111111111000000000000000' ; Hex = 'FFFF8000'}
            @{Mask = '255.255.192.0'   ; Length = 18 ; Int = 4294950912 ; Bin = '11111111111111111100000000000000' ; Hex = 'FFFFC000'}
            @{Mask = '255.255.224.0'   ; Length = 19 ; Int = 4294959104 ; Bin = '11111111111111111110000000000000' ; Hex = 'FFFFE000'}
            @{Mask = '255.255.240.0'   ; Length = 20 ; Int = 4294963200 ; Bin = '11111111111111111111000000000000' ; Hex = 'FFFFF000'}
            @{Mask = '255.255.248.0'   ; Length = 21 ; Int = 4294965248 ; Bin = '11111111111111111111100000000000' ; Hex = 'FFFFF800'}
            @{Mask = '255.255.252.0'   ; Length = 22 ; Int = 4294966272 ; Bin = '11111111111111111111110000000000' ; Hex = 'FFFFFC00'}
            @{Mask = '255.255.254.0'   ; Length = 23 ; Int = 4294966784 ; Bin = '11111111111111111111111000000000' ; Hex = 'FFFFFE00'}
            @{Mask = '255.255.255.0'   ; Length = 24 ; Int = 4294967040 ; Bin = '11111111111111111111111100000000' ; Hex = 'FFFFFF00'}
            @{Mask = '255.255.255.128' ; Length = 25 ; Int = 4294967168 ; Bin = '11111111111111111111111110000000' ; Hex = 'FFFFFF80'}
            @{Mask = '255.255.255.192' ; Length = 26 ; Int = 4294967232 ; Bin = '11111111111111111111111111000000' ; Hex = 'FFFFFFC0'}
            @{Mask = '255.255.255.224' ; Length = 27 ; Int = 4294967264 ; Bin = '11111111111111111111111111100000' ; Hex = 'FFFFFFE0'}
            @{Mask = '255.255.255.240' ; Length = 28 ; Int = 4294967280 ; Bin = '11111111111111111111111111110000' ; Hex = 'FFFFFFF0'}
            @{Mask = '255.255.255.248' ; Length = 29 ; Int = 4294967288 ; Bin = '11111111111111111111111111111000' ; Hex = 'FFFFFFF8'}
            @{Mask = '255.255.255.252' ; Length = 30 ; Int = 4294967292 ; Bin = '11111111111111111111111111111100' ; Hex = 'FFFFFFFC'}
            @{Mask = '255.255.255.254' ; Length = 31 ; Int = 4294967294 ; Bin = '11111111111111111111111111111110' ; Hex = 'FFFFFFFE'}
            @{Mask = '255.255.255.255' ; Length = 32 ; Int = 4294967295 ; Bin = '11111111111111111111111111111111' ; Hex = 'FFFFFFFF'}
        )

        It 'Convert-IPv4Mask -Mask <Mask> == /<Length>' -TestCases $testCases1 {
            param ($Mask, $Length)
            $r = Convert-IPv4Mask -Mask $Mask -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be "/$Length"
        }

        It 'Convert-IPv4Mask -QuadDot -Mask <Mask> == <Mask>' -TestCases $testCases1 {
            param ($Mask)
            $r = Convert-IPv4Mask -QuadDot -Mask $Mask -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Mask
        }

        It 'Convert-IPv4Mask -Length -Mask <Mask> == <Length>' -TestCases $testCases1 {
            param ($Mask, $Length)
            $r = Convert-IPv4Mask -Length -Mask $Mask -ErrorAction Stop
            $r | Should -BeOfType 'System.Byte'
            $r | Should -Be $Length
        }

        It 'Convert-IPv4Mask -LengthWithSlash -Mask <Mask> == /<Length>' -TestCases $testCases1 {
            param ($Mask, $Length)
            $r = Convert-IPv4Mask -LengthWithSlash -Mask $Mask -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be "/$Length"
        }

        It 'Convert-IPv4Mask -Integer -Mask <Mask> == <Int>' -TestCases $testCases1 {
            param ($Mask, $Int)
            $r = Convert-IPv4Mask -Integer -Mask $Mask -ErrorAction Stop
            $r | Should -BeOfType 'System.UInt32'
            $r | Should -Be $Int
        }

        It 'Convert-IPv4Mask -Binary -Mask <Mask> == <Bin>' -TestCases $testCases1 {
            param ($Mask, $Bin)
            $r = Convert-IPv4Mask -Binary -Mask $Mask -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Bin
        }

        It 'Convert-IPv4Mask -Mask <Length> == <Mask>' -TestCases $testCases1 {
            param ($Length, $Mask)
            $r = Convert-IPv4Mask -Mask $Length -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Mask
        }

        It 'Convert-IPv4Mask -QuadDot -Mask <Length> == <Mask>' -TestCases $testCases1 {
            param ($Length, $Mask)
            $r = Convert-IPv4Mask -QuadDot -Mask $Length -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Mask
        }

        It 'Convert-IPv4Mask -Length -Mask <Length> == <Length>' -TestCases $testCases1 {
            param ($Length)
            $r = Convert-IPv4Mask -Length -Mask $Length -ErrorAction Stop
            $r | Should -BeOfType 'System.Byte'
            $r | Should -Be $Length
        }

        It 'Convert-IPv4Mask -LengthWithSlash -Mask <Length> == /<Length>' -TestCases $testCases1 {
            param ($Length)
            $r = Convert-IPv4Mask -LengthWithSlash -Mask $Length -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be "/$Length"
        }

        It 'Convert-IPv4Mask -Integer -Mask <Length> == <Int>' -TestCases $testCases1 {
            param ($Length, $Int)
            $r = Convert-IPv4Mask -Integer -Mask $Length -ErrorAction Stop
            $r | Should -BeOfType 'System.UInt32'
            $r | Should -Be $Int
        }

        It 'Convert-IPv4Mask -Binary -Mask <Length> == <Bin>' -TestCases $testCases1 {
            param ($Length, $Bin)
            $r = Convert-IPv4Mask -Binary -Mask $Length -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Bin
        }

        It 'Convert-IPv4Mask -Mask /<Length> == <Mask>' -TestCases $testCases1 {
            param ($Length, $Mask)
            $r = Convert-IPv4Mask -Mask "/$Length" -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Mask
        }

        It 'Convert-IPv4Mask -QuadDot -Mask /<Length> == <Mask>' -TestCases $testCases1 {
            param ($Length, $Mask)
            $r = Convert-IPv4Mask -QuadDot -Mask "/$Length" -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Mask
        }

        It 'Convert-IPv4Mask -Length -Mask /<Length> == <Length>' -TestCases $testCases1 {
            param ($Length)
            $r = Convert-IPv4Mask -Length -Mask "/$Length" -ErrorAction Stop
            $r | Should -BeOfType 'System.Byte'
            $r | Should -Be $Length
        }

        It 'Convert-IPv4Mask -LengthWithSlash -Mask /<Length> == /<Length>' -TestCases $testCases1 {
            param ($Length)
            $r = Convert-IPv4Mask -LengthWithSlash -Mask "/$Length" -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be "/$Length"
        }

        It 'Convert-IPv4Mask -Integer -Mask /<Length> == <Int>' -TestCases $testCases1 {
            param ($Length, $Int)
            $r = Convert-IPv4Mask -Integer -Mask "/$Length" -ErrorAction Stop
            $r | Should -BeOfType 'System.UInt32'
            $r | Should -Be $Int
        }

        It 'Convert-IPv4Mask -Binary -Mask /<Length> == <Bin>' -TestCases $testCases1 {
            param ($Length, $Bin)
            $r = Convert-IPv4Mask -Binary -Mask "/$Length" -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Bin
        }

        It 'Convert-IPv4Mask -Mask <Int> == <Mask>' -TestCases $testCases1 {
            param ($Int, $Mask)
            $r = Convert-IPv4Mask -Mask $Int -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Mask
        }

        It 'Convert-IPv4Mask -QuadDot -Mask <Int> == <Mask>' -TestCases $testCases1 {
            param ($Int, $Mask)
            $r = Convert-IPv4Mask -QuadDot -Mask $Int -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Mask
        }

        It 'Convert-IPv4Mask -Length -Mask <Int> == <Length>' -TestCases $testCases1 {
            param ($Int, $Length)
            $r = Convert-IPv4Mask -Length -Mask $Int -ErrorAction Stop
            $r | Should -BeOfType 'System.Byte'
            $r | Should -Be $Length
        }

        It 'Convert-IPv4Mask -LengthWithSlash -Mask <Int> == /<Length>' -TestCases $testCases1 {
            param ($Int, $Length)
            $r = Convert-IPv4Mask -LengthWithSlash -Mask $Int -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be "/$Length"
        }

        It 'Convert-IPv4Mask -Integer -Mask <Int> == <Int>' -TestCases $testCases1 {
            param ($Int)
            $r = Convert-IPv4Mask -Integer -Mask $Int -ErrorAction Stop
            $r | Should -BeOfType 'System.UInt32'
            $r | Should -Be $Int
        }

        It 'Convert-IPv4Mask -Binary -Mask <Int> == <Bin>' -TestCases $testCases1 {
            param ($Int, $Bin)
            $r = Convert-IPv4Mask -Binary -Mask $Int -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Bin
        }

        It 'Convert-IPv4Mask -Mask <Bin> == <Mask>' -TestCases $testCases1 {
            param ($Bin, $Length)
            $r = Convert-IPv4Mask -Mask $Bin -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Mask
        }

        It 'Convert-IPv4Mask -QuadDot -Mask <Bin> == <Mask>' -TestCases $testCases1 {
            param ($Bin, $Mask)
            $r = Convert-IPv4Mask -QuadDot -Mask $Bin -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Mask
        }

        It 'Convert-IPv4Mask -Length -Mask <Bin> == <Length>' -TestCases $testCases1 {
            param ($Bin, $Length)
            $r = Convert-IPv4Mask -Length -Mask $Bin -ErrorAction Stop
            $r | Should -BeOfType 'System.Byte'
            $r | Should -Be $Length
        }

        It 'Convert-IPv4Mask -LengthWithSlash -Mask <Bin> == /<Length>' -TestCases $testCases1 {
            param ($Bin, $Length)
            $r = Convert-IPv4Mask -LengthWithSlash -Mask $Bin -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be "/$Length"
        }

        It 'Convert-IPv4Mask -Integer -Mask <Bin> == <Int>' -TestCases $testCases1 {
            param ($Bin, $Int)
            $r = Convert-IPv4Mask -Integer -Mask $Bin -ErrorAction Stop
            $r | Should -BeOfType 'System.UInt32'
            $r | Should -Be $Int
        }

        It 'Convert-IPv4Mask -Binary -Mask <Bin> == <Bin>' -TestCases $testCases1 {
            param ($Bin)
            $r = Convert-IPv4Mask -Binary -Mask $Bin -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Bin
        }
    }

    Context TestCasesBackAndForth1 {
        $testCasesBackAndForth1 = (0..32).ForEach({@{Mask = $_}})

        It '<Mask> | Convert-IPv4Mask | Convert-IPv4Mask -Length == <Result>' -TestCases $testCasesBackAndForth1 {
            param ($Mask)
            $r = $Mask | Convert-IPv4Mask -ErrorAction Stop | Convert-IPv4Mask -Length -ErrorAction Stop
            $r | Should -BeOfType 'System.Byte'
            $r | Should -Be $Mask
        }

        It '<Mask> | Convert-IPv4Mask -QuadDot | Convert-IPv4Mask -Length == <Result>' -TestCases $testCasesBackAndForth1 {
            param ($Mask)
            $r = $Mask | Convert-IPv4Mask -QuadDot -ErrorAction Stop | Convert-IPv4Mask -Length -ErrorAction Stop
            $r | Should -BeOfType 'System.Byte'
            $r | Should -Be $Mask
        }

        It '<Mask> | Convert-IPv4Mask -Length | Convert-IPv4Mask -Length == <Result>' -TestCases $testCasesBackAndForth1 {
            param ($Mask)
            $r = $Mask | Convert-IPv4Mask -Length -ErrorAction Stop | Convert-IPv4Mask -Length -ErrorAction Stop
            $r | Should -BeOfType 'System.Byte'
            $r | Should -Be $Mask
        }

        It '<Mask> | Convert-IPv4Mask -LengthWithSlash | Convert-IPv4Mask -Length == <Result>' -TestCases $testCasesBackAndForth1 {
            param ($Mask)
            $r = $Mask | Convert-IPv4Mask -LengthWithSlash -ErrorAction Stop | Convert-IPv4Mask -Length -ErrorAction Stop
            $r | Should -BeOfType 'System.Byte'
            $r | Should -Be $Mask
        }

        It '<Mask> | Convert-IPv4Mask -Integer | Convert-IPv4Mask -Length == <Result>' -TestCases $testCasesBackAndForth1 {
            param ($Mask)
            $r = $Mask | Convert-IPv4Mask -Integer -ErrorAction Stop | Convert-IPv4Mask -Length -ErrorAction Stop
            $r | Should -BeOfType 'System.Byte'
            $r | Should -Be $Mask
        }

        It '<Mask> | Convert-IPv4Mask -Binary | Convert-IPv4Mask -Length == <Result>' -TestCases $testCasesBackAndForth1 {
            param ($Mask)
            $r = $Mask | Convert-IPv4Mask -Binary -ErrorAction Stop | Convert-IPv4Mask -Length -ErrorAction Stop
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

        It 'Convert-IPv4Mask -Mask <Mask>  (throw)' -TestCases $testCasesThrow1 {
            param ($Mask, $Throw)
            {Convert-IPv4Mask -Mask $Mask -ErrorAction Stop} | Should -Throw $Throw
        }
    }
}
