# Users API

## Server Exports

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

### Delete User ID

```
exports.d4_playerdata:deleteUserId(userId)
```

Deletes the given User ID, and returns whether it was successful.
Returns false if a player with the given User ID is currently connected.

#### Parameters

- `userId: integer` - The User ID.

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

## Server Events

### User Created

```
AddEventHandler('d4_playerdata:userCreated', function(userId) end)
```

Triggered after a User ID is created.

#### Parameters

- `userId: integer` - The created User ID.

### User Deleted

```
AddEventHandler('d4_playerdata:userDeleted', function(userId) end)
```

Triggered after a User ID is deleted.

#### Parameters

- `userId: integer` - The deleted User ID.

### User Joined

```
AddEventHandler('d4_playerdata:userJoined', function(source, userId) end)
```

Triggered after a player is assigned a User ID.

#### Parameters

- `source: string` - The player Net ID.
- `userId: integer` - The assigned User ID.

### User Left

```
AddEventHandler('d4_playerdata:userLeft', function(source, userId) end)
```

Triggered after a player is unassigned a User ID.

#### Parameters

- `source: string` - The player Net ID.
- `userId: integer` - The assigned User ID.

