# Exports

## Server

### Get User ID From Player

```
exports.d4_playerdata:getUserIdFromPlayer(player)
```

Returns the given player's User ID.

#### Parameters

- `player: string | integer` - The player Net ID.

#### Returns

- `integer` - The player's User ID.

### Get Players From User ID

```
exports.d4_playerdata:getPlayersFromUserId(userId)
```

Returns the player Net IDs linked to the given User ID.
The returned table will be empty when offline.

#### Parameters

- `userId: integer` - The player's User ID.

#### Returns

- `string[]` - The player Net IDs linked to the given User ID.

### Get User ID From Identifier

```
exports.d4_playerdata:getUserIdFromIdentifier(identifier)
```

Returns the User ID linked to the given identifier.

#### Parameters

- `identifier: string` - The identifier.

#### Returns

- `string` - The User ID linked to the given identifier.

### Get Identifiers From User ID

```
exports.d4_playerdata:getIdentifiersFromUserId(userId)
```

Returns the identifiers linked to the given User ID.

#### Parameters

- `userId: integer` - The User ID.

#### Returns

- `string[]` - The identifiers linked to the given User ID.
