# User Guide

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [Configuration](#configuration)

## Installation

To install the resource, download the [latest release], extract it, and place
it into your server's `resources` directory.

Next, enter these commands into a `.cfg` file that runs on your server's startup
— typically `server.cfg`:

```
ensure d4_playerdata
add_ace resource.d4_playerdata command.add_principal allow
add_ace resource.d4_playerdata command.remove_principal allow
```

This resource registers ACE principals for players; these commands grant it
permission to add and remove those principals.

## Usage

If you are installing this resource as a dependency, no additional setup is
required. Feel free to configure it as you see fit, and read the rest of the
documentation.

For users, this resource provides **[Commands]** to manage IDs.

For developers, see the API references in the docs **[README.md]** file.

## Configuration

This resource uses [Convars] for its configuration. These can be changed live
without restarting the resource. Below are the available convars.

### Use Persist IDs

```
set d4_playerdata:usePersistIds true
```

Whether to enforce Persist IDs when players join.

- Type: `boolean`
- Default: `true`

### Allow Duplicate Users

```
set d4_playerdata:allowDuplicateUsers false
```

Whether to allow multiple players with the same User ID to join the server
simultaneously. Useful when using 2 clients with `-cl2`.

- Type: `boolean`
- Default: `false`

### Migrate Multiple Users

```
set d4_playerdata:migrateMultipleUsers false
```

Whether to migrate all Data IDs into one User ID when multiple User IDs are
linked to a joining player. Data IDs and identifiers will be permanently moved
to the oldest linked User ID, and the other User IDs will be deleted.

- Type: `boolean`
- Default: `false`

### Required Identifiers

```
set d4_playerdata:requiredIdentifiers []
```

A set of [identifier types] to require. Players missing a required identifier
type will be rejected during connection.

- Type: `string[]`
- Default: `[]`

### Ignored Identifiers

```
set d4_playerdata:ignoredIdentifiers []
```

A set of [identifier types] to completely ignore when identifying players.
`ip` is **always** included in this set.

- Type: `string[]`
- Default: `[]`

[commands]: ./commands.md
[readme.md]: ./README.md
[latest release]: https://github.com/D4isDAVID/d4_playerdata/releases/latest
[convars]: https://docs.fivem.net/docs/scripting-reference/convars/
[identifier types]: https://docs.fivem.net/docs/scripting-reference/runtimes/lua/functions/GetPlayerIdentifiers/#identifier-types
