# Data API

## Table of Contents

- [Resource Metadata](#resource-metadata)
- [Server Exports](#server-exports)
- [Server Events](#server-events)

## Resource Metadata

### Disable Data Auto Assignment

```lua
d4_playerdata_disableDataAutoAssign 'yes'
```

Disables automatically assigning the first Data ID to a player upon joining. Add
this to your resource's `fxmanifest.lua` file to manually handle data assignment
in resources such as character selection screens.

## Server Exports

### Get Data ID Assigned to Player

```lua
exports.d4_playerdata:getDataId(player)
```

Returns the Data ID assigned to the given player, or `nil` if not assigned.

#### Parameters

- `player: string | integer` - The player Net ID.

#### Returns

- `integer?` - The assigned Data ID, or `nil` of not assigned.

### Get Data IDs from User ID

```lua
exports.d4_playerdata:getDataIdsFromUserId(userId)
```

Returns the Data IDs linked to the given User ID.

#### Parameters

- `userId: integer` - The User ID.

#### Returns

- `integer[]` - The Data IDs linked to the given User ID.

### Does Data ID Exist

```lua
exports.d4_playerdata:doesDataIdExist(dataId)
```

Returns whether a given Data ID exists.

#### Parameters

- `dataId: integer` - The Data ID.

#### Returns

- `boolean` - Whether the given Data ID exists.

### Does Data ID Exist for User ID

```lua
exports.d4_playerdata:doesDataIdExistForUser(userId, dataId)
```

Returns whether the given Data ID is linked to the given User ID.

#### Parameters

- `userId: integer` - The User ID.
- `dataId: integer` - The Data ID.

#### Returns

- `boolean` - Whether the given Data ID is linked to the given User ID.

### Get Player Assigned to Data ID

```lua
exports.d4_playerdata:getPlayerFromDataId(dataId)
```

Returns the player assigned to the given Data ID, or `nil` if not assigned.

#### Parameters

- `dataId: integer` - The User ID.

#### Returns

- `string?` - The assigned player Net ID, or `nil` of not assigned.

### Get User ID from Data ID

```lua
exports.d4_playerdata:getUserIdFromDataId(dataId)
```

Returns the User ID linked to the given Data ID.

#### Parameters

- `dataId: integer` - The Data ID.

#### Returns

- `integer?` - The User ID linked to the given Data ID.

### Assign Data ID to Player

```lua
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

### Unassign Data ID from Player

```lua
exports.d4_playerdata:unassignDataId(player)
```

Unassigns a Data ID from the given player and returns whether it was successful.
Returns false if the given player has no assigned Data ID.

#### Parameters

- `player: string | integer` - The player Net ID.

#### Returns

- `boolean` - Whether the unassignment was successful.

### Create Data ID for User ID

```lua
exports.d4_playerdata:createDataId(userId)
```

Creates and returns a new Data ID and links it to a given User ID, or `nil` if
the given User ID doesn't exist.

#### Parameters

- `userId: integer` - The User ID.

#### Returns

- `integer?` - The created Data ID, or `nil` if the given User ID doesn't exist.

### Delete Data ID

```lua
exports.d4_playerdata:deleteDataId(dataId)
```

Deletes the given Data ID, and returns whether it was successful.
Returns false if the Data ID does not exist, or a player with the given Data ID
is currently connected.

#### Parameters

- `dataId: integer` - The Data ID.

#### Returns

- `boolean` - Whether the deletion was successful.

### Migrate Data ID

```lua
exports.d4_playerdata:migrateDataId(dataId, newUserId)
```

Moves the given Data ID to a new User ID, and returns whether it was successful.
Returns false if the Data ID does not exist, the old User ID is equal to the new
User ID, or a player with the given Data ID is currently connected.

#### Parameters

- `dataId: integer` - The Data ID.
- `newUserId: integer` - The new User ID to link the given Data ID to.

#### Returns

- `boolean` - Whether the migration was successful.

### Add Data ID Principal

```lua
exports.d4_playerdata:addDataIdPrincipal(dataId, principal)
```

Persists a given ACE principal to a given Data ID and returns whether it was
successful.
Returns `false` if the principal already exists for the given Data ID.

#### Parameters

- `dataId: integer` - The Data ID.
- `principal: string` - The ACE Principal.

#### Returns

- `boolean` - Whether the principal was added.

### Remove Data ID Principal

```lua
exports.d4_playerdata:removeDataIdPrincipal(dataId, principal)
```

Removes a given ACE principal from a given Data ID and returns whether it was
successful.
Returns `false` if the principal does not exist for the given Data ID.

#### Parameters

- `dataId: integer` - The Data ID.
- `principal: string` - The ACE Principal.

#### Returns

- `boolean` - Whether the principal was removed.

## Server Events

### Data Created

```lua
AddEventHandler('d4_playerdata:dataCreated', function(dataId, userId) end)
```

Triggered after a Data ID is created.

#### Parameters

- `dataId: integer` - The created Data ID.
- `userId: integer` - The User ID linked to the created Data ID.

### Data Deleted

```lua
AddEventHandler('d4_playerdata:dataDeleted', function(dataId, userId) end)
```

Triggered after a Data ID is deleted.

#### Parameters

- `dataId: integer` - The deleted Data ID.
- `userId: integer` - The User ID linked to the deleted Data ID.

### Data Migrated

```lua
AddEventHandler('d4_playerdata:dataMigrated', function(dataId, oldUserId, newOldId) end)
```

Triggered after a Data ID is migrated to another User ID.

#### Parameters

- `dataId: integer` - The migrated Data ID.
- `oldUserId: integer` - The User ID previously linked to the migrated Data ID.
- `newUserId: integer` - The User ID currently linked to the migrated Data ID.

### Data Assigned

```lua
AddEventHandler('d4_playerdata:dataAssigned', function(player, dataId) end)
```

Triggered after a player is assigned a Data ID.

#### Parameters

- `player: string` - The player Net ID.
- `dataId: integer` - The assigned Data ID.

### Data Unassigned

```lua
AddEventHandler('d4_playerdata:dataUnassigned', function(player, dataId) end)
```

Triggered after a player is unassigned a Data ID.

#### Parameters

- `player: string` - The player Net ID.
- `dataId: integer` - The unassigned Data ID.
