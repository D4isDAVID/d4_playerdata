local persistParsers = {
    ---@param value string
    ---@return integer persistId
    player = function(value)
        local player = Utils.parsePlayerParam('value', value)
        local persistId = API.persist.get(player)
        if persistId == nil then
            error('No Persist ID found for this player')
        end
        return persistId
    end,
    ---@param value string
    ---@return integer persistId
    userid = function(value)
        local userId = Utils.parseUserIdParam('value', value)
        local persistId = Storage.userToPersist.get(userId)
        if persistId == nil then
            error('No Persist ID found for this User ID')
        end
        return persistId
    end,
    ---@param value string
    ---@return integer persistId
    persistid = function(value)
        return Utils.parseUserIdParam('value', value)
    end,
}
local persistParserTypes = table.concat(Utils.keys(persistParsers), ', ')

Utils.registerCommand({
    name = 'banpersist',
    help = 'Ban a player based on their Persist ID.',
    params = {
        {
            name = 'type',
            help = persistParserTypes,
        },
        {
            name = 'value',
            help = 'The ID to ban depending on the provided type',
        },
    },
    restricted = true,
}, function(_, args)
    local parser = persistParsers[string.lower(args[1] or '')]
    if parser == nil then
        error(("Parameter 'type' must be one of: %s"):format(persistParserTypes))
    end

    local persistId = parser(args[2])
    if not API.persist.ban(persistId) then
        error(('Persist ID %s is already banned'):format(persistId))
    end
end)

Utils.registerCommand({
    name = 'unbanpersist',
    help = 'Unban a player based on their Persist ID.',
    params = {
        {
            name = 'persistId',
            help = 'The Persist ID',
        },
    },
    restricted = true,
}, function(_, args)
    local persistId = Utils.parsePersistIdParam('persistId', args[1])
    if not API.persist.unban(persistId) then
        error(('Persist ID %s is not banned'):format(persistId))
    end
end)
