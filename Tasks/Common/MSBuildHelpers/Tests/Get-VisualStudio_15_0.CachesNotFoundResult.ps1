[CmdletBinding()]
param()

# Arrange.
. $PSScriptRoot\..\..\..\..\Tests\lib\Initialize-Test.ps1
Microsoft.PowerShell.Core\Import-Module $PSScriptRoot\..
$script:vsCount = 0
$script:buildToolsCount = 0
Register-Mock Invoke-VstsTool {
        $script:vsCount++
        "["
        "]"
    } -- -FileName (Resolve-Path $PSScriptRoot\..\vswhere.exe).Path -Arguments "-version [15.0,15.1) -latest -format json" -RequireExitCodeZero
Register-Mock Invoke-VstsTool {
        $script:buildToolsCount++
        "["
        "]"
    } -- -FileName (Resolve-Path $PSScriptRoot\..\vswhere.exe).Path -Arguments "-version [15.0,16.0) -products Microsoft.VisualStudio.Product.BuildTools -latest -format json" -RequireExitCodeZero

# Act.
$null = Get-VisualStudio_15_0
$actual = Get-VisualStudio_15_0

# Assert.
Assert-AreEqual -Expected $null -Actual $actual
Assert-AreEqual -Expected 1 -Actual $script:vsCount
Assert-AreEqual -Expected 1 -Actual $script:buildToolsCount
