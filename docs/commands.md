# Command reference

These are the CLI's public `--help` responses. The first binary release is pending. For an installed release, `hoalife --help` and `hoalife COMMAND --help` are authoritative for that version. See the [usage guide](../USAGE.md) for setup, examples, and output behavior.

Dynamic `--attr-NAME` write flags and `--filter-ATTRIBUTE` collection flags are resolved at runtime. Run a create/update command without attributes or use `hoalife schema RESOURCE --operation OPERATION` to discover writable attributes. This discovery may need a configured profile and network access.

## Commands

- [hoalife](#hoalife)
- [hoalife acc-request-form](#hoalife-acc-request-form)
- [hoalife acc-request-form create](#hoalife-acc-request-form-create)
- [hoalife acc-request-form update](#hoalife-acc-request-form-update)
- [hoalife acc-request-forms](#hoalife-acc-request-forms)
- [hoalife acc-request-requirement](#hoalife-acc-request-requirement)
- [hoalife acc-request-requirement create](#hoalife-acc-request-requirement-create)
- [hoalife acc-request-requirement update](#hoalife-acc-request-requirement-update)
- [hoalife acc-request-requirements](#hoalife-acc-request-requirements)
- [hoalife acc-request-responses](#hoalife-acc-request-responses)
- [hoalife acc-request-vote](#hoalife-acc-request-vote)
- [hoalife acc-request-vote create](#hoalife-acc-request-vote-create)
- [hoalife acc-request-votes](#hoalife-acc-request-votes)
- [hoalife acc-requests](#hoalife-acc-requests)
- [hoalife account](#hoalife-account)
- [hoalife account create](#hoalife-account-create)
- [hoalife account update](#hoalife-account-update)
- [hoalife accounts](#hoalife-accounts)
- [hoalife asset](#hoalife-asset)
- [hoalife asset create](#hoalife-asset-create)
- [hoalife asset update](#hoalife-asset-update)
- [hoalife assets](#hoalife-assets)
- [hoalife ccr-article](#hoalife-ccr-article)
- [hoalife ccr-article create](#hoalife-ccr-article-create)
- [hoalife ccr-article update](#hoalife-ccr-article-update)
- [hoalife ccr-articles](#hoalife-ccr-articles)
- [hoalife ccr-violation-type](#hoalife-ccr-violation-type)
- [hoalife ccr-violation-type create](#hoalife-ccr-violation-type-create)
- [hoalife ccr-violation-type update](#hoalife-ccr-violation-type-update)
- [hoalife ccr-violation-types](#hoalife-ccr-violation-types)
- [hoalife completion](#hoalife-completion)
- [hoalife deficiencies](#hoalife-deficiencies)
- [hoalife deficiency](#hoalife-deficiency)
- [hoalife deficiency create](#hoalife-deficiency-create)
- [hoalife deficiency update](#hoalife-deficiency-update)
- [hoalife escalations](#hoalife-escalations)
- [hoalife help](#hoalife-help)
- [hoalife inspections](#hoalife-inspections)
- [hoalife invoice](#hoalife-invoice)
- [hoalife invoice create](#hoalife-invoice-create)
- [hoalife invoice-item-types](#hoalife-invoice-item-types)
- [hoalife invoices](#hoalife-invoices)
- [hoalife note](#hoalife-note)
- [hoalife note create](#hoalife-note-create)
- [hoalife note delete](#hoalife-note-delete)
- [hoalife note update](#hoalife-note-update)
- [hoalife profile](#hoalife-profile)
- [hoalife profile default](#hoalife-profile-default)
- [hoalife profile list](#hoalife-profile-list)
- [hoalife profile new](#hoalife-profile-new)
- [hoalife profile remove](#hoalife-profile-remove)
- [hoalife profile show](#hoalife-profile-show)
- [hoalife properties](#hoalife-properties)
- [hoalife property](#hoalife-property)
- [hoalife property conversations](#hoalife-property-conversations)
- [hoalife property create](#hoalife-property-create)
- [hoalife property messages](#hoalife-property-messages)
- [hoalife property update](#hoalife-property-update)
- [hoalife property-supplemental-mailing-address](#hoalife-property-supplemental-mailing-address)
- [hoalife property-supplemental-mailing-address create](#hoalife-property-supplemental-mailing-address-create)
- [hoalife property-supplemental-mailing-address update](#hoalife-property-supplemental-mailing-address-update)
- [hoalife property-supplemental-mailing-addresses](#hoalife-property-supplemental-mailing-addresses)
- [hoalife schema](#hoalife-schema)
- [hoalife user-authorization](#hoalife-user-authorization)
- [hoalife user-authorization create](#hoalife-user-authorization-create)
- [hoalife user-authorization update](#hoalife-user-authorization-update)
- [hoalife user-authorizations](#hoalife-user-authorizations)
- [hoalife users](#hoalife-users)
- [hoalife violation](#hoalife-violation)
- [hoalife violation create](#hoalife-violation-create)
- [hoalife violation update](#hoalife-violation-update)
- [hoalife violations](#hoalife-violations)

## hoalife

```text
HOALife API client

Usage:
  hoalife [command]

Available Commands:
  acc-request-form                        Manage individual acc request form resources
  acc-request-forms                       List ACC request forms
  acc-request-requirement                 Manage individual acc request requirement resources
  acc-request-requirements                List ACC request requirements
  acc-request-responses                   List ACC request responses
  acc-request-vote                        Manage individual acc request vote resources
  acc-request-votes                       List ACC request votes
  acc-requests                            List ACC requests
  account                                 Manage individual accounts
  accounts                                List all accessible accounts
  asset                                   Manage individual asset resources
  assets                                  List assets
  ccr-article                             Manage individual ccr article resources
  ccr-articles                            List CCR articles
  ccr-violation-type                      Manage individual ccr violation type resources
  ccr-violation-types                     List CCR violation types
  completion                              Install shell completion
  deficiencies                            List deficiencies
  deficiency                              Manage individual deficiency resources
  escalations                             List escalations
  help                                    Help about any command
  inspections                             List inspections
  invoice                                 Manage invoice creation
  invoice-item-types                      List invoice item types for the current profile account
  invoices                                List invoices for the current profile account
  note                                    Manage individual notes
  profile                                 Manage API profiles or show API info
  properties                              List properties
  property                                Manage individual property resources
  property-supplemental-mailing-address   Manage individual property supplemental mailing address resources
  property-supplemental-mailing-addresses List property supplemental mailing addresses
  schema                                  Discover API resource attribute schemas
  user-authorization                      Manage individual user authorization resources
  user-authorizations                     List user authorizations
  users                                   List users
  violation                               Manage individual violation resources
  violations                              List violations

Flags:
  -h, --help            help for hoalife
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
  -v, --version         version for hoalife

Use "hoalife [command] --help" for more information about a command.
```

## hoalife acc-request-form

```text
Manage individual acc request form resources

Usage:
  hoalife acc-request-form [command]

Available Commands:
  create      Write a resource using API-defined attributes
  update      Write a resource using API-defined attributes

Flags:
  -h, --help   help for acc-request-form

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")

Use "hoalife acc-request-form [command] --help" for more information about a command.
```

## hoalife acc-request-form create

```text
Use --attr-<name> value or repeatable --attr name=value.

Attribute names and types come from the cached create schema. Numbers, booleans,
arrays, objects, and null use JSON syntax; string attributes accept plain text.
For a literal string such as null, use a JSON string: --attr-name '"null"'.
Only supplied attributes are sent; defaults and conditional validation belong to the API.
Run without attributes to list accepted --attr-* flags without writing.
Refresh attribute definitions with `hoalife schema --refresh`.

Usage:
  hoalife acc-request-form create [flags]

Flags:
      --attr string   Resource attribute name=value; repeat for multiple attributes
  -h, --help          help for create

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife acc-request-form update

```text
Use --attr-<name> value or repeatable --attr name=value.

Attribute names and types come from the cached update schema. Numbers, booleans,
arrays, objects, and null use JSON syntax; string attributes accept plain text.
For a literal string such as null, use a JSON string: --attr-name '"null"'.
Only supplied attributes are sent; defaults and conditional validation belong to the API.
Run without attributes to list accepted --attr-* flags without writing.
Refresh attribute definitions with `hoalife schema --refresh`.

Usage:
  hoalife acc-request-form update [flags]

Flags:
      --attr string   Resource attribute name=value; repeat for multiple attributes
  -h, --help          help for update
      --id string     ID of the resource to update (required when attributes are supplied)

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife acc-request-forms

```text
List ACC request forms.

Filter with --filter name=value or --filter-<attribute> value.
For example: --filter-id 2, --filter-id 'gt,2', or --filter-name 'ilike,%Cedar%'.
Attribute names and values pass directly to the API; filters may be repeated.

Usage:
  hoalife acc-request-forms [flags]

Flags:
      --filter string      API query parameter name=value; repeat for multiple filters (e.g. id=gt,4)
  -h, --help               help for acc-request-forms
      --limit string       Pass limit directly to the API (not a local output cap)
      --order string       Pass order directly to the API without validating attributes
      --order-dir string   Pass order_dir directly to the API (e.g. asc or desc)

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife acc-request-requirement

```text
Manage individual acc request requirement resources

Usage:
  hoalife acc-request-requirement [command]

Available Commands:
  create      Write a resource using API-defined attributes
  update      Write a resource using API-defined attributes

Flags:
  -h, --help   help for acc-request-requirement

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")

Use "hoalife acc-request-requirement [command] --help" for more information about a command.
```

## hoalife acc-request-requirement create

```text
Use --attr-<name> value or repeatable --attr name=value.

Attribute names and types come from the cached create schema. Numbers, booleans,
arrays, objects, and null use JSON syntax; string attributes accept plain text.
For a literal string such as null, use a JSON string: --attr-name '"null"'.
Only supplied attributes are sent; defaults and conditional validation belong to the API.
Run without attributes to list accepted --attr-* flags without writing.
Refresh attribute definitions with `hoalife schema --refresh`.

Usage:
  hoalife acc-request-requirement create [flags]

Flags:
      --attr string   Resource attribute name=value; repeat for multiple attributes
  -h, --help          help for create

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife acc-request-requirement update

```text
Use --attr-<name> value or repeatable --attr name=value.

Attribute names and types come from the cached update schema. Numbers, booleans,
arrays, objects, and null use JSON syntax; string attributes accept plain text.
For a literal string such as null, use a JSON string: --attr-name '"null"'.
Only supplied attributes are sent; defaults and conditional validation belong to the API.
Run without attributes to list accepted --attr-* flags without writing.
Refresh attribute definitions with `hoalife schema --refresh`.

Usage:
  hoalife acc-request-requirement update [flags]

Flags:
      --attr string   Resource attribute name=value; repeat for multiple attributes
  -h, --help          help for update
      --id string     ID of the resource to update (required when attributes are supplied)

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife acc-request-requirements

```text
List ACC request requirements.

Filter with --filter name=value or --filter-<attribute> value.
For example: --filter-id 2, --filter-id 'gt,2', or --filter-name 'ilike,%Cedar%'.
Attribute names and values pass directly to the API; filters may be repeated.

Usage:
  hoalife acc-request-requirements [flags]

Flags:
      --filter string      API query parameter name=value; repeat for multiple filters (e.g. id=gt,4)
  -h, --help               help for acc-request-requirements
      --limit string       Pass limit directly to the API (not a local output cap)
      --order string       Pass order directly to the API without validating attributes
      --order-dir string   Pass order_dir directly to the API (e.g. asc or desc)

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife acc-request-responses

```text
List ACC request responses.

Filter with --filter name=value or --filter-<attribute> value.
For example: --filter-id 2, --filter-id 'gt,2', or --filter-name 'ilike,%Cedar%'.
Attribute names and values pass directly to the API; filters may be repeated.

Usage:
  hoalife acc-request-responses [flags]

Flags:
      --filter string      API query parameter name=value; repeat for multiple filters (e.g. id=gt,4)
  -h, --help               help for acc-request-responses
      --limit string       Pass limit directly to the API (not a local output cap)
      --order string       Pass order directly to the API without validating attributes
      --order-dir string   Pass order_dir directly to the API (e.g. asc or desc)

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife acc-request-vote

```text
Manage individual acc request vote resources

Usage:
  hoalife acc-request-vote [command]

Available Commands:
  create      Write a resource using API-defined attributes

Flags:
  -h, --help   help for acc-request-vote

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")

Use "hoalife acc-request-vote [command] --help" for more information about a command.
```

## hoalife acc-request-vote create

```text
Use --attr-<name> value or repeatable --attr name=value.

Attribute names and types come from the cached create schema. Numbers, booleans,
arrays, objects, and null use JSON syntax; string attributes accept plain text.
For a literal string such as null, use a JSON string: --attr-name '"null"'.
Only supplied attributes are sent; defaults and conditional validation belong to the API.
Run without attributes to list accepted --attr-* flags without writing.
Refresh attribute definitions with `hoalife schema --refresh`.

Usage:
  hoalife acc-request-vote create [flags]

Flags:
      --attr string   Resource attribute name=value; repeat for multiple attributes
  -h, --help          help for create

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife acc-request-votes

```text
List ACC request votes.

Filter with --filter name=value or --filter-<attribute> value.
For example: --filter-id 2, --filter-id 'gt,2', or --filter-name 'ilike,%Cedar%'.
Attribute names and values pass directly to the API; filters may be repeated.

Usage:
  hoalife acc-request-votes [flags]

Flags:
      --filter string      API query parameter name=value; repeat for multiple filters (e.g. id=gt,4)
  -h, --help               help for acc-request-votes
      --limit string       Pass limit directly to the API (not a local output cap)
      --order string       Pass order directly to the API without validating attributes
      --order-dir string   Pass order_dir directly to the API (e.g. asc or desc)

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife acc-requests

```text
List ACC requests.

Filter with --filter name=value or --filter-<attribute> value.
For example: --filter-id 2, --filter-id 'gt,2', or --filter-name 'ilike,%Cedar%'.
Attribute names and values pass directly to the API; filters may be repeated.

Usage:
  hoalife acc-requests [flags]

Flags:
      --filter string      API query parameter name=value; repeat for multiple filters (e.g. id=gt,4)
  -h, --help               help for acc-requests
      --limit string       Pass limit directly to the API (not a local output cap)
      --order string       Pass order directly to the API without validating attributes
      --order-dir string   Pass order_dir directly to the API (e.g. asc or desc)

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife account

```text
Manage individual accounts

Usage:
  hoalife account [command]

Available Commands:
  create      Create an account
  update      Update an account

Flags:
  -h, --help   help for account

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")

Use "hoalife account [command] --help" for more information about a command.
```

## hoalife account create

```text
Use --attr-<name> value or repeatable --attr name=value.

Attribute names and types come from the cached create schema. Numbers, booleans,
arrays, objects, and null use JSON syntax; string attributes accept plain text.
For a literal string such as null, use a JSON string: --attr-name '"null"'.
Only supplied attributes are sent; defaults and conditional validation belong to the API.
Run without attributes to list accepted --attr-* flags without writing.
Refresh attribute definitions with `hoalife schema --refresh`.

Usage:
  hoalife account create [flags]

Examples:
  hoalife account create --attr-name foo
  hoalife account create --attr-name "Cedar HOA" --attr-parent_id 42 --output json

Flags:
      --attr string   Resource attribute name=value; repeat for multiple attributes
  -h, --help          help for create

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife account update

```text
Use --attr-<name> value or repeatable --attr name=value.

Attribute names and types come from the cached update schema. Numbers, booleans,
arrays, objects, and null use JSON syntax; string attributes accept plain text.
For a literal string such as null, use a JSON string: --attr-name '"null"'.
Only supplied attributes are sent; defaults and conditional validation belong to the API.
Run without attributes to list accepted --attr-* flags without writing.
Refresh attribute definitions with `hoalife schema --refresh`.

Usage:
  hoalife account update [flags]

Examples:
  hoalife account update --id 42 --attr-name foo
  hoalife account update --id 42 --attr-external_id null --output json

Flags:
      --attr string   Resource attribute name=value; repeat for multiple attributes
  -h, --help          help for update
      --id string     ID of the resource to update (required when attributes are supplied)

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife accounts

```text
List all accessible accounts.

Filter with --filter name=value or --filter-<attribute> value.
For example: --filter-id 2, --filter-id 'gt,2', or --filter-name 'ilike,%Cedar%'.
Attribute names and values pass directly to the API; filters may be repeated.

Usage:
  hoalife accounts [flags]

Flags:
      --filter string      API query parameter name=value; repeat for multiple filters (e.g. id=gt,4)
  -h, --help               help for accounts
      --limit string       Pass limit directly to the API (not a local output cap)
      --order string       Pass order directly to the API without validating attributes
      --order-dir string   Pass order_dir directly to the API (e.g. asc or desc)

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife asset

```text
Manage individual asset resources

Usage:
  hoalife asset [command]

Available Commands:
  create      Write a resource using API-defined attributes
  update      Write a resource using API-defined attributes

Flags:
  -h, --help   help for asset

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")

Use "hoalife asset [command] --help" for more information about a command.
```

## hoalife asset create

```text
Use --attr-<name> value or repeatable --attr name=value.

Attribute names and types come from the cached create schema. Numbers, booleans,
arrays, objects, and null use JSON syntax; string attributes accept plain text.
For a literal string such as null, use a JSON string: --attr-name '"null"'.
Only supplied attributes are sent; defaults and conditional validation belong to the API.
Run without attributes to list accepted --attr-* flags without writing.
Refresh attribute definitions with `hoalife schema --refresh`.

Usage:
  hoalife asset create [flags]

Flags:
      --attr string   Resource attribute name=value; repeat for multiple attributes
  -h, --help          help for create

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife asset update

```text
Use --attr-<name> value or repeatable --attr name=value.

Attribute names and types come from the cached update schema. Numbers, booleans,
arrays, objects, and null use JSON syntax; string attributes accept plain text.
For a literal string such as null, use a JSON string: --attr-name '"null"'.
Only supplied attributes are sent; defaults and conditional validation belong to the API.
Run without attributes to list accepted --attr-* flags without writing.
Refresh attribute definitions with `hoalife schema --refresh`.

Usage:
  hoalife asset update [flags]

Flags:
      --attr string   Resource attribute name=value; repeat for multiple attributes
  -h, --help          help for update
      --id string     ID of the resource to update (required when attributes are supplied)

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife assets

```text
List assets.

Filter with --filter name=value or --filter-<attribute> value.
For example: --filter-id 2, --filter-id 'gt,2', or --filter-name 'ilike,%Cedar%'.
Attribute names and values pass directly to the API; filters may be repeated.

Usage:
  hoalife assets [flags]

Flags:
      --filter string      API query parameter name=value; repeat for multiple filters (e.g. id=gt,4)
  -h, --help               help for assets
      --limit string       Pass limit directly to the API (not a local output cap)
      --order string       Pass order directly to the API without validating attributes
      --order-dir string   Pass order_dir directly to the API (e.g. asc or desc)

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife ccr-article

```text
Manage individual ccr article resources

Usage:
  hoalife ccr-article [command]

Available Commands:
  create      Write a resource using API-defined attributes
  update      Write a resource using API-defined attributes

Flags:
  -h, --help   help for ccr-article

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")

Use "hoalife ccr-article [command] --help" for more information about a command.
```

## hoalife ccr-article create

```text
Use --attr-<name> value or repeatable --attr name=value.

Attribute names and types come from the cached create schema. Numbers, booleans,
arrays, objects, and null use JSON syntax; string attributes accept plain text.
For a literal string such as null, use a JSON string: --attr-name '"null"'.
Only supplied attributes are sent; defaults and conditional validation belong to the API.
Run without attributes to list accepted --attr-* flags without writing.
Refresh attribute definitions with `hoalife schema --refresh`.

Usage:
  hoalife ccr-article create [flags]

Flags:
      --attr string   Resource attribute name=value; repeat for multiple attributes
  -h, --help          help for create

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife ccr-article update

```text
Use --attr-<name> value or repeatable --attr name=value.

Attribute names and types come from the cached update schema. Numbers, booleans,
arrays, objects, and null use JSON syntax; string attributes accept plain text.
For a literal string such as null, use a JSON string: --attr-name '"null"'.
Only supplied attributes are sent; defaults and conditional validation belong to the API.
Run without attributes to list accepted --attr-* flags without writing.
Refresh attribute definitions with `hoalife schema --refresh`.

Usage:
  hoalife ccr-article update [flags]

Flags:
      --attr string   Resource attribute name=value; repeat for multiple attributes
  -h, --help          help for update
      --id string     ID of the resource to update (required when attributes are supplied)

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife ccr-articles

```text
List CCR articles.

Filter with --filter name=value or --filter-<attribute> value.
For example: --filter-id 2, --filter-id 'gt,2', or --filter-name 'ilike,%Cedar%'.
Attribute names and values pass directly to the API; filters may be repeated.

Usage:
  hoalife ccr-articles [flags]

Flags:
      --filter string      API query parameter name=value; repeat for multiple filters (e.g. id=gt,4)
  -h, --help               help for ccr-articles
      --limit string       Pass limit directly to the API (not a local output cap)
      --order string       Pass order directly to the API without validating attributes
      --order-dir string   Pass order_dir directly to the API (e.g. asc or desc)

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife ccr-violation-type

```text
Manage individual ccr violation type resources

Usage:
  hoalife ccr-violation-type [command]

Available Commands:
  create      Write a resource using API-defined attributes
  update      Write a resource using API-defined attributes

Flags:
  -h, --help   help for ccr-violation-type

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")

Use "hoalife ccr-violation-type [command] --help" for more information about a command.
```

## hoalife ccr-violation-type create

```text
Use --attr-<name> value or repeatable --attr name=value.

Attribute names and types come from the cached create schema. Numbers, booleans,
arrays, objects, and null use JSON syntax; string attributes accept plain text.
For a literal string such as null, use a JSON string: --attr-name '"null"'.
Only supplied attributes are sent; defaults and conditional validation belong to the API.
Run without attributes to list accepted --attr-* flags without writing.
Refresh attribute definitions with `hoalife schema --refresh`.

Usage:
  hoalife ccr-violation-type create [flags]

Flags:
      --attr string   Resource attribute name=value; repeat for multiple attributes
  -h, --help          help for create

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife ccr-violation-type update

```text
Use --attr-<name> value or repeatable --attr name=value.

Attribute names and types come from the cached update schema. Numbers, booleans,
arrays, objects, and null use JSON syntax; string attributes accept plain text.
For a literal string such as null, use a JSON string: --attr-name '"null"'.
Only supplied attributes are sent; defaults and conditional validation belong to the API.
Run without attributes to list accepted --attr-* flags without writing.
Refresh attribute definitions with `hoalife schema --refresh`.

Usage:
  hoalife ccr-violation-type update [flags]

Flags:
      --attr string   Resource attribute name=value; repeat for multiple attributes
  -h, --help          help for update
      --id string     ID of the resource to update (required when attributes are supplied)

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife ccr-violation-types

```text
List CCR violation types.

Filter with --filter name=value or --filter-<attribute> value.
For example: --filter-id 2, --filter-id 'gt,2', or --filter-name 'ilike,%Cedar%'.
Attribute names and values pass directly to the API; filters may be repeated.

Usage:
  hoalife ccr-violation-types [flags]

Flags:
      --filter string      API query parameter name=value; repeat for multiple filters (e.g. id=gt,4)
  -h, --help               help for ccr-violation-types
      --limit string       Pass limit directly to the API (not a local output cap)
      --order string       Pass order directly to the API without validating attributes
      --order-dir string   Pass order_dir directly to the API (e.g. asc or desc)

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife completion

```text
Install shell completion for the detected shell, or specify bash, zsh, fish, or powershell.

Usage:
  hoalife completion [bash|zsh|fish|powershell] [flags]

Flags:
  -h, --help   help for completion

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife deficiencies

```text
List deficiencies.

Filter with --filter name=value or --filter-<attribute> value.
For example: --filter-id 2, --filter-id 'gt,2', or --filter-name 'ilike,%Cedar%'.
Attribute names and values pass directly to the API; filters may be repeated.

Usage:
  hoalife deficiencies [flags]

Flags:
      --filter string      API query parameter name=value; repeat for multiple filters (e.g. id=gt,4)
  -h, --help               help for deficiencies
      --limit string       Pass limit directly to the API (not a local output cap)
      --order string       Pass order directly to the API without validating attributes
      --order-dir string   Pass order_dir directly to the API (e.g. asc or desc)

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife deficiency

```text
Manage individual deficiency resources

Usage:
  hoalife deficiency [command]

Available Commands:
  create      Write a resource using API-defined attributes
  update      Write a resource using API-defined attributes

Flags:
  -h, --help   help for deficiency

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")

Use "hoalife deficiency [command] --help" for more information about a command.
```

## hoalife deficiency create

```text
Use --attr-<name> value or repeatable --attr name=value.

Attribute names and types come from the cached create schema. Numbers, booleans,
arrays, objects, and null use JSON syntax; string attributes accept plain text.
For a literal string such as null, use a JSON string: --attr-name '"null"'.
Only supplied attributes are sent; defaults and conditional validation belong to the API.
Run without attributes to list accepted --attr-* flags without writing.
Refresh attribute definitions with `hoalife schema --refresh`.

Usage:
  hoalife deficiency create [flags]

Flags:
      --attr string   Resource attribute name=value; repeat for multiple attributes
  -h, --help          help for create

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife deficiency update

```text
Use --attr-<name> value or repeatable --attr name=value.

Attribute names and types come from the cached update schema. Numbers, booleans,
arrays, objects, and null use JSON syntax; string attributes accept plain text.
For a literal string such as null, use a JSON string: --attr-name '"null"'.
Only supplied attributes are sent; defaults and conditional validation belong to the API.
Run without attributes to list accepted --attr-* flags without writing.
Refresh attribute definitions with `hoalife schema --refresh`.

Usage:
  hoalife deficiency update [flags]

Flags:
      --attr string   Resource attribute name=value; repeat for multiple attributes
  -h, --help          help for update
      --id string     ID of the resource to update (required when attributes are supplied)

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife escalations

```text
List escalations.

Filter with --filter name=value or --filter-<attribute> value.
For example: --filter-id 2, --filter-id 'gt,2', or --filter-name 'ilike,%Cedar%'.
Attribute names and values pass directly to the API; filters may be repeated.

Usage:
  hoalife escalations [flags]

Flags:
      --filter string      API query parameter name=value; repeat for multiple filters (e.g. id=gt,4)
  -h, --help               help for escalations
      --limit string       Pass limit directly to the API (not a local output cap)
      --order string       Pass order directly to the API without validating attributes
      --order-dir string   Pass order_dir directly to the API (e.g. asc or desc)

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife help

```text
Help provides help for any command in the application.
Simply type hoalife help [path to command] for full details.

Usage:
  hoalife help [command] [flags]

Flags:
  -h, --help   help for help

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife inspections

```text
List inspections.

Filter with --filter name=value or --filter-<attribute> value.
For example: --filter-id 2, --filter-id 'gt,2', or --filter-name 'ilike,%Cedar%'.
Attribute names and values pass directly to the API; filters may be repeated.

Usage:
  hoalife inspections [flags]

Flags:
      --filter string      API query parameter name=value; repeat for multiple filters (e.g. id=gt,4)
  -h, --help               help for inspections
      --limit string       Pass limit directly to the API (not a local output cap)
      --order string       Pass order directly to the API without validating attributes
      --order-dir string   Pass order_dir directly to the API (e.g. asc or desc)

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife invoice

```text
Manage invoice creation

Usage:
  hoalife invoice [command]

Available Commands:
  create      Request invoice creation for the current profile account

Flags:
  -h, --help   help for invoice

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")

Use "hoalife invoice [command] --help" for more information about a command.
```

## hoalife invoice create

```text
Use --attr-<name> value or repeatable --attr name=value.

Attribute names and types come from the cached create schema. Numbers, booleans,
arrays, objects, and null use JSON syntax; string attributes accept plain text.
For a literal string such as null, use a JSON string: --attr-name '"null"'.
Only supplied attributes are sent; defaults and conditional validation belong to the API.
Run without attributes to list accepted --attr-* flags without writing.
Refresh attribute definitions with `hoalife schema --refresh`.

Invoice creation is asynchronous. Success acknowledges acceptance, not a created invoice.
Use `hoalife invoices` to find the invoice after the accounting integration finishes.

Usage:
  hoalife invoice create [flags]

Examples:
  hoalife invoice create --attr-property_id 456 --attr-description "Monthly assessment" --attr-amount_cents 12500 --attr-item_type_id item-789 --attr-transaction_date 2026-10-26 --attr-due_date 2026-11-26

Flags:
      --attr string   Resource attribute name=value; repeat for multiple attributes
  -h, --help          help for create

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife invoice-item-types

```text
List invoice item types for the current profile account.

Filter with --filter name=value or --filter-<attribute> value.
For example: --filter-id 2, --filter-id 'gt,2', or --filter-name 'ilike,%Cedar%'.
Attribute names and values pass directly to the API; filters may be repeated.

Usage:
  hoalife invoice-item-types [flags]

Flags:
      --filter string      API query parameter name=value; repeat for multiple filters (e.g. id=gt,4)
  -h, --help               help for invoice-item-types
      --limit string       Pass limit directly to the API (not a local output cap)
      --order string       Pass order directly to the API without validating attributes
      --order-dir string   Pass order_dir directly to the API (e.g. asc or desc)

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife invoices

```text
List invoices for the current profile account.

Filter with --filter name=value or --filter-<attribute> value.
For example: --filter-id 2, --filter-id 'gt,2', or --filter-name 'ilike,%Cedar%'.
Attribute names and values pass directly to the API; filters may be repeated.

Usage:
  hoalife invoices [flags]

Flags:
      --filter string      API query parameter name=value; repeat for multiple filters (e.g. id=gt,4)
  -h, --help               help for invoices
      --limit string       Pass limit directly to the API (not a local output cap)
      --order string       Pass order directly to the API without validating attributes
      --order-dir string   Pass order_dir directly to the API (e.g. asc or desc)

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife note

```text
Manage individual notes

Usage:
  hoalife note [command]

Available Commands:
  create      Create a note
  delete      Request deletion of a note
  update      Update a note

Flags:
  -h, --help   help for note

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")

Use "hoalife note [command] --help" for more information about a command.
```

## hoalife note create

```text
Use --attr-<name> value or repeatable --attr name=value.

Attribute names and types come from the cached create schema. Numbers, booleans,
arrays, objects, and null use JSON syntax; string attributes accept plain text.
For a literal string such as null, use a JSON string: --attr-name '"null"'.
Only supplied attributes are sent; defaults and conditional validation belong to the API.
Run without attributes to list accepted --attr-* flags without writing.
Refresh attribute definitions with `hoalife schema --refresh`.

Usage:
  hoalife note create [flags]

Examples:
  hoalife note create --attr-body_text hello --attr-attached_to_type acc_request --attr-attached_to_id 42

Flags:
      --attr string   Resource attribute name=value; repeat for multiple attributes
  -h, --help          help for create

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife note delete

```text
Request deletion by ID. Deletion runs asynchronously; success means the request was accepted.

Usage:
  hoalife note delete [flags]

Examples:
  hoalife note delete --id 4

Flags:
  -h, --help        help for delete
      --id string   ID of the resource to delete (required)

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife note update

```text
Use --attr-<name> value or repeatable --attr name=value.

Attribute names and types come from the cached update schema. Numbers, booleans,
arrays, objects, and null use JSON syntax; string attributes accept plain text.
For a literal string such as null, use a JSON string: --attr-name '"null"'.
Only supplied attributes are sent; defaults and conditional validation belong to the API.
Run without attributes to list accepted --attr-* flags without writing.
Refresh attribute definitions with `hoalife schema --refresh`.

Usage:
  hoalife note update [flags]

Examples:
  hoalife note update --id 4 --attr-pinned true

Flags:
      --attr string   Resource attribute name=value; repeat for multiple attributes
  -h, --help          help for update
      --id string     ID of the resource to update (required when attributes are supplied)

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife profile

```text
Manage API profiles or show API info

Usage:
  hoalife profile [flags]
  hoalife profile [command]

Available Commands:
  default     Set the default profile
  list        List profile names
  new         Create a profile
  remove      Remove a profile
  show        Show the default profile

Flags:
  -h, --help   help for profile

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")

Use "hoalife profile [command] --help" for more information about a command.
```

## hoalife profile default

```text
Set the default profile

Usage:
  hoalife profile default [flags]

Flags:
  -h, --help          help for default
      --name string   Profile name

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife profile list

```text
List profile names

Usage:
  hoalife profile list [flags]

Flags:
  -h, --help   help for list

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife profile new

```text
Create a profile

Usage:
  hoalife profile new [flags]

Flags:
      --api-key string          HOALife API key
  -h, --help                    help for new
      --name string             Profile name
      --signing-secret string   HOALife response signing secret

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife profile remove

```text
Remove a profile

Usage:
  hoalife profile remove [flags]

Flags:
  -h, --help          help for remove
      --name string   Profile name

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife profile show

```text
Show the default profile

Usage:
  hoalife profile show [flags]

Flags:
  -h, --help   help for show

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife properties

```text
List properties.

Filter with --filter name=value or --filter-<attribute> value.
For example: --filter-id 2, --filter-id 'gt,2', or --filter-name 'ilike,%Cedar%'.
Attribute names and values pass directly to the API; filters may be repeated.

Usage:
  hoalife properties [flags]

Flags:
      --filter string      API query parameter name=value; repeat for multiple filters (e.g. id=gt,4)
  -h, --help               help for properties
      --limit string       Pass limit directly to the API (not a local output cap)
      --order string       Pass order directly to the API without validating attributes
      --order-dir string   Pass order_dir directly to the API (e.g. asc or desc)

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife property

```text
Manage individual property resources

Usage:
  hoalife property [command]

Available Commands:
  conversations List conversation threads for a property
  create        Write a resource using API-defined attributes
  messages      Read messages in a property's conversation
  update        Write a resource using API-defined attributes

Flags:
  -h, --help   help for property

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")

Use "hoalife property [command] --help" for more information about a command.
```

## hoalife property conversations

```text
List conversation threads for a property.

Filter with --filter name=value or --filter-<attribute> value.
For example: --filter-id 2, --filter-id 'gt,2', or --filter-name 'ilike,%Cedar%'.
Attribute names and values pass directly to the API; filters may be repeated.

Returns thread metadata for --id, the property ID. Message contents are separate.
The API orders threads by most recently updated first; query flags are passed through.

Usage:
  hoalife property conversations [flags]

Examples:
  hoalife property conversations --id 456
  hoalife property conversations --id 456 --output json

Flags:
      --filter string      API query parameter name=value; repeat for multiple filters (e.g. id=gt,4)
  -h, --help               help for conversations
      --id string          Property ID whose conversations to list (required)
      --limit string       Pass limit directly to the API (not a local output cap)
      --order string       Pass order directly to the API without validating attributes
      --order-dir string   Pass order_dir directly to the API (e.g. asc or desc)

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife property create

```text
Use --attr-<name> value or repeatable --attr name=value.

Attribute names and types come from the cached create schema. Numbers, booleans,
arrays, objects, and null use JSON syntax; string attributes accept plain text.
For a literal string such as null, use a JSON string: --attr-name '"null"'.
Only supplied attributes are sent; defaults and conditional validation belong to the API.
Run without attributes to list accepted --attr-* flags without writing.
Refresh attribute definitions with `hoalife schema --refresh`.

Usage:
  hoalife property create [flags]

Flags:
      --attr string   Resource attribute name=value; repeat for multiple attributes
  -h, --help          help for create

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife property messages

```text
Read messages in a property's conversation.

Filter with --filter name=value or --filter-<attribute> value.
For example: --filter-id 2, --filter-id 'gt,2', or --filter-name 'ilike,%Cedar%'.
Attribute names and values pass directly to the API; filters may be repeated.

Reads all pages of messages, oldest first. Message bodies are plain text.
The API currently supports page selection but not filtering or custom ordering;
shared query flags are passed through unchanged.

Usage:
  hoalife property messages [flags]

Examples:
  hoalife property messages --id 456 --conversation-id 125
  hoalife property messages --id 456 --conversation-id 125 --output json

Flags:
      --conversation-id string   Conversation ID whose messages to read (required)
      --filter string            API query parameter name=value; repeat for multiple filters (e.g. id=gt,4)
  -h, --help                     help for messages
      --id string                Property ID containing the conversation (required)
      --limit string             Pass limit directly to the API (not a local output cap)
      --order string             Pass order directly to the API without validating attributes
      --order-dir string         Pass order_dir directly to the API (e.g. asc or desc)

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife property update

```text
Use --attr-<name> value or repeatable --attr name=value.

Attribute names and types come from the cached update schema. Numbers, booleans,
arrays, objects, and null use JSON syntax; string attributes accept plain text.
For a literal string such as null, use a JSON string: --attr-name '"null"'.
Only supplied attributes are sent; defaults and conditional validation belong to the API.
Run without attributes to list accepted --attr-* flags without writing.
Refresh attribute definitions with `hoalife schema --refresh`.

Usage:
  hoalife property update [flags]

Flags:
      --attr string   Resource attribute name=value; repeat for multiple attributes
  -h, --help          help for update
      --id string     ID of the resource to update (required when attributes are supplied)

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife property-supplemental-mailing-address

```text
Manage individual property supplemental mailing address resources

Usage:
  hoalife property-supplemental-mailing-address [command]

Available Commands:
  create      Write a resource using API-defined attributes
  update      Write a resource using API-defined attributes

Flags:
  -h, --help   help for property-supplemental-mailing-address

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")

Use "hoalife property-supplemental-mailing-address [command] --help" for more information about a command.
```

## hoalife property-supplemental-mailing-address create

```text
Use --attr-<name> value or repeatable --attr name=value.

Attribute names and types come from the cached create schema. Numbers, booleans,
arrays, objects, and null use JSON syntax; string attributes accept plain text.
For a literal string such as null, use a JSON string: --attr-name '"null"'.
Only supplied attributes are sent; defaults and conditional validation belong to the API.
Run without attributes to list accepted --attr-* flags without writing.
Refresh attribute definitions with `hoalife schema --refresh`.

Usage:
  hoalife property-supplemental-mailing-address create [flags]

Flags:
      --attr string   Resource attribute name=value; repeat for multiple attributes
  -h, --help          help for create

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife property-supplemental-mailing-address update

```text
Use --attr-<name> value or repeatable --attr name=value.

Attribute names and types come from the cached update schema. Numbers, booleans,
arrays, objects, and null use JSON syntax; string attributes accept plain text.
For a literal string such as null, use a JSON string: --attr-name '"null"'.
Only supplied attributes are sent; defaults and conditional validation belong to the API.
Run without attributes to list accepted --attr-* flags without writing.
Refresh attribute definitions with `hoalife schema --refresh`.

Usage:
  hoalife property-supplemental-mailing-address update [flags]

Flags:
      --attr string   Resource attribute name=value; repeat for multiple attributes
  -h, --help          help for update
      --id string     ID of the resource to update (required when attributes are supplied)

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife property-supplemental-mailing-addresses

```text
List property supplemental mailing addresses.

Filter with --filter name=value or --filter-<attribute> value.
For example: --filter-id 2, --filter-id 'gt,2', or --filter-name 'ilike,%Cedar%'.
Attribute names and values pass directly to the API; filters may be repeated.

Usage:
  hoalife property-supplemental-mailing-addresses [flags]

Flags:
      --filter string      API query parameter name=value; repeat for multiple filters (e.g. id=gt,4)
  -h, --help               help for property-supplemental-mailing-addresses
      --limit string       Pass limit directly to the API (not a local output cap)
      --order string       Pass order directly to the API without validating attributes
      --order-dir string   Pass order_dir directly to the API (e.g. asc or desc)

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife schema

```text
Discover API resource attribute schemas.

Without a resource, JSON output is the full JSON:API catalog and text output lists resources and operations.
With a resource, output contains its operation schemas; --operation selects one JSON Schema.
Catalogs are cached per API base URL for 24 hours. --refresh always fetches a new catalog.
A fresh cache can be read offline; fetching requires a profile. Resource names may use underscores or hyphens.

Usage:
  hoalife schema [resource] [flags]

Examples:
  hoalife schema --output json
  hoalife schema properties --operation create --output json
  hoalife schema acc-request-votes --operation read
  hoalife schema --refresh

Flags:
  -h, --help               help for schema
      --operation string   Select read, create, or update attributes (requires a resource)
      --refresh            Fetch the schema even when a fresh cached catalog exists

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife user-authorization

```text
Manage individual user authorization resources

Usage:
  hoalife user-authorization [command]

Available Commands:
  create      Write a resource using API-defined attributes
  update      Write a resource using API-defined attributes

Flags:
  -h, --help   help for user-authorization

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")

Use "hoalife user-authorization [command] --help" for more information about a command.
```

## hoalife user-authorization create

```text
Use --attr-<name> value or repeatable --attr name=value.

Attribute names and types come from the cached create schema. Numbers, booleans,
arrays, objects, and null use JSON syntax; string attributes accept plain text.
For a literal string such as null, use a JSON string: --attr-name '"null"'.
Only supplied attributes are sent; defaults and conditional validation belong to the API.
Run without attributes to list accepted --attr-* flags without writing.
Refresh attribute definitions with `hoalife schema --refresh`.

Usage:
  hoalife user-authorization create [flags]

Flags:
      --attr string   Resource attribute name=value; repeat for multiple attributes
  -h, --help          help for create

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife user-authorization update

```text
Use --attr-<name> value or repeatable --attr name=value.

Attribute names and types come from the cached update schema. Numbers, booleans,
arrays, objects, and null use JSON syntax; string attributes accept plain text.
For a literal string such as null, use a JSON string: --attr-name '"null"'.
Only supplied attributes are sent; defaults and conditional validation belong to the API.
Run without attributes to list accepted --attr-* flags without writing.
Refresh attribute definitions with `hoalife schema --refresh`.

Usage:
  hoalife user-authorization update [flags]

Flags:
      --attr string   Resource attribute name=value; repeat for multiple attributes
  -h, --help          help for update
      --id string     ID of the resource to update (required when attributes are supplied)

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife user-authorizations

```text
List user authorizations.

Filter with --filter name=value or --filter-<attribute> value.
For example: --filter-id 2, --filter-id 'gt,2', or --filter-name 'ilike,%Cedar%'.
Attribute names and values pass directly to the API; filters may be repeated.

Usage:
  hoalife user-authorizations [flags]

Flags:
      --filter string      API query parameter name=value; repeat for multiple filters (e.g. id=gt,4)
  -h, --help               help for user-authorizations
      --limit string       Pass limit directly to the API (not a local output cap)
      --order string       Pass order directly to the API without validating attributes
      --order-dir string   Pass order_dir directly to the API (e.g. asc or desc)

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife users

```text
List users.

Filter with --filter name=value or --filter-<attribute> value.
For example: --filter-id 2, --filter-id 'gt,2', or --filter-name 'ilike,%Cedar%'.
Attribute names and values pass directly to the API; filters may be repeated.

Usage:
  hoalife users [flags]

Flags:
      --filter string      API query parameter name=value; repeat for multiple filters (e.g. id=gt,4)
  -h, --help               help for users
      --limit string       Pass limit directly to the API (not a local output cap)
      --order string       Pass order directly to the API without validating attributes
      --order-dir string   Pass order_dir directly to the API (e.g. asc or desc)

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife violation

```text
Manage individual violation resources

Usage:
  hoalife violation [command]

Available Commands:
  create      Write a resource using API-defined attributes
  update      Write a resource using API-defined attributes

Flags:
  -h, --help   help for violation

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")

Use "hoalife violation [command] --help" for more information about a command.
```

## hoalife violation create

```text
Use --attr-<name> value or repeatable --attr name=value.

Attribute names and types come from the cached create schema. Numbers, booleans,
arrays, objects, and null use JSON syntax; string attributes accept plain text.
For a literal string such as null, use a JSON string: --attr-name '"null"'.
Only supplied attributes are sent; defaults and conditional validation belong to the API.
Run without attributes to list accepted --attr-* flags without writing.
Refresh attribute definitions with `hoalife schema --refresh`.

Usage:
  hoalife violation create [flags]

Flags:
      --attr string   Resource attribute name=value; repeat for multiple attributes
  -h, --help          help for create

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife violation update

```text
Use --attr-<name> value or repeatable --attr name=value.

Attribute names and types come from the cached update schema. Numbers, booleans,
arrays, objects, and null use JSON syntax; string attributes accept plain text.
For a literal string such as null, use a JSON string: --attr-name '"null"'.
Only supplied attributes are sent; defaults and conditional validation belong to the API.
Run without attributes to list accepted --attr-* flags without writing.
Refresh attribute definitions with `hoalife schema --refresh`.

Usage:
  hoalife violation update [flags]

Flags:
      --attr string   Resource attribute name=value; repeat for multiple attributes
  -h, --help          help for update
      --id string     ID of the resource to update (required when attributes are supplied)

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```

## hoalife violations

```text
List violations.

Filter with --filter name=value or --filter-<attribute> value.
For example: --filter-id 2, --filter-id 'gt,2', or --filter-name 'ilike,%Cedar%'.
Attribute names and values pass directly to the API; filters may be repeated.

Usage:
  hoalife violations [flags]

Flags:
      --filter string      API query parameter name=value; repeat for multiple filters (e.g. id=gt,4)
  -h, --help               help for violations
      --limit string       Pass limit directly to the API (not a local output cap)
      --order string       Pass order directly to the API without validating attributes
      --order-dir string   Pass order_dir directly to the API (e.g. asc or desc)

Global Flags:
      --no-input        Disable prompts and browser authorization
      --output string   Output format: text or json (HOALIFE_OUTPUT; json disables interaction) (default "text")
```
