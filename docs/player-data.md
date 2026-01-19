# Player Data

> TL;DR
> This resource assigns players a persistent User ID linked to player
> identifiers, and provides Data IDs for data similar to characters or save
> files. Use User IDs for identity, and Data IDs for gameplay state.

The main functionality of this resource is identifying players and assigning
them persistent User and Data IDs. This document explains the purpose and
behavior of these IDs.

Please read the following links for more context:
- [Identifier Types](https://docs.fivem.net/docs/scripting-reference/runtimes/lua/functions/GetPlayerIdentifiers/#identifier-types)

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
identifiers are found, they are also linked to the User ID. In the case that
multiple User IDs are found, the oldest User ID is assigned. Existing identifier
links are not modified, preventing accidental reassignment. If no linked User ID
is found, a new one is created and linked to the identifiers.

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
resources can disable this functionality to implement their own Data ID
assignments, such as a character selection screen.
