# Invoke-Pester -Path .\Pester\Convert-BitsToSubnetMask.Tests.ps1 -Output Detailed
Describe 'Convert-BitsToSubnetMask' {

    It 'Positional argmuent' {
        $r = Convert-BitsToSubnetMask 16 -ErrorAction Stop
        $r | Should -BeOfType 'System.String'
        $r | Should -Be '255.255.0.0'
    }

    Context TestCases1 {
        $testCases1 = @(
            @{Mask = 32 ; Result = '255.255.255.255'}
            @{Mask = 31 ; Result = '255.255.255.254'}
            @{Mask = 30 ; Result = '255.255.255.252'}
            @{Mask = 29 ; Result = '255.255.255.248'}
            @{Mask = 28 ; Result = '255.255.255.240'}
            @{Mask = 27 ; Result = '255.255.255.224'}
            @{Mask = 26 ; Result = '255.255.255.192'}
            @{Mask = 25 ; Result = '255.255.255.128'}
            @{Mask = 24 ; Result = '255.255.255.0'  }
            @{Mask = 23 ; Result = '255.255.254.0'  }
            @{Mask = 22 ; Result = '255.255.252.0'  }
            @{Mask = 21 ; Result = '255.255.248.0'  }
            @{Mask = 20 ; Result = '255.255.240.0'  }
            @{Mask = 19 ; Result = '255.255.224.0'  }
            @{Mask = 18 ; Result = '255.255.192.0'  }
            @{Mask = 17 ; Result = '255.255.128.0'  }
            @{Mask = 16 ; Result = '255.255.0.0'    }
            @{Mask = 15 ; Result = '255.254.0.0'    }
            @{Mask = 14 ; Result = '255.252.0.0'    }
            @{Mask = 13 ; Result = '255.248.0.0'    }
            @{Mask = 12 ; Result = '255.240.0.0'    }
            @{Mask = 11 ; Result = '255.224.0.0'    }
            @{Mask = 10 ; Result = '255.192.0.0'    }
            @{Mask =  9 ; Result = '255.128.0.0'    }
            @{Mask =  8 ; Result = '255.0.0.0'      }
            @{Mask =  7 ; Result = '254.0.0.0'      }
            @{Mask =  6 ; Result = '252.0.0.0'      }
            @{Mask =  5 ; Result = '248.0.0.0'      }
            @{Mask =  4 ; Result = '240.0.0.0'      }
            @{Mask =  3 ; Result = '224.0.0.0'      }
            @{Mask =  2 ; Result = '192.0.0.0'      }
            @{Mask =  1 ; Result = '128.0.0.0'      }
            @{Mask =  0 ; Result = '0.0.0.0'        }
        )

        It 'Convert-BitsToSubnetMask -Mask <Mask> == <Result>' -TestCases $testCases1 {
            param ($Mask, $Result)
            $r = Convert-BitsToSubnetMask -Mask $Mask -ErrorAction Stop
            $r | Should -BeOfType 'System.String'
            $r | Should -Be $Result
        }
    }

    Context TestCasesBackAndForth1 {
        $testCasesBackAndForth1 = (0..32).ForEach({@{Mask = $_ ; Result = $_}})

        It '<Mask> | Convert-BitsToSubnetMask | Convert-SubnetMaskToBits == <Result>' -TestCases $testCasesBackAndForth1 {
            param ($Mask, $Result)
            $r = $Mask | Convert-BitsToSubnetMask | Convert-SubnetMaskToBits
            $r | Should -BeOfType 'System.Byte'
            $r | Should -Be $Result
        }
    }

    Context TestCasesThrow1 {
        $testCasesThrow1 = @(
            @{Mask = -1    ; Throw = '*argument is less than the minimum allowed range of 0*'}
            @{Mask = 33    ; Throw = '*argument is greater than the maximum allowed range of 32*'}
            @{Mask = 'abc' ; Throw = 'Cannot process argument transformation on parameter*'}
        )

        It 'Convert-BitsToSubnetMask -Mask <Mask>  (throw)' -TestCases $testCasesThrow1 {
            param ($Mask, $Throw)
            {Convert-BitsToSubnetMask -Mask $Mask -ErrorAction Stop} | Should -Throw $Throw
        }
    }
}
