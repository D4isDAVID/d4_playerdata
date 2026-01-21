# KVP Structure

This project uses FXServer's built-in KVP (Key-Value Pair) storage system as the
database. Below is an overview of the project's internal KVP structure.

## Table of Contents

- [User ID](#user-id)
- [Data ID](#data-id)
- [Persist ID](#persist-id)

## User ID

### Incremental User ID

```
userId
```

Used to increment and create new User IDs.
This is a persistent value and must never be decremented or reset.

#### Returns

- `integer` - The next User ID.

### Identifier to User ID

```
identifierToUser:<identifier>
```

Used to get the User ID linked to a given player identifier.

#### Parameters

- `identifier: string` - The player identifier.

#### Returns

- `integer` - The User ID linked to the given player identifier.

### User ID to Identifier Map

```
userToIdentifier:<userId>:<identifierType>
```

Used to search for player identifiers linked to a given User ID.

#### Parameters

- `userId: integer` - The User ID
- `identifierType: string` - The player identifier type.

#### Returns

- `string` - The player identifier of the given type linked to the given User ID.

## Data ID

### Incremental Data ID

```
dataId
```

Used to increment and create new Data IDs.
This is a persistent value and must never be decremented or reset.

#### Returns

- `integer` - The next Data ID.

### Data ID to User ID

```
dataToUser:<dataId>
```

Used to get the User ID linked to a given Data ID.

#### Parameters

- `dataId: integer` - The Data ID

#### Returns

- `integer` - The User ID linked to the given Data ID.

### User ID to Data ID Map

```
userToData:<userId>:<dataId>
```

Used to search for Data IDs linked to a given User ID.

#### Parameters

- `userId: integer` - The User ID.
- `dataId: integer` - The Data ID.

#### Returns

- `integer` - The given Data ID.

## Persist ID

### Incremental Persist ID

```
persistId
```

Used to increment and create new Persist IDs.
This is a persistent value and must never be decremented or reset.

#### Returns

- `integer` - The next Persist ID.

### Token to Persist ID

```
tokenToPersist:<token>
```

Used to get the Persist ID linked to a given player token.

#### Parameters

- `token: string` - The player token.

#### Returns

- `integer` - The Persist ID linked to the given player token.

### Persist ID to Token Map

```
persistToToken:<persistId>:<token>
```

Used to search for player tokens linked to a given Persist ID.

#### Parameters

- `persistId: integer` - The Persist ID.
- `token: string` - The player token.

#### Returns

- `string` - The given player token.

### Identifier to Persist ID

```
identifierToPersist:<identifier>
```

Used to get the Persist ID linked to a given player identifier.

#### Parameters

- `identifier: string` - The player identifier.

#### Returns

- `integer` - The Persist ID linked to the given player identifier.

### Persist ID to Identifier Map

```
persistToIdentifier:<persistId>:<identifier>
```

Used to search for player identifiers linked to a given Persist ID.

#### Parameters

- `persistId: integer` - The Persist ID.
- `identifier: string` - The player identifier.

#### Returns

- `string` - The given player identifier.

### User ID to Persist ID

```
userToPersist:<userId>
```

Used to get the Persist ID linked to a given User ID.

#### Parameters

- `userId: integer` - The User ID.

#### Returns

- `integer` - The Persist ID linked to the given User ID.

### Persist ID to User ID Map

```
persistToUser:<persistId>:<userId>
```

Used to search for User IDs linked to a given Persist ID.

#### Parameters

- `persistId: integer` - The Persist ID.
- `userId: integer` - The User ID.

#### Returns

- `integer` - The given User ID.
