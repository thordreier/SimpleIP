# Invoke-Pester -Path .\Pester\1_FunctionExport.Tests.ps1 -Output Detailed
Describe 'FunctionExport' {

    Context 'Test if Pester files exist for all exported functions' {
        $functionExportDir = Join-Path -Path (Get-Location) -ChildPath 'FunctionExport'
        $testsDir = Join-Path -Path (Get-Location) -ChildPath 'Pester'
        $testCases1 = Get-Item -Path (Join-Path $functionExportDir -ChildPath *.ps1) | ForEach-Object -Process {
            $t = "$($_.BaseName).Tests.ps1"
            @{
                Function     = $_.BaseName
                FunctionFile = $_.Name
                FunctionPath = $_.FullName
                TestsFile    = $t
                TestsPath    = Join-Path -Path $testsDir -ChildPath $t
            }
        }

        It 'Tests for <Function> exists (<TestsFile>)' -TestCases $testCases1 {
            param ($TestFile, $TestsPath)
            Test-Path -Path $TestsPath -PathType Leaf | Should -Be $true -Because "Pester tests file $TestsFile should be created"
        }
    }
}
