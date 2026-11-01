# Use HOALife CLI

[Install a published binary](INSTALL.md), then use `hoalife --help` or the [command reference](docs/commands.md). Production binaries use `https://api.hoalife.com/`; setting `HOALIFE_BASE_URL` does not redirect them.

## Sign in with OAuth

On a computer with a browser, run:

```sh
hoalife profile new --name work --output text
hoalife profile default --name work
hoalife profile show
hoalife profile
hoalife accounts
```

Omit API-key flags to sign in through your browser. Allow the local loopback callback to complete on the same computer, and keep the command running until authorization finishes. No OAuth client secret is required. Use text mode without `--no-input` for this initial authorization.

The first profile becomes the default if none is set. `profile show` displays saved profile metadata; bare `profile` fetches current account information and permissions. Commands use the saved default profile: use `profile default --name NAME` to switch. There is no per-command `--profile` flag.

Saved OAuth credentials refresh automatically. If a refresh token or grant expires, interactive commands may open the browser again. In unattended mode, reauthorization returns an error with instructions to sign in interactively. If creation says a profile was saved but account discovery failed, retry `hoalife profile` after resolving the reported problem; do not create another profile with the same name.

## Use a service-account API key

Obtain the API key and response signing secret from your HOALife administrator. For a profile named `service`, supply **both** credential flags. This shell example assumes `HOALIFE_API_KEY` and `HOALIFE_SIGNING_SECRET` have been populated securely for this invocation; these names are example variables, not automatically read CLI settings:

```sh
hoalife profile new --name service --api-key "$HOALIFE_API_KEY" --signing-secret "$HOALIFE_SIGNING_SECRET" --output json
hoalife profile default --name service --output json
```

In PowerShell, the equivalent credential arguments are `--api-key $env:HOALIFE_API_KEY --signing-secret $env:HOALIFE_SIGNING_SECRET`. Do not paste actual credentials into documentation, shell history, logs, or shared scripts. Flag values can be visible to local process inspection; run on a trusted computer. The command verifies access and discovers account information; it needs network access. It does not use browser sign-in when both credential flags are supplied.

Credentials are saved in the operating system's user configuration directory. Protect that directory and its backups. Profile and resource output omits credential fields; it is not a credential export.

## Manage profiles

```sh
hoalife profile list
hoalife profile show --output json
hoalife profile default --name work
hoalife profile remove --name service --no-input
```

`list` marks the default with `*` in text mode. Profile names must be distinct. Removing an OAuth profile first revokes its grant; if revocation fails the profile is retained. Removing an API-key profile removes the local profile, not the service-account key at HOALife. Removing the default clears default selection; select another before unattended commands. Existing saved profiles can be kept when upgrading the executable.

## Read resources and discover writable attributes

Plural commands list resources and automatically follow all result pages. `--limit` passes directly to the API; it is not a local output cap. Account-scoped commands use the selected profile's account context.

```sh
hoalife accounts
hoalife properties --limit 100 --order id --order-dir asc
hoalife properties --filter 'external_id=EXT42' --output json
hoalife schema
hoalife schema properties --operation update --output json
```

`--filter key=value` is repeatable; `--filter-ATTRIBUTE value` is an equivalent dynamic form. Values pass through to the API; the server determines which filters, limits, and sort fields are supported. Collection commands expose `--filter`, `--limit`, `--order`, and `--order-dir`. Read [command help](docs/commands.md) for the flags on each command.

Singular commands expose the operations listed by help. Run create/update **without attributes** to discover accepted flags, without changing a resource:

```sh
hoalife property create
hoalife property update --output json
hoalife schema properties --operation create --output json
```

Schema discovery can use a fresh local cache. A missing or expired cache requires authentication and network access. `hoalife schema --refresh` forces a fetch. Writable attribute flags depend on the server schema, so they are discovered at runtime rather than frozen into the command reference.

When ready to make an authorized change, supply `--attr-NAME value` or repeat `--attr name=value`. Updates require an explicit resource `--id` when sending attributes. Only supplied values are sent; schema defaults are not added. For example, these commands change a property and create a note (replace IDs with your own):

```sh
hoalife property update --id 42 --attr-external_id EXT42
hoalife note create --attr-body_text 'Inspection follow-up' --attr-attached_to_type acc_request --attr-attached_to_id 42
```

Attribute types come from the selected operation's schema. Strings retain their spelling, including leading zeroes. Numbers and booleans use JSON syntax; arrays/objects take JSON values. Nullable fields accept `null`. Use a JSON-quoted string, such as `--attr-external_id '"null"'` in a POSIX shell, to send the literal string `null` when the schema permits it. The CLI checks required fields and top-level types; the API enforces permissions and further validation. Unknown attributes may require `hoalife schema --refresh`.

`invoice create` accepts asynchronous work and returns `{"accepted":true,"resource":"invoice","account_id":"..."}` in JSON mode. It does not return a new invoice ID or assert processing is finished; inspect `hoalife invoices` later. `note delete --id ID` also requests asynchronous deletion and returns `{"accepted":true,"operation":"delete","resource":"note","id":"ID"}`. Creating an ACC request vote requests a pending vote/notification; it does not cast a vote. Review these effects before invoking write commands.

## JSON and unattended use

Use `--output json` for structured output. Collections emit **newline-delimited JSON**: one complete JSON:API resource object per line across all pages, not a JSON array. Schema, profile, completion, and individual write results each emit one JSON document. A create/update command without attributes emits its accepted attribute definitions.

```sh
hoalife accounts --output json > accounts.ndjson
hoalife profile show --output json
hoalife schema properties --operation read --output json
hoalife accounts --no-input
```

In a POSIX shell, `export HOALIFE_OUTPUT=json` sets the default. In PowerShell, use `$env:HOALIFE_OUTPUT = 'json'`. Explicit `--output text` overrides it. JSON mode disables prompts, browser authorization, and automatic completion installation. `--no-input` disables interaction while retaining text output unless JSON was selected. Initial OAuth authorization cannot run in either unattended mode; authorize a saved profile interactively first, or provision an API-key profile with all required flags.

Failures exit with status 1 and JSON mode writes an error object to **stderr**, for example:

```json
{"error":{"code":"input_required","message":"no default profile is set; run `hoalife profile default --name NAME`"}}
```

Error codes include `input_required`, `invalid_arguments`, and `command_failed`. API errors can include `status`, `title`, and `detail`. Single-document commands leave stdout empty on failure; streamed collections can contain valid earlier rows if a later page fails. Always check the process exit status before treating a collection as complete (`$?` immediately after the command in a POSIX shell; `$LASTEXITCODE` in PowerShell). Do not merge stderr into a JSON data file. Help and the shell's internal completion protocol remain text even when JSON is selected.

## Shell completion

Explicit completion commands **install** completion for your user; they do not print a script for redirection:

```sh
hoalife completion bash
hoalife completion zsh
hoalife completion fish
hoalife completion powershell
```

Run the command for your shell, then restart that shell. `hoalife completion` detects a shell where possible. On supported interactive terminals, normal text commands may install completion automatically. JSON/`--no-input` disables automatic installation, but an explicit `completion` command still installs it; JSON returns a result such as `{"shell":"zsh","changed":true}`. Shell completion setup may update your shell's startup/profile files. Profiles and API access remain separate from completion installation.
