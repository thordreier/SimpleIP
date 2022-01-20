# Invoke-Pester -Path .\Pester\Convert-IPv4Address.Tests.ps1 -Output Detailed
Describe 'Convert-IPv4Address' {

    It 'Positional argmuent' {
        $r = Convert-IPv4Address 16909060 -ErrorAction Stop
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

        It 'Convert-IPv4Address -Ip <Ip> == <Ip>' -TestCases $testCases1 {
            param ($Ip)
            $r = Convert-IPv4Address -Ip $Ip -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Ip
        }

        It 'Convert-IPv4Address -Integer -Ip <Ip> == <Int>' -TestCases $testCases1 {
            param ($Ip, $Int)
            $r = Convert-IPv4Address -Integer -Ip $Ip -ErrorAction Stop
            $r | Should -BeOfType 'System.UInt32'
            $r | Should -Be $Int
        }

        It 'Convert-IPv4Address -Binary -Ip <Ip> == <Bin>' -TestCases $testCases1 {
            param ($Ip, $Bin)
            $r = Convert-IPv4Address -Binary -Ip $Ip -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Bin
        }

        It 'Convert-IPv4Address -Ip <Int> == <Ip>' -TestCases $testCases1 {
            param ($Int, $Ip)
            $r = Convert-IPv4Address -Ip $Int -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Ip
        }

        It 'Convert-IPv4Address -Integer -Ip <Int> == <Int>' -TestCases $testCases1 {
            param ($Int)
            $r = Convert-IPv4Address -Integer -Ip $Int -ErrorAction Stop
            $r | Should -BeOfType 'System.UInt32'
            $r | Should -Be $Int
        }

        It 'Convert-IPv4Address -Binary -Ip <Int> == <Bin>' -TestCases $testCases1 {
            param ($Int, $Bin)
            $r = Convert-IPv4Address -Binary -Ip $Int -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Bin
        }

        It 'Convert-IPv4Address -Ip <Bin> == <Ip>' -TestCases $testCases1 {
            param ($Bin, $Ip)
            $r = Convert-IPv4Address -Ip $Bin -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Ip
        }

        It 'Convert-IPv4Address -Integer -Ip <Bin> == <Int>' -TestCases $testCases1 {
            param ($Bin, $Int)
            $r = Convert-IPv4Address -Integer -Ip $Bin -ErrorAction Stop
            $r | Should -BeOfType 'System.UInt32'
            $r | Should -Be $Int
        }

        It 'Convert-IPv4Address -Binary -Ip <Bin> == <Bin>' -TestCases $testCases1 {
            param ($Bin)
            $r = Convert-IPv4Address -Binary -Ip $Bin -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Bin
        }
    }

    Context TestCasesSubnets1 {
        $testCasesSubnets1 = @(
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

        It 'Convert-IPv4Address -Ip <Mask> == <Mask>' -TestCases $testCasesSubnets1 {
            param ($Mask)
            $r = Convert-IPv4Address -Ip $Mask -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Mask
        }

        It 'Convert-IPv4Address -Integer -Ip <Mask> == <Int>' -TestCases $testCasesSubnets1 {
            param ($Mask, $Int)
            $r = Convert-IPv4Address -Integer -Ip $Mask -ErrorAction Stop
            $r | Should -BeOfType 'System.UInt32'
            $r | Should -Be $Int
        }

        It 'Convert-IPv4Address -Binary -Ip <Mask> == <Bin>' -TestCases $testCasesSubnets1 {
            param ($Mask, $Bin)
            $r = Convert-IPv4Address -Binary -Ip $Mask -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Bin
        }

        It 'Convert-IPv4Address -Ip <Int> == <Mask>' -TestCases $testCasesSubnets1 {
            param ($Int, $Mask)
            $r = Convert-IPv4Address -Ip $Int -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Mask
        }

        It 'Convert-IPv4Address -Integer -Ip <Int> == <Int>' -TestCases $testCasesSubnets1 {
            param ($Int)
            $r = Convert-IPv4Address -Integer -Ip $Int -ErrorAction Stop
            $r | Should -BeOfType 'System.UInt32'
            #$r | Should -Be $Int
        }

        It 'Convert-IPv4Address -Binary -Ip <Int> == <Bin>' -TestCases $testCasesSubnets1 {
            param ($Int, $Bin)
            $r = Convert-IPv4Address -Binary -Ip $Int -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Bin
        }

        It 'Convert-IPv4Address -Ip <Bin> == <Mask>' -TestCases $testCasesSubnets1 {
            param ($Bin, $Mask)
            $r = Convert-IPv4Address -Ip $Bin -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Mask
        }

        It 'Convert-IPv4Address -Integer -Ip <Bin> == <Int>' -TestCases $testCasesSubnets1 {
            param ($Bin, $Int)
            $r = Convert-IPv4Address -Integer -Ip $Bin -ErrorAction Stop
            $r | Should -BeOfType 'System.UInt32'
            $r | Should -Be $Int
        }

        It 'Convert-IPv4Address -Binary -Ip <Bin> == <Bin>' -TestCases $testCasesSubnets1 {
            param ($Bin)
            $r = Convert-IPv4Address -Binary -Ip $Bin -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Bin
        }
    }

    Context TestCasesRandomIp1 {
        $testCasesRandomIp1 = (0..20).ForEach({@{Ip = (0..3).ForEach({Get-Random -Minimum 0 -Maximum 255}) -join '.'}})

        It '<Ip> | Convert-IPv4ToInt | Convert-IntToIPv4 == <Ip>' -TestCases $testCasesRandomIp1 {
            param ($Ip)
            $r = $Ip | Convert-IPv4Address -ErrorAction Stop | Convert-IPv4Address -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Ip
        }

        It '<Ip> | Convert-IPv4ToInt -Integer | Convert-IntToIPv4 == <Ip>' -TestCases $testCasesRandomIp1 {
            param ($Ip)
            $r = $Ip | Convert-IPv4Address -Integer -ErrorAction Stop | Convert-IPv4Address -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Ip
        }

        It '<Ip> | Convert-IPv4ToInt -Binary | Convert-IntToIPv4 == <Ip>' -TestCases $testCasesRandomIp1 {
            param ($Ip)
            $r = $Ip | Convert-IPv4Address -Binary -ErrorAction Stop | Convert-IPv4Address -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Ip
        }
    }

    Context TestCasesRandomInteger1 {
        $testCasesRandomInteger1 = (0..20).ForEach({@{Int = Get-Random}})

        It '<Int> | Convert-IPv4Address | Convert-IPv4Address -Integer == <Int>' -TestCases $testCasesRandomInteger1 {
            param ($Int)
            $r = $Int | Convert-IPv4Address -ErrorAction Stop | Convert-IPv4Address -Integer -ErrorAction Stop
            $r | Should -BeOfType 'System.Uint32'
            $r | Should -Be $Int
        }

        It '<Int> | Convert-IPv4Address -Integer | Convert-IPv4Address -Integer == <Int>' -TestCases $testCasesRandomInteger1 {
            param ($Int)
            $r = $Int | Convert-IPv4Address -Integer -ErrorAction Stop | Convert-IPv4Address -Integer -ErrorAction Stop
            $r | Should -BeOfType 'System.Uint32'
            $r | Should -Be $Int
        }

        It '<Int> | Convert-IPv4Address -Binary | Convert-IPv4Address -Integer == <Int>' -TestCases $testCasesRandomInteger1 {
            param ($Int)
            $r = $Int | Convert-IPv4Address -Binary -ErrorAction Stop | Convert-IPv4Address -Integer -ErrorAction Stop
            $r | Should -BeOfType 'System.Uint32'
            $r | Should -Be $Int
        }
    }

    Context TestCasesRandomBinary1 {
        $testCasesRandomBinary1 = (0..20).ForEach({@{Bin = (0..31).ForEach({Get-Random -Maximum 2}) -join ''}})

        It '<Bin> | Convert-IPv4Address | Convert-IPv4Address -Binary == <Bin>' -TestCases $testCasesRandomBinary1 {
            param ($Bin)
            $r = $Bin | Convert-IPv4Address -ErrorAction Stop | Convert-IPv4Address -Binary -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Bin
        }

        It '<Bin> | Convert-IPv4Address -Integer | Convert-IPv4Address -Binary == <Bin>' -TestCases $testCasesRandomBinary1 {
            param ($Bin)
            $r = $Bin | Convert-IPv4Address -Integer -ErrorAction Stop | Convert-IPv4Address -Binary -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Bin
        }

        It '<Bin> | Convert-IPv4Address -Binary | Convert-IPv4Address -Binary == <Bin>' -TestCases $testCasesRandomBinary1 {
            param ($Bin)
            $r = $Bin | Convert-IPv4Address -Binary -ErrorAction Stop | Convert-IPv4Address -Binary -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Bin
        }
    }

    Context TestCasesThrow1 {
        $testCasesThrow1 = @(
            @{Ip = -1                                  ; Throw = '*is not a valid IPv4 address*'}
            @{Ip = '253.254.255.256'                   ; Throw = '*is not a valid IPv4 address*'}
            @{Ip = 'abc'                               ; Throw = '*is not a valid IPv4 address*'}
            @{Ip = '1111111111111111111111111111111'   ; Throw = '*is not a valid IPv4 address*'}
            @{Ip = '1111111111111111 1111111111111111' ; Throw = '*is not a valid IPv4 address*'}  # FIXXXME? Show we allow spaces in binary address?
            @{Ip = '111111111111111111111111111111111' ; Throw = '*is not a valid IPv4 address*'}

        )

        It 'Convert-IPv4Address -Ip <Ip>  (throw)' -TestCases $testCasesThrow1 {
            param ($Ip, $Throw)
            {Convert-IPv4Address -Ip $Ip -ErrorAction Stop} | Should -Throw $Throw
        }
    }
}
