# Windows PowerShell 5.1+ / PowerShell 7+. No elevation required.
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$Version,
    [string]$Arch,
    [string]$InstallDir = $(if ($env:LOCALAPPDATA) { Join-Path $env:LOCALAPPDATA 'Programs\HOALife\bin' }),
    [switch]$NoPathUpdate
)
$ErrorActionPreference = 'Stop'
$work = $null
$generation = $null
$committed = $false

function Get-PublicAsset([string]$Uri, [string]$OutFile) {
    # Handle redirects ourselves so HTTPS is required at every hop, including PS 5.1.
    for ($hop = 0; $hop -lt 8; $hop++) {
        if (([uri]$Uri).Scheme -cne 'https') { throw 'Refusing a non-HTTPS download/redirect' }
        $response = $null
        try {
            $response = Invoke-WebRequest -UseBasicParsing -Uri $Uri -OutFile $OutFile -PassThru -MaximumRedirection 0
        } catch {
            $response = $_.Exception.Response
            if ($null -eq $response) { throw }
        }
        $status = [int]$response.StatusCode
        if ($status -eq 200) { return }
        if ($status -notin @(301, 302, 303, 307, 308)) { throw "Download failed (HTTP $status): $Uri" }
        $location = [string]$response.Headers.Location
        if (-not $location) { throw 'Redirect has no Location header' }
        $Uri = ([uri]::new([uri]$Uri, $location)).AbsoluteUri
    }
    throw 'Too many download redirects'
}

function Test-SameFile([string]$First, [string]$Second) {
    if (-not [IO.File]::Exists($Second)) { return $false }
    return (Get-FileHash -LiteralPath $First -Algorithm SHA256).Hash -ceq (Get-FileHash -LiteralPath $Second -Algorithm SHA256).Hash
}

function Send-PathChangeNotification {
    if (-not ('HOALifeInstaller.NativeMethods' -as [type])) {
        Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
namespace HOALifeInstaller {
    public static class NativeMethods {
        [DllImport("user32.dll", CharSet = CharSet.Unicode, SetLastError = true)]
        public static extern IntPtr SendMessageTimeout(
            IntPtr window, uint message, UIntPtr parameter, string setting,
            uint flags, uint timeout, out UIntPtr result);
    }
}
'@
    }
    $result = [UIntPtr]::Zero
    $sent = [HOALifeInstaller.NativeMethods]::SendMessageTimeout([IntPtr]0xffff, 0x1a, [UIntPtr]::Zero, 'Environment', 2, 5000, [ref]$result)
    if ($sent -eq [IntPtr]::Zero) { Write-Warning 'User PATH was saved, but Windows could not notify other apps. Restart your terminal app or sign in again to load it.' }
}

function Add-UserPath([string]$Directory) {
    # A literal percent sign cannot be represented safely in an expandable PATH:
    # even currently undefined %variables% may acquire a value in later sessions.
    if ($Directory.Contains('%')) {
        Write-Warning "Installation succeeded; automatic PATH update skipped because the destination contains a literal percent sign. Run $Directory\hoalife.exe by its full path, or reinstall to a directory without percent signs."
        return
    }
    # Preserve raw %variables% and registry value kind. Environment.GetEnvironmentVariable
    # expands REG_EXPAND_SZ values, so it cannot be used to round-trip user PATH.
    $key = [Microsoft.Win32.Registry]::CurrentUser.CreateSubKey('Environment')
    $changed = $false
    try {
        $userPath = [string]$key.GetValue('Path', '', [Microsoft.Win32.RegistryValueOptions]::DoNotExpandEnvironmentNames)
        $kind = [Microsoft.Win32.RegistryValueKind]::ExpandString
        if ($key.GetValueNames() -contains 'Path') { $kind = $key.GetValueKind('Path') }
        if ($kind -notin @([Microsoft.Win32.RegistryValueKind]::String, [Microsoft.Win32.RegistryValueKind]::ExpandString)) { throw 'User PATH must be a string registry value' }
        $found = $false
        foreach ($entry in ($userPath -split ';')) {
            $normalized = [Environment]::ExpandEnvironmentVariables($entry.Trim().Trim('"')).TrimEnd('\', '/')
            if ($normalized -ieq $Directory.TrimEnd('\', '/')) { $found = $true }
        }
        if (-not $found) {
            $newPath = if ([string]::IsNullOrEmpty($userPath)) { $Directory } else { "$Directory;$userPath" }
            $key.SetValue('Path', $newPath, $kind)
            $changed = $true
        }
    } finally { $key.Dispose() }
    # Do not overwrite the process PATH with only the user portion.
    $processFound = $false
    foreach ($entry in ($env:Path -split ';')) {
        $normalized = [Environment]::ExpandEnvironmentVariables($entry.Trim().Trim('"')).TrimEnd('\', '/')
        if ($normalized -ieq $Directory.TrimEnd('\', '/')) { $processFound = $true }
    }
    if (-not $processFound) { $env:Path = "$Directory;$env:Path" }
    if ($changed) { Send-PathChangeNotification }
}

try {
    if ([Environment]::OSVersion.Platform -ne [PlatformID]::Win32NT) { throw 'This installer supports Windows only' }
    if ($Version -cnotmatch '\Av[01]\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\z') { throw 'Specify a stable version v0.MINOR.PATCH or v1.MINOR.PATCH (no leading zeroes)' }
    if (-not $Arch) {
        $nativeArch = $env:PROCESSOR_ARCHITECTURE
        if ($env:PROCESSOR_ARCHITEW6432) { $nativeArch = $env:PROCESSOR_ARCHITEW6432 }
        # .NET reports the native OS architecture even in an emulated process.
        if ('System.Runtime.InteropServices.RuntimeInformation' -as [type]) {
            $nativeArch = [System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture.ToString()
        }
        switch ($nativeArch.ToLowerInvariant()) {
            'amd64' { $Arch = 'amd64' }; 'x64' { $Arch = 'amd64' }; 'arm64' { $Arch = 'arm64' }
            default { throw "Unsupported Windows architecture: $nativeArch" }
        }
    }
    if ($Arch -cnotin @('amd64', 'arm64')) { throw "Unsupported architecture: $Arch" }
    if ([string]::IsNullOrWhiteSpace($InstallDir)) { throw 'InstallDir is required when LOCALAPPDATA is unavailable' }
    $InstallDir = [IO.Path]::GetFullPath($InstallDir)
    if ($InstallDir.Contains(';')) { throw 'InstallDir cannot contain a semicolon (PATH separator)' }
    $asset = "hoalife_${Version}_windows_${Arch}.zip"
    $base = "https://github.com/hoalife/hoalife-cli-releases/releases/download/$Version"
    $work = Join-Path ([IO.Path]::GetTempPath()) ('hoalife-download-' + [guid]::NewGuid().ToString('N'))
    [IO.Directory]::CreateDirectory($work) | Out-Null
    # Enable TLS 1.2 for older Windows PowerShell defaults; retain newer protocols.
    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
    Get-PublicAsset "$base/$asset" (Join-Path $work $asset)
    Get-PublicAsset "$base/SHA256SUMS" (Join-Path $work 'SHA256SUMS')
    $expected = $null
    $count = 0
    foreach ($line in [IO.File]::ReadAllLines((Join-Path $work 'SHA256SUMS'))) {
        if ($line -cnotmatch '\A([0-9a-f]{64})  ([A-Za-z0-9_.-]+)\z') { throw 'Malformed checksum manifest' }
        if ($Matches[2] -ceq $asset) { $count++; $expected = $Matches[1] }
    }
    if ($count -ne 1) { throw 'Expected exactly one checksum entry for the selected archive' }
    if ((Get-FileHash -LiteralPath (Join-Path $work $asset) -Algorithm SHA256).Hash.ToLowerInvariant() -cne $expected) { throw 'SHA-256 mismatch; refusing archive' }

    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $archive = [IO.Compression.ZipFile]::OpenRead((Join-Path $work $asset))
    try {
        $required = @('hoalife.exe', 'LICENSE.txt', 'THIRD_PARTY_NOTICES.txt', 'README.txt')
        $seen = [Collections.Generic.HashSet[string]]::new([StringComparer]::Ordinal)
        foreach ($entry in $archive.Entries) {
            $kind = ($entry.ExternalAttributes -shr 16) -band 0xF000
            if ($entry.FullName -cnotin $required -or -not $seen.Add($entry.FullName) -or
                ($kind -ne 0 -and $kind -ne 0x8000) -or ($entry.ExternalAttributes -band 0x410) -ne 0 -or $entry.Length -eq 0) {
                throw 'Unsafe or unexpected archive contents (only four root regular files are allowed)'
            }
        }
        if ($seen.Count -ne 4) { throw 'Archive is missing required files' }
        [IO.Directory]::CreateDirectory($InstallDir) | Out-Null
        $storage = Join-Path $InstallDir '.hoalife'
        if (Test-Path -LiteralPath $storage) {
            if ((Get-Item -LiteralPath $storage -Force).Attributes -band [IO.FileAttributes]::ReparsePoint) { throw 'Refusing reparse-point installation storage' }
        }
        [IO.Directory]::CreateDirectory($storage) | Out-Null
        $generation = Join-Path $storage ($Version + '-' + [guid]::NewGuid().ToString('N'))
        [IO.Directory]::CreateDirectory($generation) | Out-Null
        foreach ($entry in $archive.Entries) {
            # Exact names were checked above; no archive-supplied path is extracted.
            $inputStream = $entry.Open()
            $outputStream = $null
            try {
                $outputStream = [IO.File]::Open((Join-Path $generation $entry.FullName), [IO.FileMode]::CreateNew)
                $inputStream.CopyTo($outputStream)
                if ($outputStream.Length -le 0 -or $outputStream.Length -ne $entry.Length) {
                    throw 'Malformed archive: extracted size differs from the declared nonzero size'
                }
            } finally {
                if ($outputStream) { $outputStream.Dispose() }
                $inputStream.Dispose()
            }
        }
    } finally { $archive.Dispose() }
    $target = Join-Path $InstallDir 'hoalife.exe'
    if ((Test-Path -LiteralPath $target) -and ((Get-Item -LiteralPath $target -Force).Attributes -band [IO.FileAttributes]::ReparsePoint)) { throw 'Refusing reparse-point executable' }
    # Reuse a matching complete generation on repeat installs.
    $same = $false
    if (Test-SameFile (Join-Path $generation 'hoalife.exe') $target) {
        foreach ($existing in Get-ChildItem -LiteralPath $storage -Directory -Force) {
            if ($existing.FullName -eq $generation) { continue }
            if ($existing.Attributes -band [IO.FileAttributes]::ReparsePoint) { continue }
            $same = $true
            foreach ($name in $required) {
                if (-not (Test-SameFile (Join-Path $generation $name) (Join-Path $existing.FullName $name))) { $same = $false; break }
            }
            if ($same) { break }
        }
    }
    if (-not $same) {
        # Same-volume atomic replacement. A locked executable fails without
        # truncating the old executable or touching saved CLI profiles.
        $candidate = Join-Path $generation 'candidate.exe'
        [IO.File]::Copy((Join-Path $generation 'hoalife.exe'), $candidate)
        if ([IO.File]::Exists($target)) { [IO.File]::Replace($candidate, $target, [System.Management.Automation.Language.NullString]::Value) }
        else { [IO.File]::Move($candidate, $target) }
        $committed = $true
        Write-Output "Installed $Version (windows/$Arch): $target"
        Write-Output "Notices: $generation"
    } else { Write-Output "Already installed: $target" }
    if (-not $NoPathUpdate) {
        try { Add-UserPath $InstallDir }
        catch { Write-Warning "Installation succeeded but user PATH could not be updated. Add this directory to PATH: $InstallDir. $($_.Exception.Message)" }
    }
    Write-Output "Executable: $target. After PATH setup, open a new terminal and check Get-Command hoalife."
} finally {
    if ($work -and [IO.Directory]::Exists($work)) { Remove-Item -LiteralPath $work -Recurse -Force }
    if (-not $committed -and $generation -and [IO.Directory]::Exists($generation)) { Remove-Item -LiteralPath $generation -Recurse -Force }
}
