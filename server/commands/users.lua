Utils.registerCommand({
    name = 'users:get',
    help = 'Get the User ID of a connected player.',
    params = {
        {
            name = 'player',
            help = 'The Net ID of the player.',
        },
    },
    restricted = true,
}, function(_, args)
    local player = Utils.parsePlayerParam('player', args[1])

    local userId = API.users.get(player)
    if userId == nil then
        error(('%s does not have a User ID.'):format(GetPlayerName(player)))
    end

    print(userId)
end)

Utils.registerCommand({
    name = 'users:fromIdentifier',
    help = 'Get the User ID from an identifier.',
    params = {
        {
            name = 'identifier',
            help = 'The identifier.',
        },
    },
    restricted = true,
}, function(_, args)
    local identifier = args[1]

    local userId = Storage.identifierToUser.get(identifier)
    if userId == nil then
        error(('Identifier %s is not linked to a User ID.'):format(identifier))
    end

    print(userId)
end)

Utils.registerCommand({
    name = 'users:getPlayers',
    help = 'Get the connected players from a User ID.',
    params = {
        {
            name = 'userId',
            help = 'The User ID.',
        },
    },
    restricted = true,
}, function(_, args)
    local userId = Utils.parseUserIdParam('userId', args[1])

    local players = API.users.getPlayers(userId)
    if #players == 0 then
        error(('There are no connected players with the User ID %d.')
            :format(userId))
    end

    print(table.concat(players, ', '))
end)

Utils.registerCommand({
    name = 'users:getIdentifier',
    help = 'Get the linked identifier from a User ID.',
    params = {
        {
            name = 'userId',
            help = 'The User ID.',
        },
        {
            name = 'identifierType',
            help = 'The identifier type (e.g. license2).',
        },
    },
    restricted = true,
}, function(_, args)
    local userId = Utils.parseUserIdParam('userId', args[1])
    local identifierType = args[2]

    local identifier = Storage.userToIdentifier.get(userId, identifierType)
    if identifier == nil then
        error(('There is no linked identifier of type %s for User ID %d.')
            :format(identifierType, userId))
    end

    print(identifier)
end)

Utils.registerCommand({
    name = 'users:getIdentifiers',
    help = 'Get all linked identifiers from a User ID.',
    params = {
        {
            name = 'userId',
            help = 'The User ID.',
        },
    },
    restricted = true,
}, function(_, args)
    local userId = Utils.parseUserIdParam('userId', args[1])

    local identifiers = Storage.userToIdentifier.getAll(userId)
    if #identifiers == 0 then
        error(('There are no linked identifiers for User ID %d.'):format(userId))
    end

    print(table.concat(identifiers, ', '))
end)

Utils.registerCommand({
    name = 'users:delete',
    help = 'Delete a User ID.',
    params = {
        {
            name = 'userId',
            help = 'The User ID.',
        },
    },
    restricted = true,
}, function(_, args)
    local userId = Utils.parseUserIdParam('userId', args[1])
    local confirm = args[2]

    if confirm ~= 'confirm' then
        local players = API.users.getPlayers(userId)

        error(('Are you sure you want to delete the User ID %d? '
                .. 'There are %d players online with this User ID. '
                .. 'BY DELETING THE USER ID, ITS DATA WILL BE REMOVED AND NO LONGER ACCESSIBLE! '
                .. 'Run `/users:delete %d confirm` to confirm your action.')
            :format(userId, #players, userId))
    end

    local success = API.users.delete(userId)
    if not success then
        error(('Failed to delete User ID %d. '
                .. 'Make sure no players with that User ID are connected.')
            :format(userId))
    end

    print(('Successfully deleted User ID %d.'):format(userId))
end)

Utils.registerCommand({
    name = 'users:migrate',
    help = 'Migrate data from a User ID to another User ID.',
    params = {
        {
            name = 'oldUserId',
            help = 'The User ID to migrate data from.',
        },
        {
            name = 'newUserId',
            help = 'The User ID to migrate data to.',
        },
    },
    restricted = true,
}, function(_, args)
    local oldUserId = Utils.parseUserIdParam('oldUserId', args[1])
    local newUserId = Utils.parseUserIdParam('newUserId', args[2])
    local confirm = args[3]

    if confirm ~= 'confirm' then
        local players = API.users.getPlayers(oldUserId)

        error(('Are you sure you want to migrate the User ID %d? '
                .. 'There are %d players online with this User ID. '
                .. 'BY MIGRATING THE USER ID, DATA WILL NO LONGER BE ACCESSIBLE THROUGH THE OLD USER ID! '
                .. 'Run `/users:migrate %d %d confirm` to confirm your action.')
            :format(oldUserId, #players, oldUserId, newUserId))
    end

    local success = API.users.migrate(oldUserId, newUserId)
    if not success then
        error(('Failed to migrate User ID %d to User ID %d. '
                .. 'Make sure no players with that User ID are connected.')
            :format(oldUserId, newUserId))
    end

    print(('Successfully migrated User ID %d to User ID %d.')
        :format(oldUserId, newUserId))
end)

Utils.registerCommand({
    name = 'users:addPrincipal',
    help = 'Add an ACE principal to a User ID.',
    params = {
        {
            name = 'userId',
            help = 'The User ID.',
        },
        {
            name = 'principal',
            help = 'The ACE principal.',
        },
    },
    restricted = true,
}, function(_, args)
    local userId = Utils.parseUserIdParam('userId', args[1])
    local principal = args[2]

    local success = API.users.addPrincipal(userId, principal)
    if not success then
        error(('ACE principal %s already exists for User ID %d.')
            :format(principal, userId))
    end

    print(('Added ACE principal %s to User ID %s.'):format(principal, userId))
end)

Utils.registerCommand({
    name = 'users:removePrincipal',
    help = 'Remove an ACE principal from a User ID.',
    params = {
        {
            name = 'userId',
            help = 'The User ID.',
        },
        {
            name = 'principal',
            help = 'The ACE principal.',
        },
    },
    restricted = true,
}, function(_, args)
    local userId = Utils.parseUserIdParam('userId', args[1])
    local principal = args[2]

    local success = API.users.removePrincipal(userId, principal)
    if not success then
        error(('ACE principal %s does not exist for User ID %d.')
            :format(principal, userId))
    end

    print(('Removed ACE principal %s from User ID %s.'):format(principal, userId))
end)
