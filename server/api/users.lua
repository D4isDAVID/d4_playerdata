API.users = {}

---@type table<string, string>
local connectingPlayers = {}
local connectingThreadRunning = false

---@type table<string, integer>
local playerToUserId = {}
---@type table<integer, table<string, true>>
local userIdToPlayers = {}

---@param player string
---@param userId integer
local function addCache(player, userId)
    playerToUserId[player] = userId
    if userIdToPlayers[userId] == nil then
        userIdToPlayers[userId] = {}
    end
    userIdToPlayers[userId][player] = true
end

---@param player string
local function removeCache(player)
    local userId = playerToUserId[player]
    if userId == nil then
        return
    end

    playerToUserId[player] = nil
    userIdToPlayers[userId][player] = nil
    if next(userIdToPlayers[userId]) == nil then
        userIdToPlayers[userId] = nil
    end
end

---@param player unknown
---@return integer? userId
function API.users.get(player)
    player = tostring(player)

    return playerToUserId[player]
end

---@param userId integer
---@return boolean exists
function API.users.exists(userId)
    return Storage.userToIdentifier.hasAny(userId)
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
    if userIdToPlayers[userId] == nil then
        return {}
    end

    return Utils.keys(userIdToPlayers[userId])
end

---@param userId integer
---@return boolean success
function API.users.delete(userId)
    if not API.users.exists(userId) then
        return false
    end

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
    if not API.users.exists(oldUserId)
    or not API.users.exists(newUserId)
    or oldUserId == newUserId
    or API.users.isConnected(oldUserId) then
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

---@param userId integer
---@param principal string
---@return boolean success
function API.users.addPrincipal(userId, principal)
    if Storage.userToPrincipal.exists(userId, principal) then
        return false
    end

    Storage.userToPrincipal.set(userId, principal)
    FlushResourceKvp()

    if API.users.isConnected(userId) then
        Utils.addUserPrincipal(userId, principal)
    end

    return true
end

---@param userId integer
---@param principal string
---@return boolean success
function API.users.removePrincipal(userId, principal)
    if not Storage.userToPrincipal.exists(userId, principal) then
        return false
    end

    Storage.userToPrincipal.delete(userId, principal)
    FlushResourceKvp()

    if API.users.isConnected(userId) then
        Utils.removeUserPrincipal(userId, principal)
    end

    return true
end

---@param player unknown
---@return boolean allowConnection
function API.users.connect(player)
    player = tostring(player)

    local identifiers = Utils.getIdentifiers(player)
    local userId = API.users.get(player)

    if userId == nil then
        userId = API.users.resolve(identifiers)[1]
    end

    if userId == nil then
        return true
    end

    if userId ~= nil
    and API.users.isConnected(userId)
    and not Convars.allowDuplicateUsers() then
        return false
    end

    addCache(player, userId)
    connectingPlayers[player] = GetPlayerName(player)

    if not connectingThreadRunning then
        connectingThreadRunning = true

        CreateThread(function()
            print('Awaiting connecting players')

            while next(connectingPlayers) do
                for connectingPlayer, name in pairs(connectingPlayers) do
                    if not DoesPlayerExist(connectingPlayer) then
                        print(('%s disconnected'):format(name))
                        connectingPlayers[connectingPlayer] = nil
                        removeCache(connectingPlayer)
                    end
                end
            end

            connectingThreadRunning = false

            print('Ended awaiting connecting players')
        end)
    end

    return true
end

---@param player unknown
---@param oldPlayer unknown?
---@return integer? userId
function API.users.ensure(player, oldPlayer)
    player = tostring(player)
    oldPlayer = tostring(oldPlayer)

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

    if oldPlayer ~= nil then
        removeCache(oldPlayer)
        connectingPlayers[oldPlayer] = nil
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

    addCache(player, userId)

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

    local principals = Storage.userToPrincipal.getAll(userId)
    for i = 1, #principals do
        Utils.addUserPrincipal(userId, principals[i])
    end
    Utils.addPlayerPrincipal(player, Utils.getUserAceName(userId))

    local name = GetPlayerName(player)
    print(('%s was assigned User ID %s'):format(name, userId))
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

    local userId = API.users.get(player)
    if userId == nil then return end

    removeCache(player)

    Utils.removePlayerPrincipal(player, Utils.getUserAceName(userId))
    local principals = Storage.userToPrincipal.getAll(userId)
    for i = 1, #principals do
        Utils.removeUserPrincipal(userId, principals[i])
    end

    local name = GetPlayerName(player)
    print(('%s was unassigned User ID %s'):format(name, userId))
    TriggerEvent('d4_playerdata:userLeft', player, userId)
end

exports('getUserId', API.users.get)
exports('getUserIdFromIdentifier', Storage.identifierToUser.get)
exports('doesUserIdExist', API.users.exists)
exports('resolveUserIds', API.users.resolve)
exports('isUserIdConnected', API.users.isConnected)
exports('getPlayersFromUserId', API.users.getPlayers)
exports('getIdentifierFromUserId', Storage.userToIdentifier.get)
exports('getIdentifiersFromUserId', Storage.userToIdentifier.getAll)
exports('deleteUserId', API.users.delete)
exports('migrateUserId', API.users.migrate)
exports('addUserIdPrincipal', API.users.addPrincipal)
exports('removeUserIdPrincipal', API.users.removePrincipal)
