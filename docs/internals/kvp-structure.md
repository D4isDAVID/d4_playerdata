# KVP Structure

This project uses FXServer's built-in KVP (Key-Value Pair) storage system as the
database. Below is an overview of the project's internal KVP structure.

## Incremental User ID

```
userId
```

Used to increment and create new User IDs.
This is a persistent value and must never be decremented or reset.

### Returns

- `integer` - The next User ID.

## Identifier to User ID Map

```
identifierToUser:<identifier>
```

Used to get the User ID linked to an identifier.

### Parameters

- `identifier: string` - The identifier (e.g. `'license2:abcdefg'`).

### Returns

- `integer` - The User ID linked to the identifier.

## User ID to Identifier Map

```
userToIdentifier:<userId>:<identifierType>
```

Used to get the identifier linked to a User ID.

### Parameters

- `userId: integer` - The User ID
- `identifierType: string` - The identifier type (e.g. `'license2'`).

### Returns

- `string` - The identifier linked to the User ID (e.g. `'license2:abcdefg'`).

## Incremental Data IDs

```
dataId
```

Used to increment and create new Data IDs.
This is a persistent value and must never be decremented or reset.

### Returns

- `integer` - The next Data ID.

## User ID to Data IDs

```
userToData:<userId>:<dataId>
```

Used to get the Data ID linked to a given User ID.

### Parameters

- `userId: integer` - The User ID
- `dataId: integer` - The Data ID

### Returns

- `integer` - The given Data ID.

## Data ID to User ID

```
dataToUser:<dataId>
```

Used to get the User ID linked to the given Data ID.

### Parameters

- `dataId: integer` - The Data ID

### Returns

- `integer` - The User ID linked to the given Data ID.

## Incremental Persist ID

```
persistId
```

Used to increment and create new Persist IDs.
This is a persistent value and must never be decremented or reset.

### Returns

- `integer` - The next Persist ID.

## Token to Persist ID

```
tokenToPersist:<token>
```

Used to get the Persist ID linked to the given player token.

### Parameters

- `token: string` - The player token.

### Returns

- `integer` - The Persist ID linked to the player token.

## Persist ID to Token Map

```
persistToToken:<persistId>:<token>
```

Used to get a player token linked to the given Persist ID.

### Parameters

- `persistId: integer` - The Persist ID.
- `token: string` - The player token.

### Returns

- `string` - The player token linked to the Persist ID.

## Identifier to Persist ID

```
identifierToPersist:<identifier>
```

Used to get the Persist ID linked to the given identifier.

### Parameters

- `identifier: string` - The identifier (e.g. `'license2:abcdefg'`).

### Returns

- `integer` - The Persist ID linked to the identifier.

## Persist ID to Identifier Map

```
persistToIdentifier:<persistId>:<identifier>
```

Used to get an identifier linked to the given Persist ID.

### Parameters

- `persistId: integer` - The Persist ID.
- `identifier: string` - The identifier (e.g. `'license2:abcdefg'`).

### Returns

- `string` - The identifier linked to the Persist ID (e.g. `'license2:abcdefg'`).

## User ID to Persist ID

```
userToPersist:<userId>
```

Used to get the Persist ID linked to the given User ID.

### Parameters

- `userId: integer` - The User ID.

### Returns

- `integer` - The Persist ID linked to the given User ID.

## Persist ID to User ID Map

```
persistToUser:<persistId>:<userId>
```

Used to get a User ID linked to the given Persist ID.

### Parameters

- `persistId: integer` - The Persist ID.
- `userId: integer` - The User ID.

### Returns

- `integer` - The linked User ID.
