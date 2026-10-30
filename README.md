# HOALife CLI downloads

Download prebuilt `hoalife` binaries from the **[releases page](https://github.com/hoalife/hoalife-cli-releases/releases)**.

This is the public, binary-only distribution repository for the HOALife command line app. Application and library source code and their Git history remain private. This repository holds installation and usage documentation, release notes, binary archives, SHA-256 checksums, and required license notices.

## Platforms

Releases target these platforms:

| Operating system | Architectures | Archive |
| --- | --- | --- |
| Linux | amd64 (x86-64), arm64 (AArch64) | `.tar.gz` |
| macOS | amd64 (Intel), arm64 (Apple silicon) | `.tar.gz` |
| Windows | amd64 (x86-64), arm64 (AArch64) | `.zip` |

The repository is being set up; binary downloads will appear with the first release. Each release will include version-specific notes, all six platform archives, and SHA-256 checksums. Each archive must include the required license and third-party notices for its binary.

## Installation and usage

Once a release is available, choose the archive matching your operating system and architecture, verify it against that release's SHA-256 checksums, and extract it. Place `hoalife` (or `hoalife.exe` on Windows) in a directory on your `PATH`, then run:

```sh
hoalife --help
hoalife profile new --name work
hoalife accounts
```

Profile creation opens your browser to sign in to HOALife. Production binaries connect to `https://api.hoalife.com/`.

Use the platform archives attached to a release. GitHub's automatically generated “Source code” archives contain this distribution repository's documentation, not the CLI source or an executable.

## Distribution contents

Only public user documentation, release notes, binary archives, checksums, and required license notices belong here. Release tags refer to this repository's documentation history; they must never import commits from the private source repositories. Build logs, credentials, application source, and private source history must not be published here.

Required third-party notices accompany each binary and retain their respective license terms. Public download availability does not grant an open-source license to the HOALife application source.
