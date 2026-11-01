# Install or upgrade HOALife CLI

Download [v0.1.0](https://github.com/hoalife/hoalife-cli-releases/releases/tag/v0.1.0) from the [public releases page](https://github.com/hoalife/hoalife-cli-releases/releases). Downloads require no GitHub login, Go installation, or source access.

## Choose a published version and platform

Select an actual published stable release and copy its exact title/tag, including the leading `v`. Supported version labels are `v0.MINOR.PATCH` and `v1.MINOR.PATCH`, with numeric minor/patch values and no leading zeroes. The examples below use `v0.1.0`. To install a different published version, replace that value with its exact tag. Do not use `latest` as the version value.

| Your system | Architecture | Asset name (`<tag>` is the exact release tag) |
| --- | --- | --- |
| Linux, Intel/AMD 64-bit | amd64 | `hoalife_<tag>_linux_amd64.tar.gz` |
| Linux, ARM64/AArch64 | arm64 | `hoalife_<tag>_linux_arm64.tar.gz` |
| macOS, Intel | amd64 | `hoalife_<tag>_darwin_amd64.tar.gz` |
| macOS, Apple silicon | arm64 | `hoalife_<tag>_darwin_arm64.tar.gz` |
| Windows, Intel/AMD 64-bit | amd64 | `hoalife_<tag>_windows_amd64.zip` |
| Windows, ARM64 | arm64 | `hoalife_<tag>_windows_arm64.zip` |

On Linux/macOS, `uname -m` usually reports `x86_64` for amd64 or `aarch64`/`arm64` for arm64. On an Apple silicon Mac, use arm64 even if a terminal running under Rosetta reports x86_64. On Windows, check **Settings → System → About → System type** for x64 or ARM64. There are no 32-bit archives.

Each release has six platform archives plus `LICENSE.txt`, `THIRD_PARTY_NOTICES.txt`, `RELEASE_NOTES.md`, and `SHA256SUMS`: ten downloadable assets. The sorted checksum manifest lists the other nine assets, using lowercase SHA-256, two spaces, and the filename. The manifest itself is not signed. Checksum verification detects a mismatch against that manifest; it is not a code signature.

Use the named platform archive. GitHub's automatic **Source code** downloads contain distribution documentation and no executable. Download only from the public repository over HTTPS. The versioned URL pattern is:

```text
https://github.com/hoalife/hoalife-cli-releases/releases/download/<tag>/<asset>
```

## Installer helpers

The helpers download only your selected platform archive and its `SHA256SUMS` from this repository's versioned HTTPS release URLs. They check the manifest syntax, require exactly one matching checksum, verify SHA-256, and accept exactly four nonempty root regular files: the executable, `LICENSE.txt`, `THIRD_PARTY_NOTICES.txt`, and `README.txt`. Extra files, duplicate names, directories, links, and paths outside that layout are rejected before installation. They never run the downloaded binary, request administrator privileges, or change platform security settings.

Review the helper after downloading it. Use the repository's `main` helper URL below; the version argument selects the binary release, not the helper revision. You may also download these scripts from a reviewed repository revision. Do not pipe the download directly into a shell.

### Linux and macOS helper

Requirements: a POSIX shell, `curl` with HTTPS support, GNU or BSD `tar` (including `-xO`), `awk`, `grep`, `mktemp`, standard file utilities, and either `sha256sum` or `shasum`. These are commonly available on Linux/macOS; minimal Linux installations may need curl and tar installed first. Python and Go are not required.

```sh
curl --fail --location --proto '=https' --proto-redir '=https' --output install.sh \
  https://raw.githubusercontent.com/hoalife/hoalife-cli-releases/main/install.sh
# Read install.sh before running it.
sh install.sh --version v0.1.0
```

The helper detects Linux/macOS and amd64/arm64. On Apple silicon, it selects arm64 even under Rosetta. Override detection or choose a destination with:

```sh
sh install.sh --version v0.1.0 --os darwin --arch arm64 \
  --install-dir "$HOME/Applications/HOALife CLI/bin"
```

`--os` accepts `linux` or `darwin`; `--arch` accepts `amd64` or `arm64`. Overrides select the downloaded binary and do not make a foreign binary runnable on your host. The default destination is `$HOME/.local/bin`. The executable is a symlink to a complete installation under that directory's `.hoalife/<version>-<unique-id>/`, which retains the three notice files. Do not move the symlink alone. Repeating an identical install reuses the existing generation. Upgrades retain previous generations and their notices; the helper does not prune them automatically.

The helper prints the directory to add to PATH but does not edit your shell configuration. For the default destination:

```sh
export PATH="$HOME/.local/bin:$PATH"
command -v hoalife
```

Persist that line in your shell startup file (commonly `~/.zshrc` or `~/.bashrc`) and open a new terminal. For an override, substitute your chosen directory, keeping quotes around paths with spaces.

### Windows helper

Requirements: Windows PowerShell 5.1 or PowerShell 7+, HTTPS access with TLS 1.2+, and a writable user destination on a local filesystem that supports atomic file replacement (normally NTFS). Use your device's script execution policy; managed devices may require approval for a downloaded script. Do not disable security checks to run the helper.

```powershell
Invoke-WebRequest -UseBasicParsing -Uri https://raw.githubusercontent.com/hoalife/hoalife-cli-releases/main/install.ps1 -OutFile install.ps1
# Read install.ps1 before running it.
.\install.ps1 -Version v0.1.0
```

The helper queries Windows directly for native amd64/arm64, including ARM64 under an emulated PowerShell process or older .NET runtime. Automatic detection requires the Windows native-architecture API available in Windows 10 version 1709 / Windows Server version 1709 or newer; on older systems specify `-Arch` explicitly. To select explicitly, or choose a destination:

```powershell
.\install.ps1 -Version v0.1.0 -Arch arm64 -InstallDir "$HOME\Apps\HOALife CLI\bin"
```

`-Arch` accepts `amd64` or `arm64`. The default destination is `%LOCALAPPDATA%\Programs\HOALife\bin`. Relative `-InstallDir` paths resolve against the current PowerShell filesystem location. The executable is `hoalife.exe` in that directory, and the four verified archive files are retained under `.hoalife\<version>-<unique-id>\`. Previous generations and notices remain available after upgrades; an identical repeat install reuses a generation. A destination containing `;` is rejected because it cannot form a single PATH entry.

By default the helper adds the destination once to the **user** PATH, preserving raw variable references and the existing registry value type, and updates PATH for the invoking PowerShell session. Comparisons ignore case and trailing separators. Open a new terminal and use `Get-Command hoalife` to confirm the chosen copy. Pass `-NoPathUpdate` to manage PATH yourself. A PATH write failure produces a warning with manual guidance after a successful installation. For destinations containing a literal `%`, installation succeeds but automatic PATH changes are skipped: Windows could expand part of the literal directory name into another path. Invoke `hoalife.exe` by its full quoted path (for example, `& "$HOME\Apps\HOALife CLI\bin\hoalife.exe" --help`) or choose a destination without percent signs.

### Upgrades and failures

Read the target release's notes, close running CLI commands, then rerun the helper with the new explicit version and the same destination. Verify `hoalife --version` and `hoalife --help` yourself using the checks below. Neither helper edits profiles or other CLI configuration, or removes unrelated files. Keep your previous verified archive and notices if you need to downgrade, and read compatibility guidance before doing so.

Invalid arguments, unsupported systems, missing releases, failed downloads, checksum failures, or unsafe archives stop installation. Temporary downloads and incomplete staging files are removed on normal errors and handled termination; forced process termination or power loss may leave temporary files. New files are staged on the destination filesystem, and the executable changes only after staging succeeds. A failed replacement (including a locked Windows executable or denied write access) preserves the previous executable and its notices. Failed attempts can leave empty parent installation directories. Use a destination you control; do not run concurrently against the same destination or use shared, untrusted writable directories. The installers do not automatically execute or verify the real application's version.

SHA-256 checks are against the unsigned release manifest; they do not provide code signing or notarization. See [signing and platform prompts](#signing-and-platform-prompts). Offline fixture results alone are not evidence of a public download or a real CLI installation.

## Manual fallback: Linux and macOS

These commands use a POSIX shell, `curl`, and `tar`. Linux also needs `sha256sum`; macOS uses `shasum`. Work in an empty download directory. Set `os` and `arch` to your selection from the table:

```sh
version='v0.1.0'
os=darwin   # macOS: darwin; Linux: linux
arch=arm64  # Apple silicon/ARM64: arm64; Intel/AMD: amd64
asset="hoalife_${version}_${os}_${arch}.tar.gz"
base="https://github.com/hoalife/hoalife-cli-releases/releases/download/$version"
curl --fail --location --output "$asset" "$base/$asset"
curl --fail --location --output SHA256SUMS "$base/SHA256SUMS"
```

Stop if either download fails. Verify only your selected archive, since the full manifest also lists assets you have not downloaded:

```sh
awk -v name="$asset" '$2 == name {print}' SHA256SUMS > "$asset.sha256"
test "$(wc -l < "$asset.sha256" | tr -d ' ')" = 1
```

Stop unless that test succeeds. Then run the command for your OS:

```sh
# Linux:
sha256sum -c "$asset.sha256"

# macOS (run this instead of the Linux command):
shasum -a 256 -c "$asset.sha256"
```

Continue only when verification exits successfully and reports `OK`. On a mismatch, discard the download and obtain the archive and manifest again from the same release. Do not extract or run the failed download.

Before extraction, inspect `tar -tzf "$asset"` and `tar -tvzf "$asset"`. Require exactly the four distinct root files listed below, all regular files, with no directory entries, links, extra files, or path prefixes. Stop if anything differs. Prefer the helper for automated archive validation.

Extract into a new directory and install for your user:

```sh
mkdir hoalife-extracted
tar -xzf "$asset" -C hoalife-extracted
mkdir -p "$HOME/.local/bin" "$HOME/.local/share/hoalife/$version"
cp hoalife-extracted/LICENSE.txt hoalife-extracted/THIRD_PARTY_NOTICES.txt hoalife-extracted/README.txt "$HOME/.local/share/hoalife/$version/"
install -m 755 hoalife-extracted/hoalife "$HOME/.local/bin/hoalife"
export PATH="$HOME/.local/bin:$PATH"
hoalife --version
hoalife --help
```

To keep this `PATH` setting, add `export PATH="$HOME/.local/bin:$PATH"` to the startup file used by your shell (commonly `~/.zshrc` for interactive zsh or `~/.bashrc` for interactive bash), then open a new terminal. Check `command -v hoalife` to confirm which copy runs. No administrator privileges are needed for this location.

## Manual fallback: Windows (PowerShell)

Work in an empty download directory. Set `arch` from System type: `amd64` for x64 or `arm64` for ARM64.

```powershell
$ErrorActionPreference = 'Stop'
$version = 'v0.1.0'
$arch = 'amd64'
$asset = "hoalife_${version}_windows_${arch}.zip"
$base = "https://github.com/hoalife/hoalife-cli-releases/releases/download/$version"
Invoke-WebRequest -UseBasicParsing -Uri "$base/$asset" -OutFile $asset
Invoke-WebRequest -UseBasicParsing -Uri "$base/SHA256SUMS" -OutFile SHA256SUMS
$lines = @(Get-Content SHA256SUMS | Where-Object { $_.EndsWith("  $asset") })
if ($lines.Count -ne 1 -or $lines[0] -cnotmatch '^[0-9a-f]{64}  .+$') {
    throw 'Expected exactly one checksum for this archive'
}
$expected = $lines[0].Substring(0, 64)
$actual = (Get-FileHash -Algorithm SHA256 $asset).Hash.ToLowerInvariant()
if ($actual -cne $expected) { throw 'SHA-256 mismatch; do not extract or run this download' }
Write-Output 'SHA-256 OK'
```

Continue only after `SHA-256 OK`. On failure, discard the download and obtain the archive and manifest again from the same release.

Before extraction, inspect the ZIP entries with a trusted archive viewer. Require exactly the four distinct root regular files listed below; reject links, directories, extra files, or nested paths. Prefer the helper for automated archive validation.

```powershell
Expand-Archive -LiteralPath $asset -DestinationPath .\hoalife-extracted
$installDir = Join-Path $env:LOCALAPPDATA 'Programs\HOALife\bin'
$noticeDir = Join-Path $env:LOCALAPPDATA "Programs\HOALife\notices\$version"
New-Item -ItemType Directory -Force -Path $installDir, $noticeDir | Out-Null
Copy-Item .\hoalife-extracted\hoalife.exe $installDir -Force
Copy-Item .\hoalife-extracted\LICENSE.txt, .\hoalife-extracted\THIRD_PARTY_NOTICES.txt, .\hoalife-extracted\README.txt $noticeDir -Force
$userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
if (($userPath -split ';') -notcontains $installDir) {
    $newPath = if ([string]::IsNullOrEmpty($userPath)) { $installDir } else { "$installDir;$userPath" }
    [Environment]::SetEnvironmentVariable('Path', $newPath, 'User')
}
$env:Path = "$installDir;$env:Path"
hoalife --version
hoalife --help
```

The user `Path` change applies to new terminals. Use `Get-Command hoalife` to confirm the executable path. The example preserves the existing user `Path` and does not require an administrator.

## Verify the installed version

Each archive has exactly four files at its root: `hoalife` (or `hoalife.exe`), `LICENSE.txt`, `THIRD_PARTY_NOTICES.txt`, and `README.txt`. Keep the terms and notices with your installation. Read `LICENSE.txt` for the application's actual binary terms; third-party notices do not license the application source.

Compare `hoalife --version` with the chosen release's notes and the extracted `README.txt`:

```text
hoalife version <exact-v-tag> (commit <40-character-source-SHA>, built <YYYY-MM-DDTHH:MM:SSZ>)
```

The tag, full source commit, and UTC build time must all match. The public release title/tag and archive names use that same version. A `dev`/`unknown` value is not an official stamped release. Version and help commands do not need an account or network access. Continue with [initial setup and usage](USAGE.md).

## Signing and platform prompts

Initial binaries are **not code-signed**, and macOS binaries are **not notarized**. Gatekeeper or Windows SmartScreen may warn or block execution. Verify the download source and SHA-256 first, then follow your device's security policy for approving a trusted executable. Managed devices may require an administrator's approval. Do not disable system-wide protections to install the CLI. SHA-256 verification does not remove these limits.

## Manual upgrades

There is no automatic updater or package-manager channel. You can rerun the helper as described above. For the manual fallback, upgrade as follows:

1. Read the new release's notes for behavior changes and compatibility guidance. Record your current `hoalife --version` and executable path.
2. Close running CLI commands. Download the new version's archive **and its own** `SHA256SUMS` into a fresh directory. Repeat the checks above before extracting.
3. Repeat the installation steps to replace the executable at the same location and retain the new notices. Remove or rename an earlier `hoalife-extracted` directory first; do not mix releases.
4. Open a new terminal and check the executable path, `hoalife --version`, and `hoalife --help`. Ensure they refer to the new version. Run `hoalife profile list --output json` to check saved profile availability without interactive authorization.

Replacing the executable does not remove profiles. Do not delete your profile configuration to upgrade. Keep a verified previous archive and its notices if you need to return to an older version, and check that release's compatibility guidance before doing so. Package-manager integration, automatic updates, signing, and notarization remain deferred.
