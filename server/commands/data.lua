Utils.registerCommand({
    name = 'data:get',
    help = 'Get the Data ID of a connected player.',
    params = {
        {
            name = 'player',
            help = 'The Net ID of the player.',
        },
    },
    restricted = true,
}, function(_, args)
    local player = Utils.parsePlayerParam('player', args[1])

    local dataId = API.data.get(player)
    if dataId == nil then
        error(('%s does not have a Data ID.'):format(GetPlayerName(player)))
    end

    print(dataId)
end)

Utils.registerCommand({
    name = 'data:fromUser',
    help = 'Get the Data IDs linked to a User ID.',
    params = {
        {
            name = 'userId',
            help = 'The User ID.',
        },
    },
    restricted = true,
}, function(_, args)
    local userId = Utils.parseUserIdParam('userId', args[1])

    local dataIds = Storage.userToData.getAll(userId)
    if #dataIds == 0 then
        error(('User ID %s has no linked Data IDs.'):format(userId))
    end

    print(table.concat(dataIds, ', '))
end)

Utils.registerCommand({
    name = 'data:getPlayer',
    help = 'Get the connected player from a Data ID.',
    params = {
        {
            name = 'dataId',
            help = 'The Data ID.',
        },
    },
    restricted = true,
}, function(_, args)
    local dataId = Utils.parseDataIdParam('dataId', args[1])

    local player = API.data.getPlayer(dataId)
    if player == nil then
        error(('There is no connected player with the Data ID %d.')
            :format(dataId))
    end

    print(player)
end)

Utils.registerCommand({
    name = 'data:getUser',
    help = 'Get the linked User ID from a Data ID.',
    params = {
        {
            name = 'dataId',
            help = 'The Data ID.',
        },
    },
    restricted = true,
}, function(_, args)
    local dataId = Utils.parseDataIdParam('dataId', args[1])

    local userId = Storage.dataToUser.get(dataId)
    if userId == nil then
        error(('There is no User ID linked to Data ID %d.')
            :format(dataId))
    end

    print(userId)
end)

Utils.registerCommand({
    name = 'data:assign',
    help = 'Assign a Data ID to a player.',
    params = {
        {
            name = 'player',
            help = 'The Net ID.',
        },
        {
            name = 'dataId',
            help = 'The Data ID.',
        },
    },
    restricted = true,
}, function(_, args)
    local player = Utils.parsePlayerParam('player', args[1])
    local dataId = Utils.parseDataIdParam('dataId', args[2])

    local name = GetPlayerName(player)

    local success = API.data.assign(player, dataId)
    if not success then
        error(('Failed to assign Data ID %d to %s. '
                .. 'Make sure the player and Data ID are not already assigned.')
            :format(dataId, name))
    end

    print(dataId)
end)

Utils.registerCommand({
    name = 'data:unassign',
    help = 'Unassign the Data ID from a player.',
    params = {
        {
            name = 'player',
            help = 'The Net ID.',
        },
    },
    restricted = true,
}, function(_, args)
    local player = Utils.parsePlayerParam('player', args[1])

    local name = GetPlayerName(player)

    local success = API.data.unassign(player)
    if not success then
        error(('Failed to unassign Data ID from %s. '
                .. 'Make sure the player has a Data ID assigned.')
            :format(name))
    end

    print(('Successfully unassigned the Data ID from %s.'):format(name))
end)

Utils.registerCommand({
    name = 'data:create',
    help = 'Create a Data ID.',
    params = {
        {
            name = 'userId',
            help = 'The User ID to create the Data ID for.',
        },
    },
    restricted = true,
}, function(_, args)
    local userId = Utils.parseUserIdParam('userId', args[1])

    local dataId = API.data.create(userId)
    if dataId == nil then
        error(('Failed to create Data ID for User ID %d. '
                .. 'Make sure the User ID is valid.')
            :format(userId))
    end

    print(dataId)
end)

Utils.registerCommand({
    name = 'data:delete',
    help = 'Delete a Data ID.',
    params = {
        {
            name = 'dataId',
            help = 'The Data ID.',
        },
    },
    restricted = true,
}, function(_, args)
    local dataId = Utils.parseDataIdParam('dataId', args[1])
    local confirm = args[2]

    if confirm ~= 'confirm' then
        local player = API.data.getPlayer(dataId)

        error(('Are you sure you want to delete the Data ID %d? '
                .. 'There is %s player online with this User ID. '
                .. 'BY DELETING THE DATA ID, ITS DATA WILL BE REMOVED AND NO LONGER ACCESSIBLE! '
                .. 'Run `/data:delete %d confirm` to confirm your action.')
            :format(dataId, player and 'a' or 'no', dataId))
    end

    local success = API.users.delete(dataId)
    if not success then
        error(('Failed to delete Data ID %d. '
                .. 'Make sure no players with that Data ID are connected.')
            :format(dataId))
    end

    print(('Successfully deleted User ID %d.'):format(dataId))
end)

Utils.registerCommand({
    name = 'data:migrate',
    help = 'Migrate a Data ID to a new User ID.',
    params = {
        {
            name = 'dataId',
            help = 'The Data ID.',
        },
        {
            name = 'newUserId',
            help = 'The User ID to migrate the Data ID to.',
        },
    },
    restricted = true,
}, function(_, args)
    local dataId = Utils.parseDataIdParam('dataId', args[1])
    local newUserId = Utils.parseUserIdParam('newUserId', args[2])
    local confirm = args[3]

    if confirm ~= 'confirm' then
        local player = API.data.getPlayer(dataId)

        error(('Are you sure you want to migrate the Data ID %d? '
                .. 'There is %s player online with this Data ID. '
                .. 'BY MIGRATING THE DATA ID, IT WILL NO LONGER BE ACCESSIBLE THROUGH THE OLD USER ID! '
                .. 'Run `/data:migrate %d %d confirm` to confirm your action.')
            :format(dataId, player and 'a' or 'no', dataId, newUserId))
    end

    local oldUserId = Storage.dataToUser.get(dataId)

    local success = API.data.migrate(dataId, newUserId)
    if not success then
        error(('Failed to migrate Data ID %d to User ID %d. '
                .. 'Make sure no player with that Data ID is connected.')
            :format(dataId, newUserId))
    end

    print(('Successfully migrated Data ID %d from User ID %d to User ID %d.')
        :format(dataId, oldUserId, newUserId))
end)

Utils.registerCommand({
    name = 'data:addPrincipal',
    help = 'Add an ACE principal to a Data ID.',
    params = {
        {
            name = 'dataId',
            help = 'The Data ID.',
        },
        {
            name = 'principal',
            help = 'The ACE principal.',
        },
    },
    restricted = true,
}, function(_, args)
    local dataId = Utils.parseDataIdParam('dataId', args[1])
    local principal = args[2]

    local success = API.data.addPrincipal(dataId, principal)
    if not success then
        error(('ACE principal %s already exists for Data ID %d.')
            :format(principal, dataId))
    end

    print(('Added ACE principal %s to Data ID %s'):format(principal, dataId))
end)

Utils.registerCommand({
    name = 'data:removePrincipal',
    help = 'Remove an ACE principal from a Data ID.',
    params = {
        {
            name = 'dataId',
            help = 'The Data ID.',
        },
        {
            name = 'principal',
            help = 'The ACE principal.',
        },
    },
    restricted = true,
}, function(_, args)
    local dataId = Utils.parseDataIdParam('dataId', args[1])
    local principal = args[2]

    local success = API.data.removePrincipal(dataId, principal)
    if not success then
        error(('ACE principal %s does not exist for Data ID %d.')
            :format(principal, dataId))
    end

    print(('Removed ACE principal %s from Data ID %s'):format(principal, dataId))
end)
