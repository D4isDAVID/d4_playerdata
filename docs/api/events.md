# Events

## Server

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

### Data Assigned

```
AddEventHandler('d4_playerdata:dataAssigned', function(source, dataId) end)
```

Triggered after a player is assigned a Data ID.

#### Parameters

- `source: string` - The player Net ID.
- `dataId: integer` - The assigned Data ID.

### Data Unassigned

```
AddEventHandler('d4_playerdata:dataUnassigned', function(source, dataId) end)
```

Triggered after a player is unassigned a Data ID.

#### Parameters

- `source: string` - The player Net ID.
- `dataId: integer` - The unassigned Data ID.
