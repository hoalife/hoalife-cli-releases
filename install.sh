#!/bin/sh
# Install only public, explicitly versioned HOALife release assets.
set -eu
umask 077
fail() { printf '%s\n' "hoalife installer: $*" >&2; exit 1; }
usage() {
    echo 'Usage: sh install.sh --version v0.MINOR.PATCH|v1.MINOR.PATCH [--os linux|darwin] [--arch amd64|arm64] [--install-dir DIR]'
}
version='' os='' arch='' destination=${HOME:?HOME is required}/.local/bin
while [ "$#" -gt 0 ]; do
    case $1 in
        --help|-h) usage; exit 0 ;;
        --version|--os|--arch|--install-dir)
            [ "$#" -ge 2 ] && [ -n "$2" ] || fail "Missing value for $1"
            case $1 in
                --version) version=$2 ;; --os) os=$2 ;; --arch) arch=$2 ;; --install-dir) destination=$2 ;;
            esac
            shift 2 ;;
        *) fail "Unknown option: $1 (use --help)" ;;
    esac
done
case $version in *[!0-9v.]*) fail 'Invalid version characters' ;; esac
printf '%s\n' "$version" | LC_ALL=C grep -Eq '^v[01]\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$' || fail 'Specify a stable --version v0.MINOR.PATCH or v1.MINOR.PATCH (no leading zeroes)'
if [ -z "$os" ]; then
    case $(uname -s) in Linux) os=linux ;; Darwin) os=darwin ;; *) fail 'Unsupported operating system' ;; esac
fi
case $os in linux|darwin) ;; *) fail "Unsupported OS: $os" ;; esac
if [ -z "$arch" ]; then
    machine=$(uname -m)
    # Native Apple silicon remains arm64 under a Rosetta x86_64 shell.
    if [ "$os" = darwin ] && [ "$(sysctl -in hw.optional.arm64 2>/dev/null || :)" = 1 ]; then machine=arm64; fi
    case $machine in x86_64|amd64) arch=amd64 ;; arm64|aarch64) arch=arm64 ;; *) fail "Unsupported architecture: $machine" ;; esac
fi
case $arch in amd64|arm64) ;; *) fail "Unsupported architecture: $arch" ;; esac
for tool in curl tar awk cmp mktemp; do command -v "$tool" >/dev/null 2>&1 || fail "Required tool missing: $tool"; done
if command -v sha256sum >/dev/null 2>&1; then hasher=sha256sum
elif command -v shasum >/dev/null 2>&1; then hasher=shasum
else fail 'Requires sha256sum or shasum'; fi
work='' stage='' generation='' committed=no
cleanup() {
    [ -z "$work" ] || rm -rf "$work"
    [ -z "$stage" ] || rm -rf "$stage"
    if [ "$committed" = no ] && [ -n "$generation" ]; then
        # A signal can arrive after rename succeeds but before the shell records
        # success. Never remove a generation that is already the live target.
        live=$(readlink "$destination/hoalife" 2>/dev/null || :)
        [ "$live" = "$generation/hoalife" ] || rm -rf "$generation"
    fi
    :
}
trap cleanup EXIT
trap 'exit 1' HUP INT TERM
work=$(mktemp -d "${TMPDIR:-/tmp}/hoalife-download.XXXXXXXX") || fail 'Cannot create temporary directory'
asset=hoalife_${version}_${os}_${arch}.tar.gz
base=https://github.com/hoalife/hoalife-cli-releases/releases/download/$version
for name in "$asset" SHA256SUMS; do
    curl --fail --silent --show-error --location --proto '=https' --proto-redir '=https' --output "$work/$name" "$base/$name" || fail "Download failed: $name (check the published version)"
done
# Validate the whole manifest grammar; require precisely one selected entry.
expected=$(LC_ALL=C awk -v name="$asset" '
    { if (length($0) < 67 || substr($0,65,2) != "  " || substr($0,1,64) ~ /[^0-9a-f]/ || substr($0,67) !~ /^[A-Za-z0-9_.-]+$/) bad=1
      if (substr($0,67) == name) { count++; hash=substr($0,1,64) } }
    END { if (bad || count != 1) exit 1; print hash }
' "$work/SHA256SUMS") || fail 'Malformed, duplicate or missing checksum entry'
if [ "$hasher" = sha256sum ]; then actual=$(sha256sum "$work/$asset"); else actual=$(shasum -a 256 "$work/$asset"); fi
actual=${actual%% *}
[ "$actual" = "$expected" ] || fail 'SHA-256 mismatch; refusing archive'
# Never extract paths to disk. Require exactly four distinct root regular files,
# then stream only those entries into our own freshly created staging files.
tar -tzf "$work/$asset" > "$work/names" || fail 'Invalid archive'
LC_ALL=C awk '
    $0 != "hoalife" && $0 != "LICENSE.txt" && $0 != "THIRD_PARTY_NOTICES.txt" && $0 != "README.txt" { bad=1 }
    { if (seen[$0]++) bad=1; count++ }
    END { if (bad || count != 4) exit 1 }
' "$work/names" || fail 'Unsafe or unexpected archive paths/contents'
tar -tvzf "$work/$asset" > "$work/types" || fail 'Invalid archive metadata'
LC_ALL=C awk 'substr($0,1,1) != "-" { bad=1 } { count++ } END { if (bad || count != 4) exit 1 }' "$work/types" || fail 'Archive must contain only regular files (no links)'
mkdir -p "$destination" || fail 'Cannot create installation directory'
destination=$(CDPATH='' cd -- "$destination" && pwd -P) || fail 'Cannot resolve installation directory'
[ ! -d "$destination/hoalife" ] || fail 'Destination hoalife is a directory'
[ ! -L "$destination/.hoalife" ] || fail 'Refusing symlinked installation storage'
mkdir -p "$destination/.hoalife" || fail 'Cannot create installation storage'
stage=$(mktemp -d "$destination/.hoalife/$version-XXXXXXXX") || fail 'Cannot stage installation'
for name in hoalife LICENSE.txt THIRD_PARTY_NOTICES.txt README.txt; do
    tar -xOzf "$work/$asset" "$name" > "$stage/$name" || fail "Cannot read $name"
    [ -s "$stage/$name" ] || fail "Empty archive file: $name"
done
chmod 755 "$stage/hoalife"
chmod 644 "$stage/LICENSE.txt" "$stage/THIRD_PARTY_NOTICES.txt" "$stage/README.txt"
# A repeated install of identical files needs no new generation or replacement.
if [ -L "$destination/hoalife" ] && [ -x "$destination/hoalife" ]; then
    current=$(readlink "$destination/hoalife")
    case $current in "$destination/.hoalife/"*/hoalife)
        same=yes
        for name in hoalife LICENSE.txt THIRD_PARTY_NOTICES.txt README.txt; do
            cmp -s "$stage/$name" "${current%/hoalife}/$name" || same=no
        done
        if [ "$same" = yes ]; then
            printf 'Already installed: %s\n' "$destination/hoalife"
            exit 0
        fi ;;
    esac
fi
generation=$stage
stage=
# rename the symlink on the same filesystem, preserving an existing binary
# until all four verified files are ready. Old generations retain their notices.
ln -s "$generation/hoalife" "$generation/link"
mv -f "$generation/link" "$destination/hoalife" || fail 'Cannot replace installed executable'
committed=yes
printf 'Installed %s (%s/%s): %s\nNotices: %s\nAdd this directory to your shell PATH: %s\n' "$version" "$os" "$arch" "$destination/hoalife" "$generation" "$destination"
