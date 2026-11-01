# Install or upgrade HOALife CLI

**First release pending.** These instructions describe the release asset contract; there is no published version to download yet. After publication, use the [public releases page](https://github.com/hoalife/hoalife-cli-releases/releases). Downloads require no GitHub login, Go installation, or source access.

## Choose a published version and platform

Select an actual published stable release and copy its exact title/tag, including the leading `v`. Supported version labels are `v0.MINOR.PATCH` and `v1.MINOR.PATCH`, with numeric minor/patch values and no leading zeroes. `REPLACE_WITH_PUBLISHED_TAG` below is a placeholder: replace it before running the download commands. It is neither a selected first version nor a working release link. Do not use `latest` as the version value.

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

## Linux and macOS

These commands use a POSIX shell, `curl`, and `tar`. Linux also needs `sha256sum`; macOS uses `shasum`. Work in an empty download directory. Set `os` and `arch` to your selection from the table:

```sh
version='REPLACE_WITH_PUBLISHED_TAG'
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

## Windows (PowerShell)

Work in an empty download directory. Set `arch` from System type: `amd64` for x64 or `arm64` for ARM64.

```powershell
$ErrorActionPreference = 'Stop'
$version = 'REPLACE_WITH_PUBLISHED_TAG'
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

There is no automatic updater or package-manager channel. To upgrade:

1. Read the new release's notes for behavior changes and compatibility guidance. Record your current `hoalife --version` and executable path.
2. Close running CLI commands. Download the new version's archive **and its own** `SHA256SUMS` into a fresh directory. Repeat the checks above before extracting.
3. Repeat the installation steps to replace the executable at the same location and retain the new notices. Remove or rename an earlier `hoalife-extracted` directory first; do not mix releases.
4. Open a new terminal and check the executable path, `hoalife --version`, and `hoalife --help`. Ensure they refer to the new version. Run `hoalife profile list --output json` to check saved profile availability without interactive authorization.

Replacing the executable does not remove profiles. Do not delete your profile configuration to upgrade. Keep a verified previous archive and its notices if you need to return to an older version, and check that release's compatibility guidance before doing so. Package-manager integration, automatic updates, signing, and notarization remain deferred.
