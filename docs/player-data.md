# Player Data

> TL;DR:
> This resource assigns players a persistent User ID linked to player
> identifiers, and provides Data IDs for data similar to characters or save
> files. Use User IDs for identity, and Data IDs for gameplay state.
> In addition, this resource provides an optional Persist ID linked to player
> tokens, identifiers, and User IDs, for effective bans.

The main functionality of this resource is identifying players and assigning
them persistent User and Data IDs. This document explains the purpose and
behavior of these IDs.

Please read the following links for additional context:
- [Identifier Types](https://docs.fivem.net/docs/scripting-reference/runtimes/lua/functions/GetPlayerIdentifiers/#identifier-types)
- [Basic Aces & Principals overview/guide](https://forum.cfx.re/t/90917)
- [`GetPlayerToken`](https://docs.fivem.net/natives/?_0x54C06897)

## Table of Contents

- [User IDs](#user-ids)
- [Data IDs](#data-ids)
- [Persist IDs](#persist-ids)

## User IDs

To save player data across logins and restarts, FiveM provides us with player
identifiers. Most frameworks use a single identifier; typically `license2` or
`license`, based on availability. This can pose a problem, however, as
`license2` is not always available, and `license` is prone to changes. This can
lead to some players losing access to their data, or not being able to join at
all. The other identifiers aren't reliable either, as they might require players
to play using a specific platform, or link an external account, locking out
certain players.

This resource solves this by using *all* available identifiers, except for `ip`,
as it is not specific enough. These identifiers will be linked to a User ID. The
User ID is an integer value assigned to players, intended for developers to use
as a replacement for identifiers. This allows the resource to reliably identify
the player, while your resources handle the rest.

When a player joins the server, this resource collects their identifiers. If a
linked User ID is found, then it is assigned to the player. If new and unlinked
identifiers are found, they are also linked to the User ID. By default, in the
case that multiple User IDs are found, the oldest User ID is assigned, and
existing identifier links are not modified. This can be changed to migrate data
to the oldest User ID, and delete the other User IDs. If no linked User ID is
found, a new one is created and linked to the identifiers.

Players are also given an ACE principal based on the User ID: `user.<UserId>`.

## Data IDs

The Data ID is an integer value provided by this resource, similar to a
character or a save file. One User ID can have multiple Data IDs, similar to
having multiple characters or save files. This is intended for developers to use
as a framework-agnostic solution to save player data, replacing
framework-dependent character IDs. It is recommended to almost always use Data
IDs to save data. Use User IDs only for data that should persist across all Data
IDs.

By default, when a player joins, this resource automatically assigns the first
Data ID linked to the player's User ID, or creates one if none exist. Other
resources can disable this functionality by running the
`exports.d4_playerdata:disableDataAutoAssign()` export when this resource
starts, to implement their own Data ID assignments, such as a character
selection screen.

Players are also given an ACE principal based on the Data ID: `data.<DataId>`.

## Persist IDs

To ban players effectively, FiveM provides us with player hardware tokens, in
addition to identifiers. This allows servers to ban a player's entire machine,
network (with the `ip` identifier), and more. When a player joins the server,
this resource collects their tokens and identifiers and links them to a
Persist ID. Any User IDs linked to the player are linked to the Persist ID as
well. The Persist ID is an integer value assigned to players, intended for
effective banning.

This functionality is optional, and can be disabled with the
`d4_playerdata_usePersistIds` convar.
