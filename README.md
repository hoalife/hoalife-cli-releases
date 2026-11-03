# HOALife CLI downloads

Prebuilt `hoalife` binaries are available on the **[latest release page](https://github.com/hoalife/hoalife-cli-releases/releases/latest)**.

Published downloads are accessible without a GitHub account or access to the private source repository. Installation requires neither Go nor source access.

This is the public, binary-only distribution repository for the HOALife command line app. Application and library source code and their Git history remain private. This repository holds installation and usage documentation, release notes, binary archives, SHA-256 checksums, and required license notices.

## Platforms

Releases target these platforms:

| Operating system | Architectures | Archive |
| --- | --- | --- |
| Linux | amd64 (x86-64), arm64 (AArch64) | `.tar.gz` |
| macOS | amd64 (Intel), arm64 (Apple silicon) | `.tar.gz` |
| Windows | amd64 (x86-64), arm64 (AArch64) | `.zip` |

Each release includes version-specific notes, all six platform archives, and SHA-256 checksums. Each archive includes the required license and third-party notices for its binary.

## Installation and usage

Follow the [Windows, macOS, and Linux installation and manual upgrade guide](INSTALL.md). It covers the standalone [`install.sh`](install.sh) and [`install.ps1`](install.ps1) helpers, explicit version selection, SHA-256 verification, PATH, upgrades, and a manual fallback. The installers need no Go, GitHub login, or administrator privileges.

Install the latest release:

```sh
# Linux/macOS: install without retaining the helper script.
curl --fail --location --proto '=https' --proto-redir '=https' https://raw.githubusercontent.com/hoalife/hoalife-cli-releases/main/install.sh | sh
```

```powershell
# Windows PowerShell 5.1+ or PowerShell 7+: download and review first.
Invoke-WebRequest -UseBasicParsing -Uri https://raw.githubusercontent.com/hoalife/hoalife-cli-releases/main/install.ps1 -OutFile install.ps1
.\install.ps1
```

To install a specific release, pass `--version <tag>` to the shell installer (`sh -s -- --version <tag>` when piping), or `-Version <tag>` to the PowerShell installer. Use the exact published tag, including its leading `v`. See [installation requirements and options](INSTALL.md#installer-helpers) before running these examples.

After installation:

```sh
hoalife --help
hoalife profile new --name work
hoalife accounts
```

### Usage
  ```sh
  hoalife help
  ```
  - [Command reference](docs/commands.md): public command help, including all subcommands and flags.
