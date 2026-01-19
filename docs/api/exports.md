# Exports

## Server

### Get User ID From Player

```
exports.d4_playerdata:getUserId(player)
```

Returns the given player's User ID.

#### Parameters

- `player: string | integer` - The player Net ID.

#### Returns

- `integer?` - The player's User ID.

### Resolve User ID From Identifiers

```
exports.d4_playerdata:resolveUserId(identifiers)
```

Resolves and returns a User ID based on the given identifiers.

#### Parameters

- `identifiers: string[]` - The player identifiers.

#### Returns

- `integer?` - The resolved User ID.

### Is User ID Connected

```
exports.d4_playerdata:isUserIdConnected(userId)
```

Returns whether the given User ID is connected to the server.

#### Parameters

- `userId: integer` - The User ID.

#### Returns

- `boolean` - Whether the given User ID is connected.

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

- `integer?` - The User ID linked to the given identifier.

### Get Identifiers From User ID

```
exports.d4_playerdata:getIdentifiersFromUserId(userId)
```

Returns the identifiers linked to the given User ID.

#### Parameters

- `userId: integer` - The User ID.

#### Returns

- `string[]` - The identifiers linked to the given User ID.

### Get Data ID Assigned to Player

```
exports.d4_playerdata:getDataId(player)
```

Returns the Data ID assigned to the given player, or `nil` if not assigned.

#### Parameters

- `player: string | integer` - The player Net ID.

#### Returns

- `integer?` - The assigned Data ID, or `nil` of not assigned.

### Get Player Assigned to Data ID

```
exports.d4_playerdata:getPlayerFromDataId(dataId)
```

Returns the player assigned to the given Data ID, or `nil` if not assigned.

#### Parameters

- `dataId: integer` - The User ID.

#### Returns

- `string?` - The assigned player Net ID, or `nil` of not assigned.

### Assign Data ID to Player

```
exports.d4_playerdata:assignDataId(player, dataId)
```

Assigns the given Data ID to the given player and returns whether it was
successful. Returns false if:
- The given player does not have a User ID.
- The given player already has an assigned Data ID.
- The given Data ID is not linked to the given player's User ID.
- The given Data ID already has an assigned player.

#### Parameters

- `player: string | integer` - The player Net ID.
- `dataId: integer` - The Data ID.

#### Returns

- `boolean` - Whether the assignment was successful.

### Unassign Data ID From Player

```
exports.d4_playerdata:unassignDataId(player)
```

Unassigns a Data ID from the given player and returns whether it was successful.
Returns false if the given player has no assigned Data ID.

#### Parameters

- `player: string | integer` - The player Net ID.

#### Returns

- `boolean` - Whether the unassignment was successful.

### Create Data ID for User ID

```
exports.d4_playerdata:createDataId(userId)
```

Creates a new Data ID and links it to the given User ID.

#### Parameters

- `userId: integer` - The User ID.

#### Returns

- `integer` - The created Data ID.

### Disable Data Auto Assignment

```
exports.d4_playerdata:disableDataAutoAssign()
```

A one-time function to disable automatically assigning the first Data ID to a
player. Use this if a different resource will handle data assignment, such as a
character selection resource.

### Get User ID From Data ID

```
exports.d4_playerdata:getUserIdFromDataId(dataId)
```

Returns the User ID linked to the given Data ID.

#### Parameters

- `dataId: integer` - The Data ID.

#### Returns

- `integer?` - The User ID linked to the given Data ID.

### Get Data IDs From User ID

```
exports.d4_playerdata:getDataIdsFromUserId(userId)
```

Returns the Data IDs linked to the given User ID.

#### Parameters

- `userId: integer` - The User ID.

#### Returns

- `integer[]` - The Data IDs linked to the given User ID.

### Does Data ID Exist for User ID

```
exports.d4_playerdata:doesDataIdExist(userId, dataId)
```

Returns whether the given Data IDs is linked to the given User ID.

#### Parameters

- `userId: integer` - The User ID.
- `dataId: integer` - The Data ID.

#### Returns

- `boolean` - Whether the given Data ID is linked to the given User ID.
