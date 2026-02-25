Utils.registerCommand({
    name = 'persist:get',
    help = 'Get the Persist ID of a connected player.',
    params = {
        {
            name = 'player',
            help = 'The Net ID of the player.',
        },
    },
    restricted = true,
}, function(_, args)
    local player = args[1]

    local persistId = API.persist.get(player)
    if persistId == nil then
        error(('%s does not have a Persist ID.'):format(GetPlayerName(player)))
    end

    return ('Persist ID: %d'):format(persistId)
end)

Utils.registerCommand({
    name = 'persist:fromToken',
    help = 'Get the Persist ID linked to a player token.',
    params = {
        {
            name = 'token',
            help = 'The player token.',
        },
    },
    restricted = true,
}, function(_, args)
    local token = args[1] --[[@as string]]

    local persistId = Storage.tokenToPersist.get(token)
    if persistId == nil then
        error(('Token %s is not linked to a Persist ID.'):format(token))
    end

    return ('Persist ID: %d'):format(persistId)
end)

Utils.registerCommand({
    name = 'persist:fromIdentifier',
    help = 'Get the Persist ID linked to a player identifier.',
    params = {
        {
            name = 'identifier',
            help = 'The player identifier.',
        },
    },
    restricted = true,
}, function(_, args)
    local identifier = args[1] --[[@as string]]

    local persistId = Storage.identifierToPersist.get(identifier)
    if persistId == nil then
        error(('Identifier %s is not linked to a Persist ID.'):format(identifier))
    end

    return ('Persist ID: %d'):format(persistId)
end)

Utils.registerCommand({
    name = 'persist:fromUser',
    help = 'Get the Persist ID linked to a User ID.',
    params = {
        {
            name = 'userId',
            help = 'The User ID.',
            parser = Utils.parseUserIdParam,
        },
    },
    restricted = true,
}, function(_, args)
    local userId = args[1] --[[@as integer]]

    local persistId = Storage.userToPersist.get(userId)
    if persistId == nil then
        error(('User ID %d is not linked to a Persist ID.'):format(userId))
    end

    return ('Persist ID: %d'):format(persistId)
end)

Utils.registerCommand({
    name = 'persist:getTokens',
    help = 'Get all linked player tokens from a Persist ID.',
    params = {
        {
            name = 'persistId',
            help = 'The Persist ID.',
            parser = Utils.parsePersistIdParam,
        },
    },
    restricted = true,
}, function(_, args)
    local persistId = args[1] --[[@as integer]]

    local tokens = Storage.persistToToken.getAll(persistId)
    if #tokens == 0 then
        error(('There are no linked tokens for Persist ID %d.')
            :format(persistId))
    end

    return ('Tokens: %s'):format(table.concat(tokens, ', '))
end)

Utils.registerCommand({
    name = 'persist:getIdentifiers',
    help = 'Get all linked player identifiers from a Persist ID.',
    params = {
        {
            name = 'persistId',
            help = 'The Persist ID.',
            parser = Utils.parsePersistIdParam,
        },
    },
    restricted = true,
}, function(_, args)
    local persistId = args[1] --[[@as integer]]

    local identifiers = Storage.persistToIdentifier.getAll(persistId)
    if #identifiers == 0 then
        error(('There are no linked identifiers for Persist ID %d.')
            :format(persistId))
    end

    return ('Identifiers: %s'):format(table.concat(identifiers, ', '))
end)

Utils.registerCommand({
    name = 'persist:getUsers',
    help = 'Get all linked User IDs from a Persist ID.',
    params = {
        {
            name = 'persistId',
            help = 'The Persist ID.',
            parser = Utils.parsePersistIdParam,
        },
    },
    restricted = true,
}, function(_, args)
    local persistId = args[1] --[[@as integer]]

    local userIds = Storage.persistToUser.getAll(persistId)
    if #userIds == 0 then
        error(('There are no linked User IDs for Persist ID %d.')
            :format(persistId))
    end

    return ('User IDs: %s'):format(table.concat(userIds, ', '))
end)
