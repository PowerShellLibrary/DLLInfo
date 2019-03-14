Clear-Host
if (-not $PSScriptRoot) {
    $PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent
}
Import-Module -Name Pester -Force
Import-Module .\DLLInfo\DLLInfo.psm1 -Force

Describe 'Get-BuildConfiguration' {
    Context "Check test DLLs - x64" {
        It "Given valid -Assembly '<Assembly>', it returns '<Expected>'" -TestCases @(
            @{ Assembly = "$PSScriptRoot\bin\Debug\AssemblyInfoTest.dll"; Expected = 'Debug' }
            @{ Assembly = "$PSScriptRoot\bin\Release\AssemblyInfoTest.dll"; Expected = 'Release' }
            @{ Assembly = "$PSScriptRoot\bin\x64\Debug\AssemblyInfoTest.dll"; Expected = 'Debug' }
            @{ Assembly = "$PSScriptRoot\bin\x64\Release\AssemblyInfoTest.dll"; Expected = 'Release' }
        ) {
            param ($Assembly, $Expected)
            Get-BuildConfiguration $Assembly | Should -Be $Expected
        }
    }

    Context "Check test DLLs - x86" {
        It "Given valid -Assembly '<Assembly>', it returns '<Expected>'" -TestCases @(
            @{ Assembly = "$PSScriptRoot\bin\x86\Debug\AssemblyInfoTest.dll"; Expected = 'Debug' }
            @{ Assembly = "$PSScriptRoot\bin\x86\Release\AssemblyInfoTest.dll"; Expected = 'Release' }
        ) {
            param ($Assembly, $Expected)
            $RunAs32Bit = {
                param($Assembly)
                Import-Module .\DLLInfo\DLLInfo.psm1 -Force
                Get-BuildConfiguration $Assembly
            }

            $Job = Start-Job $RunAs32Bit -RunAs32 -Arg $Assembly
            $Job | Wait-Job | Receive-Job | Should -Be $Expected
        }
    }
}

Describe 'Test-JitOptimized' {
    Context "Check test DLLs - x64" {
        It "Given valid -Assembly '<Assembly>', it returns <Expected>" -TestCases @(
            @{ Assembly = "$PSScriptRoot\bin\Debug\AssemblyInfoTest.dll"; Expected = $false }
            @{ Assembly = "$PSScriptRoot\bin\Release\AssemblyInfoTest.dll"; Expected = $true }
            @{ Assembly = "$PSScriptRoot\bin\x64\Debug\AssemblyInfoTest.dll"; Expected = $false }
            @{ Assembly = "$PSScriptRoot\bin\x64\Release\AssemblyInfoTest.dll"; Expected = $true }
        ) {
            param ($Assembly, $Expected)
            Test-JitOptimized $Assembly | Should -Be $Expected
        }
    }

    Context "Check test DLLs - x86" {
        It "Given valid -Assembly '<Assembly>', it returns <Expected>" -TestCases @(
            @{ Assembly = "$PSScriptRoot\bin\x86\Debug\AssemblyInfoTest.dll"; Expected = $false }
            @{ Assembly = "$PSScriptRoot\bin\x86\Release\AssemblyInfoTest.dll"; Expected = $true }
        ) {
            param ($Assembly, $Expected)
            $RunAs32Bit = {
                param($Assembly)
                Import-Module .\DLLInfo\DLLInfo.psm1 -Force
                Test-JitOptimized $Assembly
            }

            $Job = Start-Job $RunAs32Bit -RunAs32 -Arg $Assembly
            $Job | Wait-Job | Receive-Job | Should -Be $Expected
        }
    }
}

Describe 'Get-TargetCPU' {
    Context "Check test DLLs - x64" {
        It "Given valid -Assembly '<Assembly>', it returns <Expected>" -TestCases @(
            @{ Assembly = "$PSScriptRoot\bin\Debug\AssemblyInfoTest.dll"; Expected = 'AnyCPU' }
            @{ Assembly = "$PSScriptRoot\bin\Release\AssemblyInfoTest.dll"; Expected = 'AnyCPU' }
            @{ Assembly = "$PSScriptRoot\bin\x64\Debug\AssemblyInfoTest.dll"; Expected = 'AMD64' }
            @{ Assembly = "$PSScriptRoot\bin\x64\Release\AssemblyInfoTest.dll"; Expected = 'AMD64' }
        ) {
            param ($Assembly, $Expected)
            Get-TargetCPU $Assembly | Should -Be $Expected
        }
    }

    Context "Check test DLLs - x86" {
        It "Given valid -Assembly '<Assembly>', it returns <Expected>" -TestCases @(
            @{ Assembly = "$PSScriptRoot\bin\x86\Debug\AssemblyInfoTest.dll"; Expected = 'Intel32' }
            @{ Assembly = "$PSScriptRoot\bin\x86\Release\AssemblyInfoTest.dll"; Expected = 'Intel32' }
        ) {
            param ($Assembly, $Expected)
            $RunAs32Bit = {
                param($Assembly)
                Import-Module .\DLLInfo\DLLInfo.psm1 -Force
                Get-TargetCPU $Assembly
            }

            $Job = Start-Job $RunAs32Bit -RunAs32 -Arg $Assembly
            $Job | Wait-Job | Receive-Job | Should -Be $Expected
        }
    }
}