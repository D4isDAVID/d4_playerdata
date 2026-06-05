# Player Data

> TL;DR:
> This resource assigns players a persistent User ID linked to player
> identifiers, and provides Data IDs for data similar to characters or save
> files. Use User IDs for identity, and Data IDs for gameplay state.
> In addition, this resource provides an optional Persist ID linked to player
> tokens, identifiers, and User IDs, for effective bans.

The main functionality of this resource is identifying players and assigning
them persistent User, Data, and Persist IDs. This document explains the purpose
and behavior of these IDs.

Please read the following links for additional context:
- [Identifier Types](https://docs.fivem.net/docs/scripting-reference/runtimes/lua/functions/GetPlayerIdentifiers/#identifier-types)
- [Basic Aces & Principals overview/guide](https://forum.cfx.re/t/90917)
- [`GetPlayerToken`](https://docs.fivem.net/natives/?_0x54C06897)

## Table of Contents

- [User IDs](#user-ids)
- [Data IDs](#data-ids)
- [Persist IDs](#persist-ids)

## User IDs

### Motivation

To save player data across logins and restarts, FiveM provides us with player
identifiers. Most frameworks use a single identifier; typically `license2` or
`license`, based on availability. This can pose a problem, however, as rare
cases exist where these identifiers change over time. This can lead to some
players losing access to their data, or not being able to join at all. Using
other identifiers alone isn't reliable either, as they might require players to
play using a specific platform, or link an external account, locking out certain
players. This resource's solution is to use *all* available identifiers — except
for `ip`, as it is not specific enough.

### Definition

The "User ID" is an integer value (starting from `1` and incremented by `1`)
linked to player identifiers, intended for developers to use as a replacement
for those identifiers. This resource will reliably identify the player, while
your resources handle the rest.

### Assignment

When a player joins the server, this resource collects their identifiers. If no
linked User ID is found, a new one is created and linked to the identifiers. If
a linked User ID is found, then it is assigned to the player, and any unlinked
identifiers are linked to the assigned User ID.

Players are also given an ACE principal based on the User ID: `user.<UserId>`.

### Multiple User IDs

By default, in the case that multiple linked User IDs are found, the oldest User
ID (i.e. the smallest number) is assigned, and existing identifier links are not
modified. This can be changed with the `d4_playerdata:migrateMultipleUsers`
convar to migrate data to the oldest User ID, and delete the other User IDs.

## Data IDs

### Motivation

Often times the User ID is not enough to save player data. Some servers may
benefit from implementing multiple characters/data/save slots for a single
player. However, character IDs, save slots or data slots on FiveM are often
framework-specific. This resource provides its own API for player data slots,
allowing to integrate with existing frameworks as well.

### Definition

The "Data ID" is an integer value (starting from `1` and incremented by `1`)
linked to a User ID, similar to a character or a save file. One User ID can have
multiple Data IDs, similar to having multiple characters or save files. This is
intended for developers to use as a framework-agnostic solution to save player
data, replacing framework-dependent character IDs.

It is recommended to almost always use Data IDs to save data, and use User IDs
only for data that should persist across all Data IDs.

Players are also given an ACE principal based on the Data ID: `data.<DataId>`.

### Assignment

By default, when a player joins, this resource automatically assigns the first
Data ID (i.e. the smallest number) linked to the player's User ID, or creates
one if none exist. Other resources can disable this functionality by adding the
`d4_playerdata_disableDataAutoAssign 'yes'` metadata to their `fxmanifest.lua`
file to implement their own Data ID assignments, such as a character selection
screen.

## Persist IDs

Persist IDs are optional, and can be disabled with the
`d4_playerdata:usePersistIds` convar.

### Motivation

To ban players effectively, FiveM provides us with player hardware tokens, in
addition to identifiers. This allows servers to ban a player's entire machine,
network (with the `ip` identifier), and more.

### Definition

The "Persist ID" is an integer value (starting from `1` and incremented by `1`)
linked to player identifiers, hardware tokens and User IDs, intended for
effective banning.

Since Persist IDs use the `ip` identifier and hardware tokens, it is unreliable
to use for data storage of any kind. Avoid using Persist IDs for data storage
completely.

### Assignment

When a player joins the server, this resource collects their tokens, identifiers
and User IDs. If no linked Persist ID is found, a new one is created and linked
to the data. If a linked Persist ID is found, then it is assigned to the player,
and any unlinked data is linked to the assigned Persist ID.
