# Users API

## Table of Contents

- [Server Exports](#server-exports)
- [Server Events](#server-events)

## Server Exports

### Get User ID from Player

```
exports.d4_playerdata:getUserId(player)
```

Returns the given player's User ID.

#### Parameters

- `player: string | integer` - The player Net ID.

#### Returns

- `integer?` - The player's User ID.

### Does User ID Exist

```
exports.d4_playerdata:doesUserIdExist(userId)
```

Returns whether a given User ID exists.

#### Parameters

- `userId: integer` - The User ID.

#### Returns

- `boolean` - Whether the given User ID exists.

### Resolve User IDs from Identifiers

```
exports.d4_playerdata:resolveUserIds(identifiers)
```

Resolves and returns User IDs based on the given identifiers.

#### Parameters

- `identifiers: string[]` - The player identifiers.

#### Returns

- `integer[]` - The resolved User IDs.

### Is User ID Connected

```
exports.d4_playerdata:isUserIdConnected(userId)
```

Returns whether the given User ID is connected to the server.

#### Parameters

- `userId: integer` - The User ID.

#### Returns

- `boolean` - Whether the given User ID is connected.

### Get Players from User ID

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
Returns false if the given User ID does not exist, a player with the given User
ID is currently connected, or it failed to delete a Data ID.

#### Parameters

- `userId: integer` - The User ID.

#### Returns

- `boolean` - Whether the deletion was successful.

### Migrate User ID

```
exports.d4_playerdata:migrateUserId(oldUserId, newUserId)
```

Moves Data IDs and identifiers from one User ID to another, and returns whether
it was successful. Only identifier types that don't exist on the new User ID are
moved.

Returns false if the given old and new User IDs are equal or don't exist, a
player with the old User ID is currently connected, or it failed to migrate a
Data ID.

#### Parameters

- `oldUserId: integer` - The old User ID to migrate the data from.
- `newUserId: integer` - The new User ID to migrate the data to.

#### Returns

- `boolean` - Whether the migration was successful.

### Get User ID from Identifier

```
exports.d4_playerdata:getUserIdFromIdentifier(identifier)
```

Returns the User ID linked to the given identifier.

#### Parameters

- `identifier: string` - The identifier.

#### Returns

- `integer?` - The User ID linked to the given identifier.

### Get Identifier from User ID

```
exports.d4_playerdata:getIdentifierFromUserId(userId, identifierType)
```

Returns the identifier of the given type linked to the given User ID.

#### Parameters

- `userId: integer` - The User ID.
- `identifierType: integer` - The identifier type.

#### Returns

- `string?` - The identifier of the given type linked to the given User ID.

### Get Identifiers from User ID

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

### User Migrated

```
AddEventHandler('d4_playerdata:userMigrated', function(oldUserId, newUserId) end)
```

Triggered after a User ID is migrated to another.
The old User ID will be deleted after this event is triggered.

#### Parameters

- `oldUserId: integer` - The old User ID data was migrated from.
- `newUserId: integer` - The new User ID data was migrated to.

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
- `userId: integer` - The unassigned User ID.
