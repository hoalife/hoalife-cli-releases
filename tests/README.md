# Offline installer verification

Run the POSIX suite on Linux/macOS with Python 3.9+:

```sh
sh -n install.sh
PYTHONDONTWRITEBYTECODE=1 python3 -m unittest discover -s tests -p 'test_install_sh.py' -v
```

Run the Windows suite on Windows with Windows PowerShell 5.1 or PowerShell 7+:

```powershell
./tests/test_install_ps1.ps1
```

The suites create their own tiny archives and replace only the HTTP download boundary with local copies. The POSIX suite also supplies host-detection shims so all supported selections, including Rosetta, can be checked offline. File hashing, archive inspection, extraction, staging, replacement, and cleanup run through the real installer. Windows fixtures temporarily exercise the current user's PATH and restore it afterward; use a disposable user/runner and avoid other simultaneous PATH edits. No fixture contains an official CLI binary or application license terms. Passing these tests does not prove that a public release exists or that an official binary runs.

Coverage includes successful placement and notice retention, upgrades, repeat installs, paths with spaces, platform/architecture selection and overrides, invalid versions/unsupported systems, missing assets and HTTP failures, malformed/missing/duplicate checksums, tampering, malformed/unsafe archives, permission/replacement failures, preservation of the prior installation and unrelated files, and temporary-file cleanup. POSIX permission-denial verification requires a non-root test user. Windows tests include HTTPS-only redirect handling, locked executable replacement, default destinations, and user-PATH idempotence and raw variable/type preservation and literal-percent destination handling, and malformed ZIP entry-size rejection. ARM64 selection is covered by fixtures; native Windows ARM64 execution requires an ARM64 runner.

The read-only GitHub Actions workflow runs on pull requests and pushes to main using public Linux, macOS, and Windows runners. Windows runs both PowerShell editions. The workflow uses no credentials beyond the read-only checkout token, no application source or private images, and publishes no artifacts. Its presence does not configure repository Actions policies or branch protection; maintainers must enable the workflow and choose required checks separately.
