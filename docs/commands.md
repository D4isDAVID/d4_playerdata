# Commands

- [User ID Management](#user-id-management)
- [Data ID Management](#data-id-management)
- [Persist ID Management](#persist-id-management)

## User ID Management

### Get User ID from Player

```
/users:get <player>
```

Prints the given player's User ID.

#### Parameters

- `player` - The player Net ID.

### Get User ID from Identifier

```
/users:fromIdentifier <identifier>
```

Prints the User ID linked to the given identifier.

#### Parameters

- `identifier` - The identifier.

### Get Players from User ID

```
/users:getPlayers <userId>
```

Prints the player Net IDs linked to the given User ID.

#### Parameters

- `userId` - The player's User ID.

### Get Identifier from User ID

```
/users:getIdentifier <userId> <identifierType>
```

Prints the identifier of the given type linked to the given User ID.

#### Parameters

- `userId` - The User ID.
- `identifierType` - The identifier type.

### Get Identifiers from User ID

```
/users:getIdentifiers <userId>
```

Prints the identifiers linked to the given User ID.

#### Parameters

- `userId` - The User ID.

### Delete User ID

```
/users:delete <userId>
```

Deletes the given User ID.
This will fail if a player with the given User ID is currently connected, or if
it failed to delete a Data ID.

#### Parameters

- `userId` - The User ID.

### Migrate User ID

```
/users:migrate <oldUserId> <newUserId>
```

Moves Data IDs and identifiers from one User ID to another.
Only identifier types that don't exist on the new User ID are moved.

This will fail if the given old and new User IDs are equal, a player with the
old User ID is currently connected, or it failed to migrate a Data ID.

#### Parameters

- `oldUserId` - The old User ID to migrate the data from.
- `newUserId` - The new User ID to migrate the data to.

### Add User ID Principal

```
/users:addPrincipal <userId> <principal>
```

Persists the given ACE principal to the given User ID.
This will fail if the given ACE principal already exists for the given User ID.

#### Parameters

- `userId` - The User ID.
- `principal` - The ACE principal.

### Remove User ID Principal

```
/users:removePrincipal <userId> <principal>
```

Removes the given ACE principal from the given User ID.
This will fail if the given ACE principal does not exist for the given User ID.

#### Parameters

- `userId` - The User ID.
- `principal` - The ACE principal.

## Data ID Management

### Get Data ID from Player

```
/data:get <player>
```

Prints the given player's Data ID.

#### Parameters

- `player` - The player Net ID.

### Get Data ID from User ID

```
/data:fromUser <userId>
```

Prints the Data IDs linked to the given User ID.

#### Parameters

- `userId` - The User ID.

### Get Player from Data ID

```
/users:getPlayer <dataId>
```

Prints the player Net ID linked to the given Data ID.

#### Parameters

- `dataId` - The player's Data ID.

### Get User ID from Data ID

```
/data:getUser <dataId>
```

Prints the User ID linked to the given Data ID.

#### Parameters

- `dataId` - The Data ID.

### Assign Data ID to Player

```
/data:assign <player> <dataId>
```

Assigns the given Data ID to the given player. This will fail if:
- The given player does not have a User ID.
- The given player already has an assigned Data ID.
- The given Data ID is not linked to the given player's User ID.
- The given Data ID already has an assigned player.

#### Parameters

- `player` - The player Net ID.
- `dataId` - The Data ID.

### Unassign Data ID from Player

```
/data:unassign <player>
```

Unassigns a Data ID from the given player.
This will fail if the given player has no assigned Data ID.

#### Parameters

- `player` - The player Net ID.

### Create Data ID for User ID

```
/data:create <userId>
```

Creates a new Data ID and links it to the given User ID.

#### Parameters

- `userId` - The User ID.

### Delete Data ID

```
/data:delete <dataId>
```

Deletes the given Data ID.
This will fail if a player with the given Data ID is currently connected.

#### Parameters

- `dataId` - The Data ID.

### Migrate Data ID

```
/data:migrate <dataId> <newUserId>
```

Moves the given Data ID to the given new User ID.
This will fail if the old User ID is equal to the new User ID, or a player with
the given Data ID is currently connected.

#### Parameters

- `dataId` - The Data ID.
- `newUserId` - The new User ID to link the given Data ID to.

### Add Data ID Principal

```
/data:addPrincipal <dataId> <principal>
```

Persists the given ACE principal to the given Data ID.
This will fail if the given ACE principal already exists for the given Data ID.

#### Parameters

- `dataId` - The Data ID.
- `principal` - The ACE principal.

### Remove User ID Principal

```
/data:removePrincipal <dataId> <principal>
```

Removes the given ACE principal from the given Data ID.
This will fail if the given ACE principal does not exist for the given Data ID.

#### Parameters

- `dataId` - The Data ID.
- `principal` - The ACE principal.

## Persist ID Management

### Get Persist ID from Player

```
/persist:get <player>
```

Prints the given player's Persist ID.

#### Parameters

- `player` - The player Net ID.

### Get Persist ID from Token

```
/persist:fromToken <token>
```

Prints the Persist ID linked to the given token.

#### Parameters

- `token` - The token.

### Get Persist ID from User ID

```
/persist:fromUser <userId>
```

Prints the Persist ID linked to the given User ID.

#### Parameters

- `userId` - The User ID.

### Get Tokens from Persist ID

```
/persist:getTokens <persistId>
```

Prints the tokens linked to the given Persist ID.

#### Parameters

- `persistId` - The Persist ID.

### Get Identifiers from Persist ID

```
/persist:getIdentifiers <persistId>
```

Prints the identifiers linked to the given Persist ID.

#### Parameters

- `persistId` - The Persist ID.

### Get User IDs from Persist ID

```
/persist:getUsers <persistId>
```

Prints the User IDs linked to the given Persist ID.

#### Parameters

- `persistId` - The Persist ID.
