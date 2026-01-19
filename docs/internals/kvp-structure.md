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
