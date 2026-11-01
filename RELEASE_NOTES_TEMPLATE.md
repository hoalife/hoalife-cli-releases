# Public release-note template

This is an editorial template, not a published release. Replace `REPLACE_WITH_PUBLISHED_TAG` and every angle-bracket placeholder with reviewed public values before use. The release title and tag must be the same exact stable `v0.MINOR.PATCH` or `v1.MINOR.PATCH` version used by the executable and archive filenames. Record the full source SHA as text; do not link to private source, issues, build logs, or discussions. Do not automatically copy commit messages. Do not claim download checks or platform tests that have not run. Release automation supplies its own baseline notes; maintainers must coordinate any editorial changes with that release process before publication.

---

# HOALife CLI <exact-v-tag>

<Describe user-visible changes and any breaking behavior or upgrade action in public prose.>

Source version: `<exact-v-tag>`
Source commit: `<40-character-lowercase-source-SHA>`
Built (UTC): `<YYYY-MM-DDTHH:MM:SSZ>`

## Downloads and installation

Download a platform archive from [this release](https://github.com/hoalife/hoalife-cli-releases/releases/tag/REPLACE_WITH_PUBLISHED_TAG). Follow the [installation and checksum guide](https://github.com/hoalife/hoalife-cli-releases/blob/main/INSTALL.md) and [usage guide](https://github.com/hoalife/hoalife-cli-releases/blob/main/USAGE.md). No GitHub login, Go installation, or private source access is needed.

| Platform | amd64 | arm64 |
| --- | --- | --- |
| Linux | [archive](https://github.com/hoalife/hoalife-cli-releases/releases/download/REPLACE_WITH_PUBLISHED_TAG/hoalife_REPLACE_WITH_PUBLISHED_TAG_linux_amd64.tar.gz) | [archive](https://github.com/hoalife/hoalife-cli-releases/releases/download/REPLACE_WITH_PUBLISHED_TAG/hoalife_REPLACE_WITH_PUBLISHED_TAG_linux_arm64.tar.gz) |
| macOS | [archive](https://github.com/hoalife/hoalife-cli-releases/releases/download/REPLACE_WITH_PUBLISHED_TAG/hoalife_REPLACE_WITH_PUBLISHED_TAG_darwin_amd64.tar.gz) | [archive](https://github.com/hoalife/hoalife-cli-releases/releases/download/REPLACE_WITH_PUBLISHED_TAG/hoalife_REPLACE_WITH_PUBLISHED_TAG_darwin_arm64.tar.gz) |
| Windows | [archive](https://github.com/hoalife/hoalife-cli-releases/releases/download/REPLACE_WITH_PUBLISHED_TAG/hoalife_REPLACE_WITH_PUBLISHED_TAG_windows_amd64.zip) | [archive](https://github.com/hoalife/hoalife-cli-releases/releases/download/REPLACE_WITH_PUBLISHED_TAG/hoalife_REPLACE_WITH_PUBLISHED_TAG_windows_arm64.zip) |

Intel/AMD 64-bit systems use amd64; Apple silicon and other ARM64 systems use arm64. Use platform archives rather than GitHub's automatic source downloads.

Verify the selected archive against [SHA256SUMS](https://github.com/hoalife/hoalife-cli-releases/releases/download/REPLACE_WITH_PUBLISHED_TAG/SHA256SUMS) before extraction. The manifest covers all nine other assets; check the matching archive line if you downloaded only one. Each archive contains the executable at its root, `LICENSE.txt`, `THIRD_PARTY_NOTICES.txt`, and `README.txt`. Keep the terms and notices. Standalone [application terms](https://github.com/hoalife/hoalife-cli-releases/releases/download/REPLACE_WITH_PUBLISHED_TAG/LICENSE.txt), [third-party notices](https://github.com/hoalife/hoalife-cli-releases/releases/download/REPLACE_WITH_PUBLISHED_TAG/THIRD_PARTY_NOTICES.txt), and [release notes](https://github.com/hoalife/hoalife-cli-releases/releases/download/REPLACE_WITH_PUBLISHED_TAG/RELEASE_NOTES.md) are also assets.

After installation, `hoalife --version` must print:

```text
hoalife version <exact-v-tag> (commit <40-character-lowercase-source-SHA>, built <YYYY-MM-DDTHH:MM:SSZ>)
```

## Upgrade and compatibility

<State the tested upgrade path and any compatibility limits or actions.>

Upgrade manually using the new archive and its matching manifest, then replace the executable and retain the notices. Preserve saved profiles. Confirm the version and executable path after replacement. See [manual upgrades](https://github.com/hoalife/hoalife-cli-releases/blob/main/INSTALL.md#manual-upgrades).

## Limits

Production binaries connect to `https://api.hoalife.com/` and ignore `HOALIFE_BASE_URL`. Initial binaries are unsigned, and macOS binaries are not notarized. SHA-256 checks do not provide code signing. Package managers, automatic updates, signing, and notarization are deferred. This release distributes the CLI only.

## Verification

<Record completed anonymous download/checksum checks and smoke tests, listing OS/architecture and distinguishing native execution from archive or binary inspection. If checks remain pending, say so explicitly. Do not include private logs, credentials, or private links.>
