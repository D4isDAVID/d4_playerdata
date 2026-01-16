API.users = {}

---@type table<unknown, integer>
local playerToUserId = {}
---@type table<integer, table<unknown, true>>
local userIdToPlayers = {}

---@param player unknown
---@return integer? userId
function API.users.get(player)
    player = tostring(player)

    if playerToUserId[player] then
        return playerToUserId[player]
    end

    local userId
    local identifiers = Utils.getIdentifiers(player)

    for i = 1, #identifiers do
        local identifier = identifiers[i]
        local found = Storage.identifierToUser.get(identifier)

        if found ~= nil and (userId == nil or found < userId) then
            userId = found
        end
    end

    return userId
end

---@param userId integer
---@return boolean connected
function API.users.isConnected(userId)
    return userIdToPlayers[userId] ~= nil and next(userIdToPlayers[userId]) ~= nil
end

---@param userId integer
---@return unknown[] player
function API.users.getPlayers(userId)
    local players = {}

    if userIdToPlayers[userId] ~= nil then
        for player in pairs(userIdToPlayers[userId]) do
            players[#players + 1] = player
        end
    end

    return players
end

---@param player unknown
---@return integer? userId
function API.users.ensure(player)
    player = tostring(player)

    local userId = API.users.get(player)
    local identifiers = Utils.getIdentifiers(player)

    if userId == nil then
        if #identifiers == 0 then
            return nil
        end

        userId = Storage.userId.increment()
    elseif API.users.isConnected(userId) and not Convars.allowDuplicatePlayers() then
        return nil
    end

    playerToUserId[player] = userId
    if userIdToPlayers[userId] == nil then
        userIdToPlayers[userId] = {}
    end
    userIdToPlayers[userId][player] = true

    for i = 1, #identifiers do
        local identifier = identifiers[i]
        local found = Storage.identifierToUser.get(identifier)

        if found == nil then
            Storage.identifierToUser.set(identifier, userId)
            Storage.userToIdentifier.set(userId, identifier)
        end
    end

    FlushResourceKvp()
    return userId
end

AddEventHandler('playerDropped', function()
    local source = tostring(source)

    local userId = playerToUserId[source]

    if userId ~= nil then
        playerToUserId[source] = nil
        userIdToPlayers[userId][source] = nil

        if next(userIdToPlayers[userId]) == nil then
            userIdToPlayers[userId] = nil
        end
    end
end)

exports('getUserIdFromPlayer', API.users.get)
exports('getPlayersFromUserId', API.users.getPlayers)
