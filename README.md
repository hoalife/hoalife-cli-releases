# HOALife CLI downloads

Prebuilt `hoalife` binaries are available on the **[releases page](https://github.com/hoalife/hoalife-cli-releases/releases)**. The first release is **[v0.1.0](https://github.com/hoalife/hoalife-cli-releases/releases/tag/v0.1.0)**.

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

Install the published `v0.1.0` release, or substitute another published stable tag:

```sh
# Linux/macOS: download and review the helper before running it.
curl --fail --location --proto '=https' --proto-redir '=https' --output install.sh \
  https://raw.githubusercontent.com/hoalife/hoalife-cli-releases/main/install.sh
sh install.sh --version v0.1.0
```

```powershell
# Windows PowerShell 5.1+ or PowerShell 7+: download and review first.
Invoke-WebRequest -UseBasicParsing -Uri https://raw.githubusercontent.com/hoalife/hoalife-cli-releases/main/install.ps1 -OutFile install.ps1
.\install.ps1 -Version v0.1.0
```

See [installation requirements and options](INSTALL.md#installer-helpers) before running these examples.

After installation:

```sh
hoalife --help
hoalife profile new --name work
hoalife accounts
```

Profile creation opens your browser to sign in to HOALife. Production binaries connect to `https://api.hoalife.com/`.

- [Usage guide](USAGE.md): OAuth and API keys, profiles, resource commands, JSON, unattended use, and shell completion.
- [Command reference](docs/commands.md): public command help, including all subcommands and flags.
- [Release-note template](RELEASE_NOTES_TEMPLATE.md): version metadata, user changes, asset links, and release limits.

Initial binaries are unsigned and macOS binaries are not notarized. Package managers and automatic updates are deferred; rerun the installer with the new explicit version or use the manual upgrade procedure.

Use the platform archives attached to a release. GitHub's automatically generated “Source code” archives contain this distribution repository's documentation, not the CLI source or an executable.

## Distribution contents

Only public user documentation, installer helpers and their offline fixture tests, release notes, binary archives, checksums, and required license notices belong here. Release tags refer to this repository's documentation history; they must never import commits from the private source repositories. Build logs, credentials, application source, and private source history must not be published here.

Required third-party notices accompany each binary and retain their respective license terms. Public download availability does not grant an open-source license to the HOALife application source.
