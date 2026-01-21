API.users = {}

---@type table<string, integer>
local playerToUserId = {}
---@type table<integer, table<string, true>>
local userIdToPlayers = {}

---@param player unknown
---@return integer? userId
function API.users.get(player)
    player = tostring(player)

    return playerToUserId[player]
end

---@param identifiers string[]
---@return integer[] userIds
function API.users.resolve(identifiers)
    local set = {}
    local userIds = {}

    for i = 1, #identifiers do
        local identifier = identifiers[i]
        local found = Storage.identifierToUser.get(identifier)

        if found ~= nil and not set[found] then
            set[found] = true
            userIds[#userIds + 1] = found
        end
    end

    table.sort(userIds)
    return userIds
end

---@param userId integer
---@return boolean connected
function API.users.isConnected(userId)
    return userIdToPlayers[userId] ~= nil and
        next(userIdToPlayers[userId]) ~= nil
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

---@param userId integer
---@return boolean success
function API.users.delete(userId)
    if API.users.isConnected(userId) then
        return false
    end

    local dataIds = Storage.userToData.getAll(userId)
    local identifiers = Storage.userToIdentifier.getAll(userId)

    for i = 1, #dataIds do
        if not API.data.delete(dataIds[i]) then
            return false
        end
    end

    for i = 1, #identifiers do
        local identifier = identifiers[i]
        Storage.identifierToUser.delete(identifier)
        Storage.userToIdentifier.delete(userId, identifier)
    end

    API.persist.unlinkUser(userId)

    FlushResourceKvp()
    TriggerEvent('d4_playerdata:userDeleted', userId)

    return true
end

---@param oldUserId integer
---@param newUserId integer
---@return boolean success
function API.users.migrate(oldUserId, newUserId)
    if oldUserId == newUserId or API.users.isConnected(oldUserId) then
        return false
    end

    local dataIds = Storage.userToData.getAll(oldUserId)
    local identifiers = Storage.userToIdentifier.getAll(oldUserId)

    for i = 1, #dataIds do
        if not API.data.migrate(dataIds[i], newUserId) then
            return false
        end
    end

    for i = 1, #identifiers do
        local identifier = identifiers[i]
        local idType = Utils.getIdentifierType(identifier)

        if not Storage.userToIdentifier.get(newUserId, idType) then
            Storage.identifierToUser.set(identifier, newUserId)
            Storage.userToIdentifier.set(newUserId, identifier)
        end
    end

    FlushResourceKvp()
    TriggerEvent('d4_playerdata:userMigrated', oldUserId, newUserId)

    API.users.delete(oldUserId)

    return true
end

---@param player unknown
---@return integer? userId
function API.users.ensure(player)
    player = tostring(player)

    local identifiers = Utils.getIdentifiers(player)
    local userId = API.users.get(player)
    local created = false

    if userId == nil then
        local resolved = API.users.resolve(identifiers)
        userId = resolved[1]
        if Convars.migrateMultipleUsers() then
            for i = 2, #resolved do
                API.users.migrate(resolved[i], userId)
            end
        end
    end

    if userId == nil then
        if #identifiers == 0 then
            return nil
        end

        userId = Storage.userId.increment()
        created = true
    elseif API.users.isConnected(userId) and not Convars.allowDuplicateUsers() then
        return nil
    end

    playerToUserId[player] = userId
    if userIdToPlayers[userId] == nil then
        userIdToPlayers[userId] = {}
    end
    userIdToPlayers[userId][player] = true

    local persistId = API.persist.get(player)
    if persistId ~= nil then
        API.persist.linkUser(persistId, userId)
    end

    for i = 1, #identifiers do
        local identifier = identifiers[i]
        local found = Storage.identifierToUser.get(identifier)

        if found == nil then
            Storage.identifierToUser.set(identifier, userId)
            Storage.userToIdentifier.set(userId, identifier)
        end
    end

    Utils.addPlayerPrincipal(player, Utils.getUserAceName(userId))
    print(('Player %s was assigned User ID %s'):format(player, userId))

    FlushResourceKvp()
    if created then
        TriggerEvent('d4_playerdata:userCreated', userId)
    end
    TriggerEvent('d4_playerdata:userJoined', player, userId)

    return userId
end

---@param player unknown
function API.users.remove(player)
    player = tostring(player)

    local userId = playerToUserId[player]
    if userId == nil then
        return
    end

    playerToUserId[player] = nil
    userIdToPlayers[userId][player] = nil
    if next(userIdToPlayers[userId]) == nil then
        userIdToPlayers[userId] = nil
    end

    Utils.removePlayerPrincipal(player, Utils.getUserAceName(userId))
    print(('Player %s was unassigned User ID %s'):format(player, userId))
    TriggerEvent('d4_playerdata:userLeft', player, userId)
end

exports('getUserId', API.users.get)
exports('resolveUserId', API.users.resolve)
exports('isUserIdConnected', API.users.isConnected)
exports('getPlayersFromUserId', API.users.getPlayers)
exports('deleteUserId', API.users.delete)
exports('migrateUserId', API.users.migrate)
