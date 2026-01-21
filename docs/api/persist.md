# Persist API

## Table of Contents

- [Server Exports](#server-exports)

## Server Exports

### Get Persist ID from Player

```
exports.d4_playerdata:getPersistId(player)
```

Returns the given player's Persist ID.

#### Parameters

- `player: string | integer` - The player Net ID.

#### Returns

- `integer?` - The player's Persist ID.

### Resolve Persist IDs from Tokens and Identifiers

```
exports.d4_playerdata:resolvePersistIds(tokens, identifiers)
```

Resolves and returns Persist IDs based on the given tokens and identifiers.

#### Parameters

- `tokens: string[]` - The player tokens.
- `identifiers: string[]` - The player identifiers.

#### Returns

- `integer[]` - The resolved Persist IDs.

### Get Presist ID from Token

```
exports.d4_playerdata:getPersistIdFromToken(token)
```

Returns the Persist ID linked to the given token.

#### Parameters

- `token: string` - The token.

#### Returns

- `integer?` - The Persist ID linked to the given token.

### Get Tokens from Persist ID

```
exports.d4_playerdata:getTokensFromPersistId(persistId)
```

Returns the tokens linked to the given Persist ID.

#### Parameters

- `persistId: integer` - The Persist ID.

#### Returns

- `string[]` - The tokens linked to the given Persist ID.

### Get Presist ID from Identifier

```
exports.d4_playerdata:getPersistIdFromIdentifier(identifier)
```

Returns the Persist ID linked to the given identifier.

#### Parameters

- `identifier: string` - The identifier.

#### Returns

- `integer?` - The Persist ID linked to the given identifier.

### Get Identifiers from Persist ID

```
exports.d4_playerdata:getIdentifiersFromPersistId(userId)
```

Returns the identifiers linked to the given Persist ID.

#### Parameters

- `persistId: integer` - The Persist ID.

#### Returns

- `string[]` - The identifiers linked to the given Persist ID.

### Get Presist ID from User ID

```
exports.d4_playerdata:getPersistIdFromUserId(userId)
```

Returns the Persist ID linked to the given User ID.

#### Parameters

- `userId: string` - The User ID.

#### Returns

- `integer?` - The Persist ID linked to the given User ID.

### Get User IDs from Persist ID

```
exports.d4_playerdata:getUserIdsFromPersistId(persistId)
```

Returns the User IDs linked to the given Persist ID.

#### Parameters

- `persistId: integer` - The Persist ID.

#### Returns

- `integer[]` - The User IDs linked to the given Persist ID.
