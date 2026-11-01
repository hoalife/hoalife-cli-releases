"""Offline installer fixtures: no release, credentials, or network access."""
import hashlib
import io
import os
from pathlib import Path
import shutil
import subprocess
import tarfile
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
VERSION = 'v0.2.3'
FILES = {'hoalife': b'#!/bin/sh\necho fixture-one\n', 'LICENSE.txt': b'fixture terms only\n',
         'THIRD_PARTY_NOTICES.txt': b'fixture notices\n', 'README.txt': b'fixture README\n'}


class InstallerTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix='hoalife fixtures ')
        self.root = Path(self.temp.name)
        self.home = self.root / 'home'
        self.home.mkdir()
        self.dest = self.home / 'bin with spaces'
        self.downloads = self.root / 'downloads'
        self.downloads.mkdir()
        self.tmp = self.root / 'temporary files'
        self.tmp.mkdir()
        self.shims = self.root / 'tools'
        self.shims.mkdir()
        self.log = self.root / 'requests'
        self.env = dict(os.environ, HOME=str(self.home), TMPDIR=str(self.tmp),
                        PATH=str(self.shims) + os.pathsep + os.environ['PATH'],
                        FIXTURES=str(self.downloads), REQUESTS=str(self.log),
                        HOST_OS='Linux', HOST_ARCH='x86_64', APPLE_ARM='0')
        self.shim('curl', '''#!/bin/sh
set -eu
printf '%s\\n' "$*" >> "$REQUESTS"
case "$*" in *"--proto =https --proto-redir =https"*) ;; *) exit 91 ;; esac
out=
while [ "$#" -gt 0 ]; do
  case $1 in --output) out=$2; shift 2 ;; *) url=$1; shift ;; esac
done
case $url in https://github.com/hoalife/hoalife-cli-releases/releases/download/v[01].*/*) ;; *) exit 92 ;; esac
cp "$FIXTURES/${url##*/}" "$out"
''')
        self.shim('uname', '#!/bin/sh\ncase $1 in -s) echo "$HOST_OS" ;; -m) echo "$HOST_ARCH" ;; *) exit 1 ;; esac\n')
        self.shim('sysctl', '#!/bin/sh\necho "$APPLE_ARM"\n')
        self.profile = self.home / '.config/hoalife/profiles.json'
        self.profile.parent.mkdir(parents=True)
        self.profile.write_text('preserve-profile')
        self.fixture()

    def tearDown(self):
        for root, dirs, _ in os.walk(self.root):
            os.chmod(root, 0o700)
        self.temp.cleanup()

    def shim(self, name, text):
        p = self.shims / name
        p.write_text(text)
        p.chmod(0o755)

    def fixture(self, version=VERSION, os_name='linux', arch='amd64', files=None, entries=None):
        asset = f'hoalife_{version}_{os_name}_{arch}.tar.gz'
        path = self.downloads / asset
        files = FILES if files is None else files
        with tarfile.open(path, 'w:gz', format=tarfile.PAX_FORMAT) as archive:
            for name, data in files.items():
                entry = tarfile.TarInfo(name)
                entry.size = len(data)
                archive.addfile(entry, io.BytesIO(data))
            for entry, data in entries or []:
                archive.addfile(entry, io.BytesIO(data) if data else None)
        digest = hashlib.sha256(path.read_bytes()).hexdigest()
        (self.downloads / 'SHA256SUMS').write_text(f'{digest}  {asset}\n' + 'a' * 64 + '  RELEASE_NOTES.md\n')
        return path

    def run_install(self, *args, ok=True):
        result = subprocess.run(['sh', str(ROOT / 'install.sh'), '--version', VERSION,
                                 '--install-dir', str(self.dest), *args],
                                env=self.env, text=True, capture_output=True)
        if ok:
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        else:
            self.assertNotEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertEqual(list(self.tmp.iterdir()), [], 'download cleanup')
        self.assertEqual(list(self.dest.glob('.hoalife/stage.*')), [], 'staging cleanup')
        self.assertEqual(self.profile.read_text(), 'preserve-profile')
        return result

    def old_install(self):
        self.dest.mkdir(parents=True, exist_ok=True)
        (self.dest / 'hoalife').write_bytes(b'prior executable')
        (self.dest / 'unrelated').write_bytes(b'keep me')

    def assert_old(self):
        self.assertEqual((self.dest / 'hoalife').read_bytes(), b'prior executable')
        self.assertEqual((self.dest / 'unrelated').read_bytes(), b'keep me')
        self.assertEqual(list(self.dest.glob('.hoalife/*')), [])

    def test_success_upgrade_idempotence_and_notices(self):
        self.old_install()
        self.run_install()
        target = self.dest / 'hoalife'
        self.assertTrue(target.is_symlink())
        self.assertEqual(target.stat().st_mode & 0o777, 0o755)
        for name, data in FILES.items():
            self.assertEqual((target.resolve().parent / name).read_bytes(), data)
        self.assertEqual(subprocess.check_output([str(target)], text=True).strip(), 'fixture-one')
        original = target.resolve()
        self.run_install()
        self.assertEqual(target.resolve(), original)
        changed = dict(FILES, hoalife=b'#!/bin/sh\necho fixture-two\n')
        self.fixture(version='v1.0.0', files=changed)
        self.run_install('--version', 'v1.0.0')
        self.assertNotEqual(target.resolve(), original)
        self.assertTrue(original.exists())
        self.assertEqual(target.read_bytes(), changed['hoalife'])
        self.assertEqual((self.dest / 'unrelated').read_bytes(), b'keep me')

    def test_default_destination(self):
        self.dest = self.home / '.local/bin'
        result = subprocess.run(['sh', str(ROOT / 'install.sh'), '--version', VERSION],
                                env=self.env, capture_output=True, text=True)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertTrue((self.dest / 'hoalife').is_file())

    def test_platforms_and_explicit_overrides(self):
        for os_name in ('linux', 'darwin'):
            for arch in ('amd64', 'arm64'):
                with self.subTest(os=os_name, arch=arch):
                    self.fixture(os_name=os_name, arch=arch)
                    self.run_install('--os', os_name, '--arch', arch)
                    self.assertIn(f'_{os_name}_{arch}.tar.gz', self.log.read_text().splitlines()[-2])

    def test_native_arch_and_rosetta(self):
        for host, machine, apple, os_name, arch in [
            ('Linux', 'aarch64', '0', 'linux', 'arm64'),
            ('Darwin', 'arm64', '1', 'darwin', 'arm64'),
            ('Darwin', 'x86_64', '1', 'darwin', 'arm64'),
            ('Darwin', 'x86_64', '0', 'darwin', 'amd64')]:
            with self.subTest(host=host, machine=machine, apple=apple):
                self.env.update(HOST_OS=host, HOST_ARCH=machine, APPLE_ARM=apple)
                self.fixture(os_name=os_name, arch=arch)
                self.run_install()
                self.assertIn(f'_{os_name}_{arch}.tar.gz', self.log.read_text().splitlines()[-2])

    def test_invalid_versions_and_arguments_before_download(self):
        for value in ('', 'latest', 'v2.0.0', 'v0.01.0', 'v1.0.01', 'v1.2.3-beta', 'v1.2.3\n', 'v1.2.3/../x', 'v1.2.3\nv1.2.4'):
            with self.subTest(value=value):
                self.run_install('--version', value, ok=False)
        self.run_install('--arch', '386', ok=False)
        self.run_install('--os', 'windows', ok=False)
        self.run_install('--unknown', ok=False)
        self.run_install('--arch', ok=False)
        self.assertFalse(self.log.exists())

    def test_unsupported_host(self):
        self.env['HOST_OS'] = 'FreeBSD'
        self.run_install(ok=False)
        self.env.update(HOST_OS='Linux', HOST_ARCH='i686')
        self.run_install(ok=False)
        self.assertFalse(self.log.exists())

    def test_missing_release_and_failed_manifest_download(self):
        self.old_install()
        self.run_install('--version', 'v1.99.99', ok=False)
        (self.downloads / 'SHA256SUMS').unlink()
        self.run_install(ok=False)
        self.assert_old()

    def test_checksum_rejection_preserves_prior(self):
        self.old_install()
        asset = f'hoalife_{VERSION}_linux_amd64.tar.gz'
        valid = (self.downloads / 'SHA256SUMS').read_text()
        for manifest in ('', valid * 2, valid.replace(asset, 'another.tar.gz'),
                         valid.replace('  ', ' ', 1), valid.upper(),
                         'z' * 64 + f'  {asset}\n', '0' * 64 + f'  {asset}\n',
                         valid + 'malformed\n'):
            with self.subTest(manifest=manifest[:80]):
                (self.downloads / 'SHA256SUMS').write_text(manifest)
                self.run_install(ok=False)
                self.assert_old()
        (self.downloads / 'SHA256SUMS').write_text(valid)
        with (self.downloads / asset).open('ab') as f:
            f.write(b'tamper')
        self.run_install(ok=False)
        self.assert_old()

    def test_archive_rejection_preserves_prior(self):
        self.old_install()
        for name in ('../escape', '/tmp/hoalife-escape', 'nested/file', './hoalife', 'unexpected', 'line\nbreak', 'hoalife'):
            entry = tarfile.TarInfo(name)
            entry.size = 3
            self.fixture(files=FILES if name == 'hoalife' else {k: v for k, v in FILES.items() if k != 'hoalife'}, entries=[(entry, b'bad')])
            self.run_install(ok=False)
            self.assert_old()
        for kind in (tarfile.SYMTYPE, tarfile.LNKTYPE, tarfile.DIRTYPE, tarfile.FIFOTYPE):
            files = {k: v for k, v in FILES.items() if k != 'hoalife'}
            entry = tarfile.TarInfo('hoalife')
            entry.type = kind
            entry.linkname = '../outside'
            self.fixture(files=files, entries=[(entry, None)])
            self.run_install(ok=False)
            self.assert_old()
        self.fixture(files={'hoalife': FILES['hoalife']})
        self.run_install(ok=False)
        self.assert_old()
        self.fixture(files=dict(FILES, hoalife=b''))
        self.run_install(ok=False)
        self.assert_old()
        path = self.fixture()
        path.write_bytes(b'not a tar archive')
        digest = hashlib.sha256(path.read_bytes()).hexdigest()
        (self.downloads / 'SHA256SUMS').write_text(f'{digest}  {path.name}\n')
        self.run_install(ok=False)
        self.assert_old()

    def test_permission_and_storage_errors(self):
        if hasattr(os, 'geteuid') and os.geteuid() == 0:
            self.skipTest('permission denial requires non-root user')
        self.old_install()
        self.dest.chmod(0o555)
        self.run_install(ok=False)
        self.dest.chmod(0o700)
        self.assert_old()
        outside = self.root / 'outside'
        outside.mkdir()
        (self.dest / '.hoalife').symlink_to(outside, target_is_directory=True)
        self.run_install(ok=False)
        self.assertEqual(list(outside.iterdir()), [])
        self.assert_old()

    def test_interrupted_download_cleanup(self):
        self.old_install()
        self.shim('curl', '#!/bin/sh\nkill -TERM "$PPID"\nexit 1\n')
        self.run_install(ok=False)
        self.assert_old()

    def test_signal_after_commit_preserves_live_generation(self):
        self.old_install()
        real_mv = shutil.which('mv')
        self.shim('mv', f'#!/bin/sh\n"{real_mv}" "$@" || exit $?\nkill -TERM "$PPID"\n')
        self.run_install(ok=False)
        self.assertEqual((self.dest / 'hoalife').read_bytes(), FILES['hoalife'])
        self.assertTrue((self.dest / 'hoalife').resolve().exists())
        self.assertEqual((self.dest / 'unrelated').read_bytes(), b'keep me')

    def test_extraction_and_commit_failure_cleanup(self):
        self.old_install()
        real_tar = shutil.which('tar')
        self.shim('tar', f'#!/bin/sh\ncase $1 in -xOzf) exit 1 ;; esac\nexec "{real_tar}" "$@"\n')
        self.run_install(ok=False)
        self.assert_old()
        (self.shims / 'tar').unlink()
        self.shim('mv', '#!/bin/sh\nexit 1\n')
        self.run_install(ok=False)
        self.assert_old()


if __name__ == '__main__':
    unittest.main(verbosity=2)
