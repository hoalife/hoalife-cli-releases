# Offline Windows fixtures. Run with Windows PowerShell 5.1 or pwsh on Windows.
$ErrorActionPreference = 'Stop'
if ([Environment]::OSVersion.Platform -ne [PlatformID]::Win32NT) {
    throw 'Windows is required for these native installer fixtures'
}
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem
$installer = Join-Path (Split-Path $PSScriptRoot -Parent) 'install.ps1'
$root = Join-Path ([IO.Path]::GetTempPath()) ('hoalife fixtures ' + [guid]::NewGuid().ToString('N'))
$fixtures = Join-Path $root 'fixtures'
$originalTemp = $env:TEMP
$originalTmp = $env:TMP
$env:TMP = Join-Path $root 'temporary files'
# GetTempPath uses TMP on Windows; restore both environment variables at the end.
$env:TEMP = $env:TMP
$dest = Join-Path $root 'bin with spaces'
$requests = [Collections.Generic.List[string]]::new()
$fixtureState = [pscustomobject]@{ Mode = 'normal'; Requests = $requests; Fixtures = $fixtures }
$version = 'v0.2.3'
$pathKey = [Microsoft.Win32.Registry]::CurrentUser.CreateSubKey('Environment')
$hadUserPath = $pathKey.GetValueNames() -contains 'Path'
$oldUserPath = $pathKey.GetValue('Path', '', [Microsoft.Win32.RegistryValueOptions]::DoNotExpandEnvironmentNames)
$oldPathKind = if ($hadUserPath) { $pathKey.GetValueKind('Path') } else { [Microsoft.Win32.RegistryValueKind]::ExpandString }
$oldPathTest = $env:HOALIFE_INSTALL_PATH_TEST
$oldProcessPath = $env:Path
$oldLocalAppData = $env:LOCALAPPDATA
$oldTls = [Net.ServicePointManager]::SecurityProtocol
$checks = 0

function Assert($Condition, [string]$Message) {
    if (-not $Condition) { throw "Assertion failed: $Message" }
    $script:checks++
}

# Override only the network boundary, leaving ZIP, hashing, filesystem, PATH,
# architecture detection and replacement code real. No production test switches.
$httpFixture = {
    [CmdletBinding()]
    param($Uri, $OutFile, [switch]$UseBasicParsing, [switch]$PassThru, $MaximumRedirection)
    if ($MaximumRedirection -ne 0) { throw 'Redirects must be checked explicitly' }
    if (-not $Uri.StartsWith('https://')) { throw 'Only HTTPS requests are allowed' }
    $fixtureState.Requests.Add($Uri)
    if ($fixtureState.Mode -eq 'redirect-http') {
        return [pscustomobject]@{ StatusCode = 302; Headers = @{ Location = 'http://example.invalid/archive' } }
    }
    if ($fixtureState.Mode -eq 'redirect-loop') {
        return [pscustomobject]@{ StatusCode = 302; Headers = @{ Location = $Uri } }
    }
    if ($fixtureState.Mode -in @('redirect-https', 'redirect-classic-https') -and $Uri.Contains('github.com/')) {
        $location = 'https://fixtures.invalid/' + $Uri.Split('/')[-1]
        $headers = @{ Location = $location }
        if ($fixtureState.Mode -eq 'redirect-classic-https') {
            $headers = [Net.WebHeaderCollection]::new()
            $headers.Add('Location', $location)
            Write-Error 'Simulated Windows PowerShell nonterminating redirect-limit error' -ErrorId MaximumRedirectExceeded
        }
        return [pscustomobject]@{ StatusCode = 302; Headers = $headers }
    }
    $name = $Uri.Split('/')[-1]
    $source = Join-Path $fixtureState.Fixtures $name
    if (-not [IO.File]::Exists($source)) { return [pscustomobject]@{ StatusCode = 404; Headers = @{} } }
    [IO.File]::Copy($source, $OutFile, $true)
    if ($fixtureState.Mode -eq 'success-with-error') { Write-Error 'Simulated failed download reporting HTTP 200' }
    return [pscustomobject]@{ StatusCode = 200; Headers = @{} }
}
# Bind mutable fixture state to the mock's module scope. The installer is a
# separate script, so dynamic $script: variables would refer to that child.
Set-Item -Path Function:Invoke-WebRequest -Value $httpFixture.GetNewClosure()

function New-Fixture([string]$Tag = $script:version, [string]$Architecture = 'amd64', [string]$BadName = '', [int]$Attributes = 0, [string]$Suffix = '', [switch]$Missing, [switch]$EmptyBinary) {
    $asset = "hoalife_${Tag}_windows_${Architecture}.zip"
    $path = Join-Path $script:fixtures $asset
    if (Test-Path -LiteralPath $path) { Remove-Item -LiteralPath $path }
    $zip = [IO.Compression.ZipFile]::Open($path, [IO.Compression.ZipArchiveMode]::Create)
    try {
        foreach ($name in @('hoalife.exe', 'LICENSE.txt', 'THIRD_PARTY_NOTICES.txt', 'README.txt')) {
            if ($Missing -and $name -eq 'README.txt') { continue }
            $entry = $zip.CreateEntry($name)
            if ($name -eq 'hoalife.exe' -and $Attributes -ne 0) { $entry.ExternalAttributes = $Attributes }
            $writer = [IO.StreamWriter]::new($entry.Open())
            try {
                if (-not ($EmptyBinary -and $name -eq 'hoalife.exe')) { $writer.Write("fixture $name $Suffix") }
            } finally { $writer.Dispose() }
        }
        if ($BadName) {
            $entry = $zip.CreateEntry($BadName)
            $entry.ExternalAttributes = $Attributes
            $writer = [IO.StreamWriter]::new($entry.Open())
            try { $writer.Write('unsafe') } finally { $writer.Dispose() }
        }
    } finally { $zip.Dispose() }
    $hash = (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash.ToLowerInvariant()
    [IO.File]::WriteAllText((Join-Path $script:fixtures 'SHA256SUMS'), "$hash  $asset`n" + ('a' * 64) + "  RELEASE_NOTES.md`n")
    return $path
}

function Invoke-Installer([hashtable]$Options = @{}, [switch]$Fail) {
    $params = @{ Version = $script:version; Arch = 'amd64'; InstallDir = $script:dest; NoPathUpdate = $true }
    foreach ($key in $Options.Keys) { $params[$key] = $Options[$key] }
    $failed = $false
    $script:lastError = $null
    try { & $script:installer @params | Out-Null } catch { $failed = $true; $script:lastError = $_ }
    $failureContext = if ($script:lastError) { "$script:lastError`n$($script:lastError.InvocationInfo.PositionMessage)`n$($script:lastError.ScriptStackTrace)" } else { '' }
    Assert ($failed -eq [bool]$Fail) "expected failure=$Fail; last error: $failureContext"
    $remainingTemporaryFiles = @(Get-ChildItem -LiteralPath $env:TMP -Force)
    $temporaryContext = if ($remainingTemporaryFiles.Count) { ($remainingTemporaryFiles | Select-Object Name, Length, Attributes | Out-String) + (Get-PSCallStack | Out-String) } else { '' }
    Assert ($remainingTemporaryFiles.Count -eq 0) "temporary files cleaned; remaining: $temporaryContext"
    Assert ((Get-Content -LiteralPath (Join-Path $script:root 'profile sentinel') -Raw) -eq 'saved profiles') 'profiles untouched'
}

function Assert-Prior {
    Assert ([IO.File]::ReadAllText((Join-Path $script:dest 'hoalife.exe')) -eq 'prior executable') 'prior executable preserved'
    Assert ([IO.File]::ReadAllText((Join-Path $script:dest 'unrelated')) -eq 'keep me') 'unrelated file preserved'
    $storage = Join-Path $script:dest '.hoalife'
    if (Test-Path -LiteralPath $storage) { Assert (@(Get-ChildItem -LiteralPath $storage -Force).Count -eq 0) 'failed generation cleaned' }
}

try {
    [IO.Directory]::CreateDirectory($fixtures) | Out-Null
    [IO.Directory]::CreateDirectory($env:TMP) | Out-Null
    [IO.Directory]::CreateDirectory($dest) | Out-Null
    [IO.File]::WriteAllText((Join-Path $root 'profile sentinel'), 'saved profiles')
    [IO.File]::WriteAllText((Join-Path $dest 'hoalife.exe'), 'prior executable')
    [IO.File]::WriteAllText((Join-Path $dest 'unrelated'), 'keep me')
    $path = New-Fixture
    $manifest = [IO.File]::ReadAllText((Join-Path $fixtures 'SHA256SUMS'))
    $asset = [IO.Path]::GetFileName($path)
    foreach ($badVersion in @('latest', 'v2.0.0', 'v0.01.0', 'v1.0.01', 'v1.2.3-rc1', "v1.2.3`n", 'v1.2.3/../x')) {
        Invoke-Installer @{ Version = $badVersion } -Fail
        Assert-Prior
    }
    Invoke-Installer @{ Arch = '386' } -Fail
    Invoke-Installer @{ Version = 'v1.99.99' } -Fail
    Invoke-Installer @{ InstallDir = "$dest;other" } -Fail
    Invoke-Installer @{ InstallDir = "Env:\HOALIFE_INSTALLER_TEST" } -Fail
    $badManifests = @(
        ''
        ($manifest + $manifest)
        $manifest.Replace($asset, 'missing.zip')
        $manifest.Replace('  ', ' ')
        $manifest.ToUpperInvariant()
        (('0' * 64) + "  $asset`n")
        ($manifest + 'malformed')
    )
    Assert ($badManifests.Count -eq 7) 'all seven malformed manifest fixtures are present'
    foreach ($badManifest in $badManifests) {
        Assert ($badManifest -cne $manifest) 'negative manifest fixture must differ from the valid manifest'
        [IO.File]::WriteAllText((Join-Path $fixtures 'SHA256SUMS'), $badManifest)
        Invoke-Installer -Fail
        Assert-Prior
    }
    [IO.File]::WriteAllText((Join-Path $fixtures 'SHA256SUMS'), $manifest)
    [IO.File]::AppendAllText($path, 'tamper')
    Invoke-Installer -Fail
    Assert-Prior
    foreach ($bad in @('../escape', '/absolute', 'nested/file', 'hoalife.exe', 'HOALIFE.EXE', 'other', 'README.txt:stream', 'trailing. ', 'dir/')) {
        $null = New-Fixture -BadName $bad
        Invoke-Installer -Fail
        Assert-Prior
    }
    # Unix symlink and DOS reparse-point metadata on otherwise named entries.
    foreach ($attributes in @([int]0xA1FF0000, 0x400, 0x10)) {
        $null = New-Fixture -Attributes $attributes
        Invoke-Installer -Fail
        Assert-Prior
    }
    $null = New-Fixture -Missing
    Invoke-Installer -Fail
    Assert-Prior
    $null = New-Fixture -EmptyBinary
    Invoke-Installer -Fail
    Assert-Prior
    $path = New-Fixture -EmptyBinary
    $bytes = [IO.File]::ReadAllBytes($path)
    [Array]::Copy([BitConverter]::GetBytes([uint32]1), 0, $bytes, 22, 4)
    for ($offset = 0; $offset -lt $bytes.Length - 4; $offset++) {
        if ([BitConverter]::ToUInt32($bytes, $offset) -eq 0x02014b50) {
            [Array]::Copy([BitConverter]::GetBytes([uint32]1), 0, $bytes, $offset + 24, 4)
            break
        }
    }
    [IO.File]::WriteAllBytes($path, $bytes)
    $hash = (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash.ToLowerInvariant()
    [IO.File]::WriteAllText((Join-Path $fixtures 'SHA256SUMS'), "$hash  $asset`n")
    Invoke-Installer -Fail
    Assert-Prior
    $path = New-Fixture
    [IO.File]::WriteAllText($path, 'invalid ZIP')
    $hash = (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash.ToLowerInvariant()
    [IO.File]::WriteAllText((Join-Path $fixtures 'SHA256SUMS'), "$hash  $asset`n")
    Invoke-Installer -Fail
    Assert-Prior
    $null = New-Fixture
    Remove-Item -LiteralPath (Join-Path $fixtures 'SHA256SUMS')
    Invoke-Installer -Fail
    Assert-Prior
    $null = New-Fixture
    $fixtureState.Mode = 'success-with-error'
    Invoke-Installer -Fail
    Assert-Prior
    $fixtureState.Mode = 'redirect-http'
    Invoke-Installer -Fail
    Assert-Prior
    $fixtureState.Mode = 'redirect-loop'
    Invoke-Installer -Fail
    Assert-Prior
    $fixtureState.Mode = 'normal'
    # A file blocks directory creation; no elevated rights are needed to test it.
    $blocker = Join-Path $root 'not a directory'
    [IO.File]::WriteAllText($blocker, 'blocker')
    Invoke-Installer @{ InstallDir = (Join-Path $blocker 'child') } -Fail
    Assert-Prior
    # Windows sharing denial proves atomic replacement preserves the prior file.
    $locked = [IO.File]::Open((Join-Path $dest 'hoalife.exe'), [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::Read)
    try { Invoke-Installer -Fail } finally { $locked.Dispose() }
    Assert-Prior
    foreach ($httpsMode in @('redirect-https', 'redirect-classic-https')) {
        $fixtureState.Mode = $httpsMode
        Invoke-Installer
    }
    $fixtureState.Mode = 'normal'
    Assert ([IO.File]::ReadAllText((Join-Path $dest 'hoalife.exe')) -eq 'fixture hoalife.exe ') 'installed binary placement'
    $generations = @(Get-ChildItem -LiteralPath (Join-Path $dest '.hoalife') -Directory -Force)
    Assert ($generations.Count -eq 1) 'one successful generation'
    foreach ($name in @('hoalife.exe', 'LICENSE.txt', 'THIRD_PARTY_NOTICES.txt', 'README.txt')) {
        Assert ([IO.File]::Exists((Join-Path $generations[0].FullName $name))) "retained $name"
    }
    Invoke-Installer
    Assert (@(Get-ChildItem -LiteralPath (Join-Path $dest '.hoalife') -Directory -Force).Count -eq 1) 'repeat install reuses generation'
    $null = New-Fixture -Tag 'v1.0.0' -Suffix 'upgrade'
    Invoke-Installer @{ Version = 'v1.0.0' }
    Assert ([IO.File]::ReadAllText((Join-Path $dest 'hoalife.exe')).EndsWith('upgrade')) 'upgrade replacement'
    Assert (@(Get-ChildItem -LiteralPath (Join-Path $dest '.hoalife') -Directory -Force).Count -eq 2) 'old notices preserved'
    foreach ($architecture in @('amd64', 'arm64')) {
        $null = New-Fixture -Architecture $architecture
        Invoke-Installer @{ Arch = $architecture }
        Assert ($requests[$requests.Count - 2].EndsWith("_windows_$architecture.zip")) "selected $architecture"
    }
    $parseTokens = $null; $parseErrors = $null
    $installerAst = [Management.Automation.Language.Parser]::ParseFile($installer, [ref]$parseTokens, [ref]$parseErrors)
    $selector = $installerAst.Find({ param($node) $node -is [Management.Automation.Language.FunctionDefinitionAst] -and $node.Name -eq 'Get-WindowsArchitecture' }, $true)
    Assert ($null -ne $selector) 'native architecture selector exists'
    & {
        . ([scriptblock]::Create($selector.Extent.Text))
        function Get-NativeWindowsMachine { return [uint16]0xaa64 }
        Assert ((Get-WindowsArchitecture) -ceq 'arm64') 'native ARM64 under an emulated x64 process/runtime'
        function Get-NativeWindowsMachine { return [uint16]0x8664 }
        Assert ((Get-WindowsArchitecture) -ceq 'amd64') 'native AMD64 selection'
        function Get-NativeWindowsMachine { return [uint16]0x014c }
        $unsupported = $false
        try { Get-WindowsArchitecture | Out-Null } catch { $unsupported = $true }
        Assert $unsupported 'unsupported native machine rejected'
    }
    # Probe the real native branch against an independent Windows CIM source.
    $nativeCode = Get-CimInstance -ClassName Win32_Processor | Select-Object -First 1 -ExpandProperty Architecture
    $native = switch ($nativeCode) { 9 { 'amd64' }; 12 { 'arm64' }; default { throw "Unsupported fixture runner architecture: $nativeCode" } }
    $null = New-Fixture -Architecture $native
    Invoke-Installer @{ Arch = '' }
    Assert ($requests[$requests.Count - 2].EndsWith("_windows_$native.zip")) 'native architecture selection'
    # PowerShell's current location can differ from the .NET process directory.
    # A relative destination must not replace an executable in that old directory.
    $shellDirectory = Join-Path $root 'PowerShell location'
    $processDirectory = Join-Path $root 'process location'
    [IO.Directory]::CreateDirectory($shellDirectory) | Out-Null
    [IO.Directory]::CreateDirectory((Join-Path $processDirectory 'relative bin')) | Out-Null
    $decoy = Join-Path $processDirectory 'relative bin\hoalife.exe'
    [IO.File]::WriteAllText($decoy, 'unrelated decoy executable')
    $originalLocation = Get-Location
    $originalProcessDirectory = [Environment]::CurrentDirectory
    try {
        [Environment]::CurrentDirectory = $processDirectory
        Set-Location -LiteralPath $shellDirectory
        Invoke-Installer @{ Arch = ''; InstallDir = 'relative bin' }
        Assert ([IO.File]::Exists((Join-Path $shellDirectory 'relative bin\hoalife.exe'))) 'relative destination follows PowerShell current location'
        Assert ([IO.File]::ReadAllText($decoy) -ceq 'unrelated decoy executable') 'relative destination preserves executable in process directory'
    } finally {
        Set-Location -LiteralPath $originalLocation.Path
        [Environment]::CurrentDirectory = $originalProcessDirectory
    }
    # Literal percent-variable directory names must not become expandable PATH
    # entries or change the invoking session's PATH on repeated installations.
    $literalDir = Join-Path $root 'literal %TEMP% directory'
    $beforeLiteralPath = $pathKey.GetValue('Path', '', [Microsoft.Win32.RegistryValueOptions]::DoNotExpandEnvironmentNames)
    $beforeLiteralProcessPath = $env:Path
    $beforeLiteralNames = $pathKey.GetValueNames() -join ';'
    Invoke-Installer @{ Arch = ''; InstallDir = $literalDir; NoPathUpdate = $false }
    Invoke-Installer @{ Arch = ''; InstallDir = $literalDir; NoPathUpdate = $false }
    Assert ([IO.File]::Exists((Join-Path $literalDir 'hoalife.exe'))) 'literal percent destination installs'
    Assert ($pathKey.GetValue('Path', '', [Microsoft.Win32.RegistryValueOptions]::DoNotExpandEnvironmentNames) -ceq $beforeLiteralPath) 'literal percent destination preserves user PATH'
    Assert (($pathKey.GetValueNames() -join ';') -ceq $beforeLiteralNames) 'literal percent destination creates no registry value'
    Assert ($env:Path -ceq $beforeLiteralProcessPath) 'literal percent destination preserves process PATH'
    # Preserve raw expandable entries and their registry type, even when a
    # session has overridden the variable. Use raw reads for the assertions too.
    $env:HOALIFE_INSTALL_PATH_TEST = 'C:\session override'
    $rawPath = 'C:\fixture existing;%HOALIFE_INSTALL_PATH_TEST%\bin'
    $pathKey.SetValue('Path', $rawPath, [Microsoft.Win32.RegistryValueKind]::ExpandString)
    Invoke-Installer @{ Arch = ''; NoPathUpdate = $false }
    $firstPath = [string]$pathKey.GetValue('Path', '', [Microsoft.Win32.RegistryValueOptions]::DoNotExpandEnvironmentNames)
    Assert ($firstPath -ceq "$dest;$rawPath") 'preserve raw original user PATH'
    Assert ($pathKey.GetValueKind('Path') -eq [Microsoft.Win32.RegistryValueKind]::ExpandString) 'preserve expandable value kind'
    Invoke-Installer @{ Arch = ''; NoPathUpdate = $false }
    Assert ($pathKey.GetValue('Path', '', [Microsoft.Win32.RegistryValueOptions]::DoNotExpandEnvironmentNames) -ceq $firstPath) 'PATH idempotence'
    $spelling = $dest.ToUpperInvariant() + '\'
    $pathKey.SetValue('Path', "$spelling;C:\fixture existing", [Microsoft.Win32.RegistryValueKind]::String)
    Invoke-Installer @{ Arch = ''; NoPathUpdate = $false }
    Assert ($pathKey.GetValue('Path', '', [Microsoft.Win32.RegistryValueOptions]::DoNotExpandEnvironmentNames) -ceq "$spelling;C:\fixture existing") 'case and separator equivalence'
    Assert ($pathKey.GetValueKind('Path') -eq [Microsoft.Win32.RegistryValueKind]::String) 'preserve plain string kind'
    $env:HOALIFE_INSTALL_PATH_TEST = $dest
    $pathKey.SetValue('Path', '%HOALIFE_INSTALL_PATH_TEST%;C:\fixture existing', [Microsoft.Win32.RegistryValueKind]::ExpandString)
    Invoke-Installer @{ Arch = ''; NoPathUpdate = $false }
    Assert ($pathKey.GetValue('Path', '', [Microsoft.Win32.RegistryValueOptions]::DoNotExpandEnvironmentNames) -ceq '%HOALIFE_INSTALL_PATH_TEST%;C:\fixture existing') 'expanded comparison without rewriting original'
    $env:LOCALAPPDATA = Join-Path $root 'local app data'
    & $installer -Version $version -Arch $native -NoPathUpdate | Out-Null
    Assert ([IO.File]::Exists((Join-Path $env:LOCALAPPDATA 'Programs\HOALife\bin\hoalife.exe'))) 'default destination'
    Write-Output "PASS: Windows offline installer fixtures ($checks assertions). Fixture bytes are not a published binary."
} finally {
    if ($hadUserPath) { $pathKey.SetValue('Path', $oldUserPath, $oldPathKind) }
    else { $pathKey.DeleteValue('Path', $false) }
    $pathKey.Dispose()
    if ('HOALifeInstaller.NativeMethods' -as [type]) {
        $broadcastResult = [UIntPtr]::Zero
        $null = [HOALifeInstaller.NativeMethods]::SendMessageTimeout([IntPtr]0xffff, 0x1a, [UIntPtr]::Zero, 'Environment', 2, 5000, [ref]$broadcastResult)
    }
    $env:HOALIFE_INSTALL_PATH_TEST = $oldPathTest
    $env:Path = $oldProcessPath
    $env:LOCALAPPDATA = $oldLocalAppData
    $env:TEMP = $originalTemp
    $env:TMP = $originalTmp
    [Net.ServicePointManager]::SecurityProtocol = $oldTls
    if ([IO.Directory]::Exists($root)) { Remove-Item -LiteralPath $root -Recurse -Force }
}
