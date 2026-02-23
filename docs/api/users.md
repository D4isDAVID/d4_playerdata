# Users API

## Table of Contents

- [Server Exports](#server-exports)
- [Server Events](#server-events)

## Server Exports

### Get User ID from Player

```lua
exports.d4_playerdata:getUserId(player)
```

Returns the given player's User ID.

#### Parameters

- `player: string | integer` - The player Net ID.

#### Returns

- `integer?` - The player's User ID.

### Get User ID from Identifier

```lua
exports.d4_playerdata:getUserIdFromIdentifier(identifier)
```

Returns the User ID linked to the given identifier.

#### Parameters

- `identifier: string` - The identifier.

#### Returns

- `integer?` - The User ID linked to the given identifier.

### Does User ID Exist

```lua
exports.d4_playerdata:doesUserIdExist(userId)
```

Returns whether a given User ID exists.

#### Parameters

- `userId: integer` - The User ID.

#### Returns

- `boolean` - Whether the given User ID exists.

### Resolve User IDs from Identifiers

```lua
exports.d4_playerdata:resolveUserIds(identifiers)
```

Resolves and returns User IDs based on the given identifiers.

#### Parameters

- `identifiers: string[]` - The player identifiers.

#### Returns

- `integer[]` - The resolved User IDs.

### Is User ID Connected

```lua
exports.d4_playerdata:isUserIdConnected(userId)
```

Returns whether the given User ID is connected to the server.

#### Parameters

- `userId: integer` - The User ID.

#### Returns

- `boolean` - Whether the given User ID is connected.

### Get Players from User ID

```lua
exports.d4_playerdata:getPlayersFromUserId(userId)
```

Returns the player Net IDs linked to the given User ID.
The returned table will be empty when offline.

#### Parameters

- `userId: integer` - The player's User ID.

#### Returns

- `string[]` - The player Net IDs linked to the given User ID.

### Get Identifier from User ID

```lua
exports.d4_playerdata:getIdentifierFromUserId(userId, identifierType)
```

Returns the identifier of the given type linked to the given User ID.

#### Parameters

- `userId: integer` - The User ID.
- `identifierType: integer` - The identifier type.

#### Returns

- `string?` - The identifier of the given type linked to the given User ID.

### Get Identifiers from User ID

```lua
exports.d4_playerdata:getIdentifiersFromUserId(userId)
```

Returns the identifiers linked to the given User ID.

#### Parameters

- `userId: integer` - The User ID.

#### Returns

- `string[]` - The identifiers linked to the given User ID.

### Delete User ID

```lua
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

```lua
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

### Add User ID Principal

```lua
exports.d4_playerdata:addUserIdPrincipal(userId, principal)
```

Persists a given ACE principal to a given User ID and returns whether it was
successful.
Returns `false` if the principal already exists for the given User ID.

#### Parameters

- `userId: integer` - The User ID.
- `principal: string` - The ACE Principal.

#### Returns

- `boolean` - Whether the principal was added.

### Remove User ID Principal

```lua
exports.d4_playerdata:removeUserIdPrincipal(userId, principal)
```

Removes a given ACE principal from a given User ID and returns whether it was
successful.
Returns `false` if the principal does not exist for the given User ID.

#### Parameters

- `userId: integer` - The User ID.
- `principal: string` - The ACE Principal.

#### Returns

- `boolean` - Whether the principal was removed.

## Server Events

### User Created

```lua
AddEventHandler('d4_playerdata:userCreated', function(userId) end)
```

Triggered after a User ID is created.

#### Parameters

- `userId: integer` - The created User ID.

### User Deleted

```lua
AddEventHandler('d4_playerdata:userDeleted', function(userId) end)
```

Triggered after a User ID is deleted.

#### Parameters

- `userId: integer` - The deleted User ID.

### User Migrated

```lua
AddEventHandler('d4_playerdata:userMigrated', function(oldUserId, newUserId) end)
```

Triggered after a User ID is migrated to another.
The old User ID will be deleted after this event is triggered.

#### Parameters

- `oldUserId: integer` - The old User ID data was migrated from.
- `newUserId: integer` - The new User ID data was migrated to.

### User Joined

```lua
AddEventHandler('d4_playerdata:userJoined', function(player, userId) end)
```

Triggered after a player is assigned a User ID.

#### Parameters

- `player: string` - The player Net ID.
- `userId: integer` - The assigned User ID.

### User Left

```lua
AddEventHandler('d4_playerdata:userLeft', function(player, userId) end)
```

Triggered after a player is unassigned a User ID.

#### Parameters

- `player: string` - The player Net ID.
- `userId: integer` - The unassigned User ID.
